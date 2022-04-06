import 'dart:async';
import 'dart:convert';

import 'package:dicolite/config/config.dart';
import 'package:dicolite/config/country_code_english.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/ico_lock_model.dart';
import 'package:dicolite/model/ico_model.dart';
import 'package:dicolite/model/ico_unrelease_assets_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/contacts/contact_list_page.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/page-bg.dart';
import 'package:dicolite/widgets/jump_to_browser_link.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:flutter/material.dart';

import 'package:dicolite/widgets/rounded_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class IcoParticipate extends StatefulWidget {
  IcoParticipate(this.store);
  static final String route = '/ico/IcoParticipate';
  final AppStore store;

  @override
  _IcoParticipate createState() => _IcoParticipate(store);
}

class _IcoParticipate extends State<IcoParticipate> {
  _IcoParticipate(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtrl = new TextEditingController();
  final TextEditingController _inviterCtrl = new TextEditingController();
  IcoModel? ico;
  CurrencyModel? exchangeToken;
  bool _enableBtn = false;
  bool _isShowDetail = false;
  IcoUnreleaseAssetsModel? userJoinAmount;
  IcoLockModel? locks;
  BigInt? _minAmount;
  BigInt? _maxAmount;

  /// [canRelease, canUnlock, reward]
  List<BigInt> amount3 = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var args = ModalRoute.of(context)!.settings.arguments as IcoModel;
      _getTokenInfo(args.exchangeToken);
      _getUserJoinAmount();
      _getAmountData();
      int blockTime = widget.store.settings?.blockDuration ?? 12;
      _timer = Timer.periodic(Duration(milliseconds: blockTime), (timer) {
        _getAmountData();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _amountCtrl.dispose();
    _inviterCtrl.dispose();
  }

  /// get token info by currencyId
  Future _getTokenInfo(String id) async {
    if (id == Config.tokenId) {
      setState(() {
        exchangeToken = store.dico!.tokensSort[0];
      });
      return;
    }
    var res = await webApi?.dico?.fetchTokenInfo(id);

    if (mounted) {
      setState(() {
        exchangeToken = res != null && res["metadata"] != null
            ? CurrencyModel.fromJson(res)
            : null;
      });
    }
  }

  /// get  amount data
  Future _getAmountData() async {
    List? res =
        await webApi?.dico?.fetchIcoGetAmount(ico!.currencyId, ico!.index);
    if (res != null && mounted && res.isNotEmpty) {
      List<IcoLockModel> list =
          (res[0] as List).map((e) => IcoLockModel.fromJson(e)).toList();
      List<BigInt> list2 = [res[1], res[2], res[3]]
          .map((e) => BigInt.parse(e.toString()))
          .toList();
      int index = list.indexWhere((e) => e.index == ico!.index);
      setState(() {
        locks = list.isEmpty || index == -1 ? null : list[index];
        amount3 = list2;
        _minAmount = BigInt.parse(res[4][0].toString());
        _maxAmount = BigInt.parse(res[4][1].toString());
      });
    }
  }

  /// get user join ico amount
  Future _getUserJoinAmount() async {
    List? res = await webApi?.dico?.fetchUserJoinIcoAmount();
    if (res != null && mounted) {
      List<IcoUnreleaseAssetsModel> list =
          res.map((e) => IcoUnreleaseAssetsModel.fromJson(e)).toList();
      int index = list.indexWhere(
          (e) => e.currencyId == ico!.currencyId && e.index == ico!.index);
      setState(() {
        userJoinAmount = index == -1 ? null : list[index];
      });
    }
  }

  /// user join ico
  Future _submit() async {
    if (_formKey.currentState!.validate() && exchangeToken != null) {
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).ParticipateInFundraising,
        module: 'ico',
        call: 'join',
        detail: jsonEncode({
          "currencyId": ico!.currencyId,
          "index": ico!.index,
          "amount": _amountCtrl.text.trim(),
          "inviter": _inviterCtrl.text.trim().isEmpty
              ? null
              : _inviterCtrl.text.trim(),
        }),
        params: [
          ico!.currencyId,
          ico!.index,
          Fmt.tokenInt(_amountCtrl.text.trim(), exchangeToken!.decimals)
              .toString(),
          _inviterCtrl.text.trim().isEmpty ? null : _inviterCtrl.text.trim()
        ],
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  /// user release
  Future _release(BuildContext context) async {
    TxConfirmParams args = TxConfirmParams(
        title: S.of(context).release,
        module: 'ico',
        call: 'userReleaseIcoAmount',
        params: [
          ico!.currencyId,
          ico!.index,
        ],
        detail: jsonEncode({
          "currencyId": ico!.currencyId,
          "index": ico!.index,
        }),
        onSuccess: (Map res) {
          globalIcoRefreshKey.currentState?.show();
        });

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(Home.route));
    }
  }

  /// user getReward
  Future _getReward(BuildContext context) async {
    if (store.account!.currentAccount.address != ico!.initiator) {
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).getReward,
        module: 'ico',
        call: 'getReward',
        params: [
          ico!.currencyId,
          ico!.index,
        ],
        detail: jsonEncode({
          "currencyId": ico!.currencyId,
          "index": ico!.index,
        }),
        onSuccess: (Map res) {},
      );
      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  /// user unlock
  Future _unlock(BuildContext context) async {
    if (store.account!.currentAccount.address != ico!.initiator) {
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).unlock,
        module: 'ico',
        call: 'unlock',
        params: [
          ico!.currencyId,
          ico!.index,
        ],
        detail: jsonEncode({
          "currencyId": ico!.currencyId,
          "index": ico!.index,
        }),
        onSuccess: (Map res) {},
      );
      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  Widget detailWidget(S dic, int blockTime) {
    TextStyle style =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: Adapt.px(24));
    TextStyle style2 =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: Adapt.px(24));

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Config.bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.totalIssuance,
                style: style,
              ),
              Text(
                Fmt.token(ico!.totalIssuance, ico!.decimals) +
                    " " +
                    ico!.tokenSymbol,
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.totalCirculation,
                style: style,
              ),
              Text(
                Fmt.token(ico!.totalCirculation, ico!.decimals) +
                    " " +
                    ico!.tokenSymbol,
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.icoDuration,
                style: style,
              ),
              Text(
                Fmt.blockToTime(ico!.icoDuration, blockTime),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.index,
                style: style,
              ),
              Text(
                ico!.index.toString(),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.lockProportion,
                style: style,
              ),
              Text(
                "${ico!.lockProportion}%",
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.perDurationUnlockAmount,
                style: style,
              ),
              Text(
                Fmt.token(ico!.perDurationUnlockAmount, ico!.decimals) +
                    " " +
                    ico!.tokenSymbol,
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.unlockDuration,
                style: style,
              ),
              Text(
                Fmt.blockToTime(ico!.unlockDuration, blockTime),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.userIcoMaxTimes,
                style: style,
              ),
              Text(
                ico!.userIcoMaxTimes.toString(),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.currencyId,
                style: style,
              ),
              Text(
                ico!.currencyId.toString(),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.exchangeTokenId,
                style: style,
              ),
              Text(
                ico!.exchangeToken.toString(),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  dic.initiator,
                  style: style,
                ),
              ),
              Row(
                children: [
                  AddressIcon(
                    ico!.initiator,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Fmt.address(ico!.initiator),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.officialWebsite,
                style: style,
              ),
              JumpToBrowserLink(
                ico!.officialWebsite,
                text: Fmt.address(ico!.officialWebsite),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    ico = ModalRoute.of(context)!.settings.arguments as IcoModel;

    int blockTime = widget.store.settings?.blockDuration ?? 0;
    String excluedAreaString = "";

    List<String> list = [];
    countryCodeEnglish.forEach((e) {
      if (ico!.excludeArea.contains(e["code"])) {
        list.add(e["name"] as String);
      }
    });
    excluedAreaString = list.join(", ");

    return Observer(builder: (_) {
      int nowBlock = store.dico?.newHeads?.number ?? 0;
      bool isStarted = ico!.startTime! - nowBlock < 0;
      bool isFinished = (ico!.icoDuration + ico!.startTime! - nowBlock <= 0) ||
          ico!.totalUnrealeaseAmount >= ico!.exchangeTokenTotalAmount ||
          ico!.isTerminated;

      bool isInitiator =
          store.account!.currentAccount.address == ico!.initiator;

      BigInt releasable = BigInt.zero;
      if (userJoinAmount != null && amount3.isNotEmpty) {
        releasable = amount3[0];
      }
      BigInt unlockable = BigInt.zero;
      if (locks != null && amount3.isNotEmpty) {
        unlockable = amount3[1];
      }
      BigInt rewardable = BigInt.zero;
      if (amount3.isNotEmpty) {
        rewardable = amount3[2];
      }

      return Scaffold(
        // appBar: myAppBar(context, dic.detail,isThemeBg: true),
        body: PageBg(
          title: dic.detail,
          child: exchangeToken == null || nowBlock == 0
              ? LoadingWidget()
              : Container(
                  // color:Config.bgColor,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: ListView(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 15, left: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Logo(
                                            symbol: ico!.tokenSymbol,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            ico!.projectName,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    timeWidget(
                                        dic, isStarted, isFinished, blockTime),
                                  ],
                                ),
                              ),
                              RoundedCard(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 30, 15, 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  Fmt.token(ico!.totalIcoAmount,
                                                      ico!.decimals),
                                                  style: TextStyle(
                                                      fontSize: Adapt.px(36),
                                                      color: Color(0xFFF5673A),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  dic.totalIcoAmount,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  Fmt.token(
                                                      ico!.exchangeTokenTotalAmount,
                                                      exchangeToken!.decimals),
                                                  style: TextStyle(
                                                      fontSize: Adapt.px(36),
                                                      color: Color(0xFFF5673A),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  dic.exchangeTokenTotalAmount,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                ((ico!.totalUnrealeaseAmount /
                                                                ico!.exchangeTokenTotalAmount) *
                                                            100)
                                                        .toStringAsFixed(1) +
                                                    "%",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                dic.progressRate,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                exchangeToken?.symbol ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                dic.exchangeToken,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                ico!.isMustKyc
                                                    ? dic.yes
                                                    : dic.no,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                dic.isMustKyc,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Divider(),
                                      Wrap(
                                        children: [
                                          Text(ico!.desc),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              RoundedCard(
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    ico!.isMustKyc&&ico!.excludeArea.isNotEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dic.excludeArea,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                excluedAreaString,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                              Divider(),
                                            ],
                                          )
                                        : Container(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _isShowDetail = !_isShowDetail;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Text(dic.detail),
                                              Icon(
                                                _isShowDetail
                                                    ? Icons.arrow_drop_down
                                                    : Icons.arrow_right,
                                                size: 28,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    AnimatedContainer(
                                      height: _isShowDetail ? 260 : 0,
                                      duration: Duration(microseconds: 500),
                                      curve: Curves.fastOutSlowIn,
                                      child: detailWidget(dic, blockTime),
                                    ),
                                  ],
                                ),
                              ),
                              userJoinAmount != null && exchangeToken != null
                                  ? releaseAndReward(dic, isInitiator,
                                      releasable, unlockable, rewardable)
                                  : Container(),
                              userJoinAmount != null &&
                                      exchangeToken != null &&
                                      !isInitiator
                                  ? RoundedCard(
                                      color: Theme.of(context).primaryColor,
                                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      padding: EdgeInsets.all(
                                        15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dic.myRecord,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(color: Colors.white),
                                          ),
                                          Divider(
                                            color: Colors.white70,
                                          ),
                                          userJoinAmount!.inviter != null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      dic.inviter,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                    Row(
                                                      children: [
                                                        AddressIcon(
                                                          userJoinAmount!
                                                              .inviter!,
                                                          size: 18,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          Fmt.address(
                                                              userJoinAmount!
                                                                  .inviter!),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dic.totalValue,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                Fmt.token(userJoinAmount!.total,
                                                        ico!.decimals) +
                                                    " " +
                                                    ico!.tokenSymbol,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Column(
                                              children: userJoinAmount!.tags
                                                  .asMap()
                                                  .keys
                                                  .map(
                                                    (i) => Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "#${i + 1}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          Fmt.token(
                                                                  userJoinAmount!
                                                                      .tags[i],
                                                                  exchangeToken!
                                                                      .decimals) +
                                                              " " +
                                                              exchangeToken!
                                                                  .symbol,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList()),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              formWidget(
                                  dic, isStarted, isFinished, isInitiator),
                            ],
                          ),
                        ),
                      ),
                      isStarted && !isFinished && !isInitiator
                          ? Container(
                              margin: EdgeInsets.all(15),
                              child: RoundedButton(
                                round: true,
                                text: dic.submit,
                                onPressed: _enableBtn ? _submit : null,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  formWidget(S dic, bool isStarted, bool isFinished, bool isInitiator) {
    String helpText = dic.inviterTips1 +
        store.settings!.networkState.tokenSymbol +
        dic.inviterTips2 +
        int.parse(store.settings!.networkConst["ico"]
                    ?["inviteeRewardProportion"] ??
                "0")
            .toString() +
        dic.inviterTips3 +
        int.parse(store.settings!.networkConst["ico"]
                    ?["inviterRewardProportion"] ??
                "0")
            .toString() +
        "%";
    return isStarted &&
            !isFinished &&
            !isInitiator &&
            _minAmount != null &&
            _maxAmount != null &&
            exchangeToken != null &&
            ico!.isTerminated == false
        ? RoundedCard(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: () => setState(
                  () => _enableBtn = _formKey.currentState!.validate()),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      filled: false,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9AA7B5))),
                      labelText: dic.investment_amount +
                          "(${Fmt.token(_minAmount, exchangeToken!.decimals)}~${Fmt.token(_maxAmount, exchangeToken!.decimals)} ${exchangeToken!.symbol})",
                      suffixText: exchangeToken?.symbol,
                    ),
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      UI.decimalInputFormatter(exchangeToken!.decimals)
                    ],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (Fmt.tokenInt(val, exchangeToken!.decimals) >
                          exchangeToken!.tokenBalance.free) {
                        return dic.amount_low +
                            "; < " +
                            Fmt.token(exchangeToken!.tokenBalance.free,
                                exchangeToken!.decimals) +
                            " " +
                            exchangeToken!.symbol;
                      } else if (Fmt.tokenInt(val, exchangeToken!.decimals) >
                          (ico!.exchangeTokenTotalAmount -
                              ico!.totalUnrealeaseAmount)) {
                        return dic.amount_too_high;
                      } else if (Fmt.tokenInt(val, exchangeToken!.decimals) >
                          (_maxAmount!)) {
                        return dic.amount_too_high;
                      } else if (Fmt.tokenInt(val, exchangeToken!.decimals) <
                          (_minAmount!)) {
                        return dic.amount_too_low;
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: false,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9AA7B5))),
                      labelText: dic.inviterOptional,
                      helperText: helpText,
                      helperStyle: TextStyle(fontSize: Adapt.px(20)),
                      suffix: GestureDetector(
                        child: Image.asset(
                            'assets/images/main/my-accountmanage.png'),
                        onTap: () async {
                          var to = await Navigator.of(context)
                              .pushNamed(ContactListPage.route);
                          if (to != null && mounted) {
                            setState(() {
                              _inviterCtrl.text = (to as AccountData).address;
                            });
                          }
                        },
                      ),
                    ),
                    controller: _inviterCtrl,
                    validator: (v) {
                      if (v!.trim().isEmpty) {
                        return null;
                      } else if (store.account!.currentAddress == v.trim()) {
                        return dic.doNotAddYourOwnAddresses;
                      }
                      return Fmt.isAddress(v.trim()) ? null : dic.address_error;
                    },
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  timeWidget(S dic, bool isStarted, bool isFinished, int blockTime) {
    if (isFinished) {
      return Container(
        padding: EdgeInsets.fromLTRB(15, 7, 10, 7),
        decoration: BoxDecoration(
            color: Color(0xFFFFC34F),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(50))),
        child: Text(
          ico!.isTerminated ? dic.terminated : dic.finished,
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Container(
      height: 38,
      child: Stack(
        children: [
          Container(
            height: 38,
            padding: EdgeInsets.fromLTRB(15, 7, 10, 7),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(50))),
            child: Text(
              isStarted
                  ? Fmt.blockToTime(
                      ico!.icoDuration +
                          ico!.startTime! -
                          (store.dico?.newHeads?.number ?? 0),
                      blockTime)
                  : Fmt.blockToTime(
                      ico!.startTime! - (store.dico?.newHeads?.number ?? 0),
                      blockTime),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
              top: 1,
              right: 0,
              child: Container(
                width: 1,
                height: 36,
                color: Theme.of(context).primaryColor,
              )),
        ],
      ),
    );
  }

  releaseAndReward(S dic, bool isInitiator, BigInt releasable,
      BigInt unlockable, BigInt rewardable) {
    return RoundedCard(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            userJoinAmount != null && exchangeToken != null
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dic.unReleased +
                                "(${isInitiator ? exchangeToken!.symbol : ico!.tokenSymbol})",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            Fmt.token(
                                userJoinAmount!.total -
                                    userJoinAmount!.released,
                                isInitiator
                                    ? exchangeToken!.decimals
                                    : ico!.decimals),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Adapt.px(30),
                                      color: Colors.black,
                                    ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dic.releasable +
                                "(${isInitiator ? exchangeToken!.symbol : ico!.tokenSymbol})",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                releasable > BigInt.zero
                                    ? GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(
                                            Icons.lock_open,
                                            size: 20,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onTap: () => _release(context),
                                      )
                                    : Container(),
                                Text(
                                  Fmt.token(
                                      releasable,
                                      isInitiator
                                          ? exchangeToken!.decimals
                                          : ico!.decimals),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Adapt.px(30),
                                        color: releasable > BigInt.zero
                                            ? Theme.of(context).primaryColor
                                            : Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),

            /// locks
            locks != null
                ? Column(
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dic.locks + "(${ico!.tokenSymbol})",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            Fmt.token(locks!.totalAmount - locks!.unlockAmount,
                                ico!.decimals),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Adapt.px(30),
                                      color: Colors.black,
                                    ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dic.unlockable + "(${ico!.tokenSymbol})",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                unlockable > BigInt.zero
                                    ? GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(
                                            Icons.lock_open,
                                            size: 20,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onTap: () => _unlock(context),
                                      )
                                    : Container(),
                                Text(
                                  Fmt.token(unlockable, ico!.decimals),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Adapt.px(30),
                                        color: unlockable > BigInt.zero
                                            ? Theme.of(context).primaryColor
                                            : Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),

            userJoinAmount != null && !isInitiator
                ? Column(
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dic.reward +
                                "(${store.settings!.networkState.tokenSymbol})",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                rewardable > BigInt.zero
                                    ? GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(
                                            Icons.lock_open,
                                            size: 20,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onTap: () => _getReward(context),
                                      )
                                    : Container(),
                                Text(
                                  Fmt.token(
                                      rewardable == BigInt.zero
                                          ? userJoinAmount!.reward
                                          : rewardable,
                                      store.settings!.networkState
                                          .tokenDecimals),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Adapt.px(30),
                                        color: rewardable > BigInt.zero
                                            ? Theme.of(context).primaryColor
                                            : Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
          ],
        ));
  }
}
