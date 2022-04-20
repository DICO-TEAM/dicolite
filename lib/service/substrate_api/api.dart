import 'dart:async';
import 'dart:convert';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/farm_pool_extend_model.dart';
import 'package:dicolite/model/farm_pool_model.dart';
import 'package:dicolite/model/lbp_model.dart';
import 'package:dicolite/model/liquidity_model.dart';
import 'package:dicolite/model/token_balance_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/service/substrate_api/api_account.dart';
import 'package:dicolite/service/substrate_api/api_assets.dart';
import 'package:dicolite/service/substrate_api/api_gov.dart';
import 'package:dicolite/service/substrate_api/api_dico.dart';
import 'package:dicolite/service/substrate_api/types/genExternalLinksParams.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/local_storage.dart' as local;

Api? webApi;
String inAppUrl = "about:blank";

class Api {
  Api(this.context, this.store);

  final BuildContext context;
  final AppStore store;

  ApiDico? dico;
  ApiAccount? account;
  ApiAssets? assets;
  ApiGovernance? gov;

  Map<String, Function> _msgHandlers = {};
  Map<String, Completer> _msgCompleters = {};
  HeadlessInAppWebView? _web;
  int _evalJavascriptUID = 0;

  /// preload js code for opening dApps
  String? asExtensionJSCode;
  bool _webViewLoaded = false;
  Timer? _webViewReloadTimer;
  // Jaguar? server;
  bool hasLoadAccountData = false;

  Future<void> close() async {
    await _web?.dispose();
  }

  _setSubBalance(Map balanceData) {
    store.assets!.setAccountBalances(
        balanceData['pubKey'],
        Map.of({
          store.settings?.networkState.tokenSymbol ?? Config.tokenSymbol:
              balanceData
        }));
  }

  _setSubTokensBalance(List res) {
    List<CurrencyModel> list = [];
    for (var i = 0; i < res.length; i++) {
      CurrencyModel item = store.dico!.tokens![i];
      item.tokenBalance = TokenBalanceModel.fromJson(res[i]);
      list.add(item);
    }
    store.dico!.setTokens(list);
  }

  _setSubtokensInLPBalance(List res) {
    List<CurrencyModel> list =
        res.map((e) => CurrencyModel.fromJson(e)).toList();

    store.dico!.setTokensInLP(list);
  }

  _setSubLiquidityListChange(List? res) {
    if (res != null) {
      List<LiquidityModel> list =
          res.map((e) => LiquidityModel.fromList(e)).toList();
      if (store.dico?.liquidityList == null) {
        dico?.fetchLiquidityTokenBalance();
      }
      list = list
          .where((e) =>
              e.token1Amount != BigInt.zero && e.token2Amount != BigInt.zero)
          .toList();

      store.dico!.setLiquidityList(list);
    }
  }

  _setSubLbpPoolsChange(List? res) async {
    if (res != null) {
      Set<String> notInTokensLpIds = Set();
      res.forEach((json) {
        if (store.dico!.tokensInLPSort.indexWhere(
                (e) => e.currencyId == json["afsAsset"].toString()) ==
            -1) {
          notInTokensLpIds.add(json["afsAsset"].toString());
        }
        if (store.dico!.tokensInLPSort.indexWhere(
                (e) => e.currencyId == json["fundraisingAsset"].toString()) ==
            -1) {
          notInTokensLpIds.add(json["fundraisingAsset"].toString());
        }
      });
      List<CurrencyModel> resTokenList = [];
      if (notInTokensLpIds.isNotEmpty) {
        resTokenList =
            await dico!.fetchTokenInfoList(notInTokensLpIds.toList());
        if (resTokenList.isEmpty) return;
      }
      resTokenList.addAll(store.dico!.tokensInLPSort);
      List<LbpModel> list =
          res.map((e) => LbpModel.fromJson(e, resTokenList)).toList();
      store.dico!.setLbpPoolList(list);
    }
  }

