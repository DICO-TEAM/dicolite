import 'dart:async';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/common/address_form_item.dart';
import 'package:dicolite/common/settings.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/my_appbar.dart';

class TxConfirmParams {
  TxConfirmParams({
    required this.title,
    required this.module,
    required this.call,
    required this.detail,
    required this.params,
    this.rawParams,
    this.isUnsigned,
    this.txName,
    this.onSuccess,
  });
  final String title;
  final String module;
  final String call;
  final List params;
  final String? rawParams;
  final bool? isUnsigned;
  final String detail;
  final String? txName;
  final Function(Map res)? onSuccess;
}

class TxConfirmPage extends StatefulWidget {
  const TxConfirmPage(this.store);

  static final String route = '/tx/confirm';
  final AppStore store;

  @override
  _TxConfirmPageState createState() => _TxConfirmPageState(store);
}

class _TxConfirmPageState extends State<TxConfirmPage> {
  _TxConfirmPageState(this.store);

  final AppStore store;

  Map _fee = {};
  double _tip = 0;
  BigInt _tipValue = BigInt.zero;
  AccountData? _proxyAccount;

  Future<String> _getTxFee({bool reload = false}) async {
    if (_fee['partialFee'] != null && !reload) {
      return _fee['partialFee'].toString();
    }
    if (store.account!.currentAccount.observation) {
      webApi!.account!.queryRecoverable(store.account!.currentAddress);
    }

    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;
    Map txInfo = {
      'module': args.module,
      'call': args.call,
      'pubKey': store.account!.currentAccount.pubKey,
      'address': store.account!.currentAddress,
      'txName': args.txName,
    };
    if (_proxyAccount != null) {
      txInfo['proxy'] = _proxyAccount!.pubKey;
    }
    Map? fee = await webApi!.account!
        .estimateTxFees(txInfo, args.params, rawParam: args.rawParams);
    if (mounted) {
      setState(() {
        _fee = fee ?? {};
      });
    }
    if (fee == null) return '';
    return fee['partialFee'].toString();
  }

  // Future<void> _onSwitch(bool value) async {
  //   if (value) {
  //     final acc = await Navigator.of(context).pushNamed(
  //       ContactListPage.route,
  //       arguments: store.account!.accountListAll.toList(),
  //     );
  //     if (acc != null) {
  //       if (mounted) {
  //         setState(() {
  //           _proxyAccount = acc as AccountData;
  //         });
  //       }
  //     }
  //   } else {
  //     if (mounted) {
  //       setState(() {
  //         _proxyAccount = null;
  //       });
  //     }
  //   }
  //   _getTxFee(reload: true);
  // }

  void _onTxFinish(BuildContext context, Map res, TxConfirmParams args) {
    if (mounted) {
      final state = ScaffoldMessenger.of(context);

      state.removeCurrentSnackBar();
      state.showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        content: ListTile(
          leading: Container(
            width: 24,
            child: Image.asset('assets/images/main/receive-success.png'),
          ),
          title: Text(
            S.of(context).success,
            style: TextStyle(color: Colors.black54),
          ),
        ),
        duration: Duration(seconds: 1),
      ));