  _setSubFarmPoolsChange(List? res) async {
    if (res != null &&
        store.dico!.liquidityList != null &&
        store.dico!.liquidityList!.isNotEmpty) {
      List<String> notInTokensLpIds = [];

      for (var json in res) {
        if (BigInt.parse(json["currencyId"].toString()) >=
            Config.liquidityFirstId) {
          int index = store.dico!.liquidityList!.indexWhere(
              (e) => e.liquidityId == json["currencyId"].toString());
          if (index == -1) {
            /// Need update liquidityList
            await dico!.subLiquidityListChange();
            Future.delayed(Duration(seconds: 3));
            dico!.subFarmPoolsChange();
            return;
          }
        } else if (store.dico!.tokensInLPSort.indexWhere(
                (e) => e.currencyId == json["currencyId"].toString()) ==
            -1) {
          notInTokensLpIds.add(json["currencyId"].toString());
        }
      }
      List<CurrencyModel> resTokenList = [];
      if (notInTokensLpIds.isNotEmpty) {
        resTokenList = await dico!.fetchTokenInfoList(notInTokensLpIds);
        if (resTokenList.isEmpty) return;
      }
      resTokenList.addAll(store.dico!.tokensInLPSort);
      List<FarmPoolModel> list = res
          .map((e) => FarmPoolModel.fromJson(
              e, store.dico!.liquidityList!, resTokenList))
          .toList();

      store.dico!.setFarmPools(list);
    } else {
      store.dico!.setFarmPools([]);
    }
  }

  _setSubFarmPoolExtendsChange(List? res) async {
    if (res != null && store.dico!.liquidityList != null) {
      Set<String> notInTokensLpIds = Set();
      print("6666666");
      print(res);
      for (var json in res) {
        if (BigInt.parse(json["currencyId"].toString()) >=
                Config.liquidityFirstId ||
            BigInt.parse(json["stakeCurrencyId"].toString()) >=
                Config.liquidityFirstId) {
          int index = store.dico!.liquidityList!.indexWhere(
              (e) => e.liquidityId == json["currencyId"].toString());
          int stakedIndex = store.dico!.liquidityList!.indexWhere(
              (e) => e.liquidityId == json["stakeCurrencyId"].toString());

          bool isRewardLp = BigInt.parse(json["currencyId"].toString()) >=
              Config.liquidityFirstId;
          bool isStakeLp = BigInt.parse(json["stakeCurrencyId"].toString()) >=
              Config.liquidityFirstId;

          if ((index == -1 && isRewardLp) || (stakedIndex == -1 && isStakeLp)) {
            /// Need update liquidityList
            await dico!.subLiquidityListChange();
            Future.delayed(Duration(seconds: 3));
            dico!.subFarmPoolExtendsChange();
            return;
          } else {
            if (!isRewardLp) {
              notInTokensLpIds.add(json["currencyId"].toString());
            }
            if (!isStakeLp) {
              notInTokensLpIds.add(json["stakeCurrencyId"].toString());
            }
          }
        } else {
          if (store.dico!.tokensInLPSort.indexWhere(
                  (e) => e.currencyId == json["currencyId"].toString()) ==
              -1) {
            notInTokensLpIds.add(json["currencyId"].toString());
          }
          if (store.dico!.tokensInLPSort.indexWhere(
                  (e) => e.currencyId == json["stakeCurrencyId"].toString()) ==
              -1) {
            notInTokensLpIds.add(json["stakeCurrencyId"].toString());
          }
        }
      }
      List<CurrencyModel> resTokenList = [];
      if (notInTokensLpIds.isNotEmpty) {
        resTokenList =
            await dico!.fetchTokenInfoList(notInTokensLpIds.toList());
        if (resTokenList.isEmpty) return;
      }
      resTokenList.addAll(store.dico!.tokensInLPSort);
      List<FarmPoolExtendModel> list = res
          .map((e) => FarmPoolExtendModel.fromJson(
              e, store.dico!.liquidityList!, resTokenList))
          .toList();

      store.dico!.setFarmPoolExtends(list);
    } else {
      store.dico!.setFarmPoolExtends([]);
    }
  }

  _setSubNewHeads(Map lastHeader) {
    store.dico!.setNewHeads(lastHeader);
  }

  ///sub status of connecting
  _setDisconnected(bool disconnected) {
    store.settings!.setNetworkLoading(disconnected);
  }

  void init() {
    dico = ApiDico(this);
    account = ApiAccount(this);
    assets = ApiAssets(this);
    gov = ApiGovernance(this);

    launchWebview();
  }

  /// get custom types
  Future<String?> _getTypes() async {
    String? types = await local.LocalStorage.getCustomTypes();
    if (types != null) {
      try {
        jsonDecode(types);
      } catch (e) {
        print(e);
        return null;
      }
    }
    return types;
  }

  Future<void> launchWebview() async {
    /// reset state before webView launch or reload
    _msgHandlers = {};
    _msgCompleters = {};
    _evalJavascriptUID = 0;
    bool hasLoadedpage = false;

    //subscription
    _msgHandlers['txStatusChange'] = store.account!.setTxStatus;
    _msgHandlers['balanceChange'] = _setSubBalance;
    _msgHandlers['tokensBalanceChange'] = _setSubTokensBalance;
    _msgHandlers['tokensInLPBalanceChange'] = _setSubtokensInLPBalance;
    _msgHandlers['newHeadsChange'] = _setSubNewHeads;
    _msgHandlers['liquidityListChange'] = _setSubLiquidityListChange;
    _msgHandlers['farmPoolsChange'] = _setSubFarmPoolsChange;
    _msgHandlers['farmPoolExtendsChange'] = _setSubFarmPoolExtendsChange;
    _msgHandlers['lbpPoolsChange'] = _setSubLbpPoolsChange;
    _msgHandlers['disconnected'] = _setDisconnected;
    // _onLaunched = onLaunched;
    _webViewLoaded = false;
    hasLoadAccountData = false;

    var _jsCode = await DefaultAssetBundle.of(context)
        .loadString('lib/polkadot_js_service/dist/main.js');

    if (_web == null) {
      _web = new HeadlessInAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(),
        ),
        onWebViewCreated: (controller) {
          print('HeadlessInAppWebView created!');
        },
        onConsoleMessage: (controller, message) {
          if (!message.message.contains('{"path":"newHeadsChange",')) {
            print("CONSOLE MESSAGE: " + message.message);
          }
          if (message.messageLevel != ConsoleMessageLevel.LOG) return;
          try {
            compute(jsonDecode, message.message).then((msg) {
              final String path = msg['path'];
              if (_msgCompleters[path] != null) {
                Completer? handler = _msgCompleters[path];
                handler?.complete(msg['data']);
                if (path.contains('uid=')) {
                  _msgCompleters.remove(path);
                  print(" unsolved：${_msgCompleters.keys}");
                }
              }
              if (_msgHandlers[path] != null) {
                Function handler = _msgHandlers[path]!;
                handler(msg['data']);
              }
            });
          } catch (e) {
            print(e);
          }
        },
        onLoadStop: (controller, url) async {
          print('webview loaded,url:$url');

          _handleReloaded();
          if (url.toString() == inAppUrl && !hasLoadedpage) {
            hasLoadedpage = true;
            await _web!.webViewController.evaluateJavascript(source: _jsCode);
            await _start();
          }
          // await _startJSCode(keyring, keyringStorage);
        },
      );