      Timer(Duration(seconds: 1), () {
        if (state.mounted) {
          Navigator.of(context).pop(res);
          if (args.onSuccess != null) args.onSuccess!(res);
        }
      });
    } else {
      showSuccessMsg("Success\n${args.module}.${args.call}");
      if (args.onSuccess != null) args.onSuccess!(res);
    }
  }

  void _onTxError(BuildContext context, String errorMsg, TxConfirmParams args) {
    if (mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (errorMsg.contains('Invalid Transaction: Payment')) {
        errorMsg = S.of(context).amount_low;
      } else if (errorMsg == 'fail') {
        errorMsg = S.of(context).fail;
      }
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Container(),
            content: Text(errorMsg),
            actions: <Widget>[
              CupertinoButton(
                child: Text(S.of(context).ok),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      showErrorMsg("Failed!\n${args.module}.${args.call}\n$errorMsg");
    }
  }

  Future<void> _authAndSubmit(BuildContext context) async {
    var password = await doAuth(context, store.account!.currentAccountPubKey);
    if (password != null) {
      _onSubmit(context, password: password);
    }
  }

  Future<void> _onSubmit(
    BuildContext context, {
    required String password,
    // bool viaQr = false,
  }) async {
    // final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    // Loading.showLoading(context);
    store.assets!.setSubmitting(true);
    store.account!.setTxStatus('queued');

    _upDateTxStatus();

    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;
    Map txInfo = {
      'module': args.module,
      'call': args.call,
      'pubKey': store.account!.currentAccount.pubKey,
      'address': store.account!.currentAddress,
      'password': password,
      'tip': _tipValue.toString(),
      'txName': args.txName,
    };
    if (_proxyAccount != null) {
      txInfo['proxy'] = _proxyAccount!.pubKey;
    }

    if (_proxyAccount != null) {
      txInfo['proxy'] = _proxyAccount!.pubKey;
      txInfo['ss58'] = store.settings!.endpoint.ss58.toString();
    }

    final Map res = await _sendTx(context, txInfo, args);

    // Loading.hideLoading(context);
    store.assets!.setSubmitting(false);
    if (res['hash'] == null) {
      _onTxError(context, res['error'], args);
    } else {
      _onTxFinish(context, res, args);
    }
  }

  Future<Map> _sendTx(
      BuildContext context, Map txInfo, TxConfirmParams args) async {
    return await webApi!.account!.sendTx(
      txInfo,
      args.params,
      args.title,
      S.of(context).notify_submitted,
      rawParam: args.rawParams,
    );
  }

  void _onTipChanged(double tip) {
    final decimals = store.settings!.networkState.tokenDecimals;

    /// tip division from 0 to 19:
    /// 0-10 for 0-0.1
    /// 10-19 for 0.1-1
    BigInt value = Fmt.tokenInt('0.01', decimals) * BigInt.from(tip.toInt());
    if (tip > 10) {
      value = Fmt.tokenInt('0.1', decimals) * BigInt.from((tip - 9).toInt());
    }
    if (mounted) {
      setState(() {
        _tip = tip;
        _tipValue = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      webApi!.gov!.updateBestNumber();
    });
  }

  @override
  void dispose() {
    store.assets!.setSubmitting(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final String symbol = store.settings!.networkState.tokenSymbol;
    final int decimals = store.settings!.networkState.tokenDecimals;
    final String tokenView = Fmt.tokenView(symbol);

    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;

    bool isUnsigned = args.isUnsigned ?? false;
    return WillPopScope(
      onWillPop: () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: myAppBar(context, args.title, onBack: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }),
        body: Observer(builder: (BuildContext context) {
          final bool isObservation = store.account!.currentAccount.observation;
          final bool isProxyObservation = _proxyAccount != null
              ? _proxyAccount?.observation ?? false
              : false;
          // final AccountRecoveryInfo recoverable = store.account!.recoveryInfo;

          final bool isPolkadot =
              store.settings!.endpoint.info == network_name_kusama;
          bool isTxPaused = isPolkadot;
          if (isTxPaused &&
              store.gov!.bestNumber > 0 &&
              (store.gov!.bestNumber < dot_re_denominate_block - 1200 ||
                  store.gov!.bestNumber > dot_re_denominate_block + 1200)) {
            isTxPaused = false;
          }

          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    RoundedCard(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              dic.submit_tx,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          isUnsigned
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: AddressFormItem(
                                    store.account!.currentAccount,
                                    label: dic.submit_from,
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 64,
                                  child: Text(
                                    dic.submit_call,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Text(
                                  '${args.module}.${args.call}',
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 64,
                                  child: Text(
                                    dic.detail,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .width -
                                      120,
                                  child: Text(
                                    args.detail,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          isUnsigned
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        width: 64,
                                        child: Text(
                                          dic.submit_fees,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      FutureBuilder<String>(
                                        future: _getTxFee(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData &&
                                              _fee['partialFee'] != null) {
                                            String fee = Fmt.balance(
                                              _fee['partialFee'].toString(),
                                              decimals,
                                              length: 6,
                                            );
                                            return Container(
                                              margin: EdgeInsets.only(top: 8),
                                              width: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .width -
                                                  120,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    '$fee $tokenView',
                                                  ),
                                                  Text(
                                                    '${_fee['weight']} Weight',
                                                    style: TextStyle(
                                                      fontSize: Adapt.px(26),
                                                      color: Theme.of(context)
                                                          .unselectedWidgetColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return CupertinoActivityIndicator();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 64,
                                  child: Text(
                                    dic.tip,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Text(
                                    '${Fmt.token(_tipValue, decimals)} $tokenView'),
                                Tooltip(
                                  message: dic.tip_tip,
                                  child: Icon(
                                    Icons.info,
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Text('0'),
                                Expanded(
                                  child: Slider(
                                    min: 0,
                                    max: 19,
                                    divisions: 19,
                                    value: _tip,
                                    onChanged: store.assets!.submitting
                                        ? null
                                        : _onTipChanged,
                                  ),
                                ),
                                Text('1')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: Adapt.px(300)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(16))),
                          child: Text(dic.cancel,
                              style: TextStyle(color: Colors.grey)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Adapt.px(50))),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(20))),
                        child: Text(
                          isUnsigned
                              ? dic.submit_no_sign
                              : (isObservation && _proxyAccount == null) ||
                                      isProxyObservation
                                  ?
                                  // dic.submit_qr
                                  dic.observe_invalid
                                  : dic.submit_send,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: isTxPaused || _fee['partialFee'] == null
                            ? null
                            // : isUnsigned
                            //     ? () => _onSubmit(context)
                            : (isObservation && _proxyAccount == null) ||
                                    isProxyObservation
                                ? null
                                : store.assets!.submitting
                                    ? null
                                    : () => _authAndSubmit(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void _upDateTxStatus() {
    String text = S.of(context).tx_wait;

    switch (store.account!.txStatus) {
      case "Inblock":
        text = S.of(context).tx_Inblock;
        break;
      case "tx_Ready":
        text = S.of(context).tx_Ready;
        break;
      case "Broadcast":
        text = S.of(context).tx_Broadcast;
        break;
      default:
        text = S.of(context).tx_wait;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: ListTile(
        leading: CupertinoActivityIndicator(),
        title: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      duration: Duration(minutes: 5),
    ));
  }
}