      await _web?.run();
      _web?.webViewController
          .loadUrl(urlRequest: URLRequest(url: Uri.parse(inAppUrl)));
    } else {
      _tryReload();
    }
  }

  Future<void> _start() async {
    await account?.initAccounts();
    // connect remote node
    String? customTypes = await _getTypes();
    connectNode(newTypes: customTypes);
  }

  void _tryReload() {
    if (!_webViewLoaded) {
      _web?.webViewController.reload();

      _webViewReloadTimer = Timer(Duration(seconds: 3), _tryReload);
    }
  }

  void _handleReloaded() {
    _webViewReloadTimer?.cancel();
    _webViewLoaded = true;
  }

  int _getEvalJavascriptUID() {
    return _evalJavascriptUID++;
  }

  Future<dynamic> evalJavascript(
    String code, {
    bool wrapPromise = true,
    bool allowRepeat = false,
  }) async {
    // check if there's a same request loading
    if (!allowRepeat) {
      for (String i in _msgCompleters.keys) {
        String call = code.split('(')[0];
        if (i.contains(call)) {
          print('request $call loading');
          return _msgCompleters[i]?.future;
        }
      }
    }

    if (!wrapPromise) {
      final res =
          await _web!.webViewController.evaluateJavascript(source: code);
      return res;
    }

    Completer c = new Completer();

    final uid = _getEvalJavascriptUID();
    final method = 'uid=$uid;${code.split('(')[0]}';
    _msgCompleters[method] = c;

    String script = '$code.then(function(res) {'
        '  console.log(JSON.stringify({ path: "$method", data: res }));'
        '}).catch(function(err) {'
        '  console.log(JSON.stringify({ path: "log", data: err.message }));'
        '});$uid;';
    _web!.webViewController.evaluateJavascript(source: script);

    return c.future;
  }

  Future<void> connectNode({String? newTypes}) async {
    String endpoint = store.settings!.endpoint.value;

    String types = newTypes != null ? newTypes : '';

    String? res = await evalJavascript('settings.connect("$endpoint",$types)');
    print("=============$res");
    if (res == null) {
      print('connect failed');

      store.settings!.setNetworkName('');
      return;
    }
    await fetchNetworkProps();
  }

  Future<void> changeNode() async {
    store.settings!.setNetworkLoading(true);
    store.dico!.clearState();
    await store.dico!.getTokens();
    await _web?.dispose();
    _web = null;
    launchWebview();
  }

  Future<void> fetchNetworkProps() async {
    // fetch network info
    List<dynamic> info = await evalJavascript('settings.fetchNetworkInfo()');

    store.settings!.setNetworkConst(info[0]);
    store.settings!.setNetworkState(info[1]);
    store.settings!.setNetworkName(info[2]);

    if (store.account!.accountList.length > 0) {
      afterLoadAccountData();
    }
  }

  Future<void> updateBlocks(List txs) async {
    Map<int, bool> blocksNeedUpdate = Map<int, bool>();
    txs.forEach((i) {
      int block = i['attributes']['block_id'];
      if (store.assets!.blockMap[block] == null) {
        blocksNeedUpdate[block] = true;
      }
    });
    String blocks = blocksNeedUpdate.keys.join(',');
    var data = await evalJavascript('account.getBlockTime([$blocks])');

    store.assets!.setBlockMap(data);
  }

  Future<String> subscribeBestNumber(Function callback) async {
    final String channel = _getEvalJavascriptUID().toString();
    subscribeMessage(
        'settings.subscribeMessage("chain", "bestNumber", [], "$channel")',
        channel,
        callback);
    return channel;
  }

  Future<void> subscribeMessage(
    String code,
    String channel,
    Function callback,
  ) async {
    _msgHandlers[channel] = callback;
    evalJavascript(code, allowRepeat: true);
  }

  Future<void> unsubscribeMessage(String channel) async {
    final unsubCall = 'unsub$channel';
    _web?.webViewController
        .evaluateJavascript(source: 'window.$unsubCall && window.$unsubCall()');
  }

  Future<List> getExternalLinks(GenExternalLinksParams params) async {
    final List res = await evalJavascript(
      'settings.genLinks(${jsonEncode(GenExternalLinksParams.toJson(params))})',
      allowRepeat: true,
    );
    return res;
  }

  ///After load account data
  afterLoadAccountData() async {
    store.dico!.clearState();
    if (account != null && store.account!.accountList.length > 0) {
      await dico!.subChangeTogether();

      await dico!.subTokensBalanceChange();
      hasLoadAccountData = true;

      await dico!.fetchInitData();

      await dico!.fetchDaoProposeList();
      await dico!.subFarmPoolsChange();
      await dico!.subFarmPoolExtendsChange();
      await account!.fetchAccountsIndex();

      account!.getPubKeyIcons([store.account!.currentAccount.pubKey]);
    }
  }
}
