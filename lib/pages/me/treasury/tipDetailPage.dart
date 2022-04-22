import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/council/candidateDetailPage.dart';
import 'package:dicolite/pages/me/treasury/treasuryPage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/gov/types/treasuryTipData.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/bordered_title.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class TipDetailPage extends StatefulWidget {
  TipDetailPage(this.store);

  static const String route = '/gov/treasury/tip';

  final AppStore store;

  @override
  _TipDetailPageState createState() => _TipDetailPageState();
}

class _TipDetailPageState extends State<TipDetailPage> {
  final TextEditingController _tipInputCtrl = TextEditingController();

  Future<void> _onEndorse() async {
    final String symbol = widget.store.settings!.networkState.tokenSymbol;
    final int decimals = widget.store.settings!.networkState.tokenDecimals;
    final String tokenView = Fmt.tokenView(symbol);
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final S dic = S.of(context);
        return CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('${dic.treasury_tip} - ${dic.treasury_endorse}'),
          ),
          content: CupertinoTextField(
            controller: _tipInputCtrl,
            suffix: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(tokenView),
            ),
            inputFormatters: [UI.decimalInputFormatter(decimals)],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                dic.cancel,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                setState(() {
                  _tipInputCtrl.text = '';
                });
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(dic.ok),
              onPressed: () {
                try {
                  final value = double.parse(_tipInputCtrl.text);
                  if (value >= 0) {
                    Navigator.of(context).pop();
                    _onEndorseSubmit();
                  } else {
                    _showTipInvalid();
                  }
                } catch (err) {
                  _showTipInvalid();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTipInvalid() async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final S dic = S.of(context);
        return CupertinoAlertDialog(
          title: Container(),
          content: Text(dic.input_invalid),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                dic.cancel,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                setState(() {
                  _tipInputCtrl.text = '';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onEndorseSubmit() async {
    var dic = S.of(context);
    int decimals = widget.store.settings!.networkState.tokenDecimals;
    final TreasuryTipData tipData =
        ModalRoute.of(context)!.settings.arguments as TreasuryTipData;
    String amt = _tipInputCtrl.text.trim();
    TxConfirmParams args = TxConfirmParams(
      title: '${dic.treasury_tip} - ${dic.treasury_endorse}',
      module: 'treasury',
      call: 'tip',
      detail: jsonEncode({
        "hash": Fmt.address(tipData.hash, pad: 16),
        "tipValue": amt,
      }),
      params: [
        // "hash"
        tipData.hash,
        // "tipValue"
        Fmt.tokenInt(amt, decimals).toString(),
      ],
      onSuccess: (res) {
        globalTipsRefreshKey.currentState?.show();
      },
    );
    setState(() {
      _tipInputCtrl.text = '';
    });
    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(TreasuryPage.route));
    }
  }

  Future<void> _onCancel() async {
    var dic = S.of(context);
    final TreasuryTipData tipData =
        ModalRoute.of(context)!.settings.arguments as TreasuryTipData;
    TxConfirmParams args = TxConfirmParams(
      title: '${dic.treasury_tip} - ${dic.treasury_retract}',
      module: 'treasury',
      call: 'retractTip',
      detail: jsonEncode({"hash": Fmt.address(tipData.hash, pad: 16)}),
      params: [tipData.hash],
      onSuccess: (res) {
        globalTipsRefreshKey.currentState?.show();
      },
    );
    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(TreasuryPage.route));
    }
  }

  Future<void> _onCloseTip() async {
    var dic = S.of(context);
    final TreasuryTipData tipData =
        ModalRoute.of(context)!.settings.arguments as TreasuryTipData;
    TxConfirmParams args = TxConfirmParams(
      title: '${dic.treasury_tip} - ${dic.treasury_closeTip}',
      module: 'treasury',
      call: 'closeTip',
      detail: jsonEncode({"hash": Fmt.address(tipData.hash, pad: 16)}),
      params: [tipData.hash],
      onSuccess: (res) {
        globalTipsRefreshKey.currentState?.show();
      },
    );
    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(TreasuryPage.route));
    }
  }

  Future<void> _onTip(BigInt median) async {
    var dic = S.of(context);
    final int decimals = widget.store.settings!.networkState.tokenDecimals;
    final TreasuryTipData tipData =
        ModalRoute.of(context)!.settings.arguments as TreasuryTipData;
    TxConfirmParams args = TxConfirmParams(
      title: '${dic.treasury_tip} - ${dic.treasury_jet}',
      module: 'treasury',
      call: 'tip',
      detail: jsonEncode({
        "hash": Fmt.address(tipData.hash, pad: 16),
        "median": Fmt.token(median, decimals),
      }),
      params: [tipData.hash, median.toString()],
      onSuccess: (res) {
        globalTipsRefreshKey.currentState?.show();
      },
    );
    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(TreasuryPage.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final String symbol = widget.store.settings!.networkState.tokenSymbol;
    final int decimals = widget.store.settings!.networkState.tokenDecimals;
    final TreasuryTipData tipData =
        ModalRoute.of(context)!.settings.arguments as TreasuryTipData;
    final AccountData who = AccountData();
    final AccountData finder = AccountData();
    who.address = tipData.who;
    final Map? accInfo = widget.store.account!.addressIndexMap[who.address];
    Map? accInfoFinder;
    if (tipData.finder != null) {
      finder.address = tipData.finder!;
      accInfoFinder = widget.store.account!.addressIndexMap[finder.address];
    }
    bool isFinder = false;
    if (widget.store.account!.currentAddress == finder.address) {
      isFinder = true;
    }
    bool isCouncil = false;
    widget.store.gov!.council.councilMembers!.forEach((e) {
      if (widget.store.account!.currentAddress == e) {
        isCouncil = true;
      }
    });
    bool isTipped = tipData.tips.length > 0;
    int blockTime = 6000;
    if (widget.store.settings!.networkConst['treasury'] != null) {
      blockTime = widget.store.settings?.blockDuration ?? 0;
    }

    final List<BigInt> values =
        tipData.tips.map((e) => BigInt.parse(e.value.toString())).toList();
    values.sort();
    final int midIndex = (values.length / 2).floor();
    BigInt median = BigInt.zero;
    if (values.length > 0) {
      median = values.length % 2 > 0
          ? values[midIndex]
          : (values[midIndex - 1] + values[midIndex]) ~/ BigInt.two;
    }
    return Scaffold(
      appBar: myAppBar(context, dic.treasury_tip),
      body: SafeArea(
        child: Observer(
          builder: (BuildContext context) {
            final bool canClose = tipData.closes != null &&
                tipData.closes! <= widget.store.gov!.bestNumber;
            return ListView(
              children: <Widget>[
                RoundedCard(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: AddressIcon(who.address),
                        title: Fmt.accountDisplayName(who.address, accInfo),
                        subtitle: Text(dic.treasury_who),
                      ),
                      tipData.finder != null
                          ? ListTile(
                              leading: AddressIcon(finder.address),
                              title: Fmt.accountDisplayName(
                                finder.address,
                                accInfoFinder,
                              ),
                              subtitle: Text(dic.treasury_finder),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${Fmt.balance(
                                      tipData.deposit.toString(),
                                      decimals,
                                    )} $symbol',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  Text(dic.treasury_bond),
                                ],
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: <Widget>[
                            Text(dic.treasury_reason),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: TextFormField(
                                  decoration: InputDecoration.collapsed(
                                      hintText: '',
                                      focusColor: Theme.of(context).cardColor),
                                  style: TextStyle(fontSize: Adapt.px(28)),
                                  initialValue: tipData.reason,
                                  readOnly: true,
                                  maxLines: 6,
                                  minLines: 1,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          children: <Widget>[
                            Text('Hash'),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  Fmt.address(tipData.hash, pad: 10),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      tipData.closes != null &&
                              tipData.closes! > widget.store.gov!.bestNumber
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Row(
                                children: <Widget>[
                                  Text(dic.treasury_closeTip),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            Fmt.blockToTime(
                                              tipData.closes! -
                                                  widget.store.gov!.bestNumber,
                                              blockTime,
                                            ),
                                          ),
                                          Text('#${tipData.closes}')
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Divider(height: 24),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: RoundedButton(
                                    backgroundColor: Colors.orange,
                                    text: S.of(context).cancel,
                                    onPressed: isFinder ? _onCancel : null,
                                  ),
                                ),
                                Container(width: 8),
                                Expanded(
                                  child: canClose
                                      ? RoundedButton(
                                          text: dic.treasury_closeTip,
                                          onPressed:
                                              !isCouncil ? _onCloseTip : null,
                                        )
                                      : RoundedButton(
                                          text: dic.treasury_endorse,
                                          onPressed:
                                              isCouncil ? _onEndorse : null,
                                        ),
                                ),
                                canClose ? Container() : Container(width: 8),
                                canClose
                                    ? Container()
                                    : RoundedButton(
                                        icon: Icon(
                                          Icons.airplanemode_active,
                                          color: Theme.of(context).cardColor,
                                        ),
                                        text: '',
                                        onPressed: isCouncil && isTipped
                                            ? () => _onTip(median)
                                            : null,
                                      )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                tipData.tips.length > 0
                    ? Container(
                        color: Theme.of(context).cardColor,
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.only(top: 8, bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: BorderedTitle(
                                  title:
                                      '${tipData.tips.length} ${dic.treasury_tipper} (${Fmt.token(median, decimals)} $symbol)'),
                            ),
                            Column(
                              children: tipData.tips.map((e) {
                                final Map? accInfo = widget
                                    .store.account!.addressIndexMap[e.address];
                                return ListTile(
                                  leading: AddressIcon(e.address),
                                  title: Fmt.accountDisplayName(
                                      e.address, accInfo),
                                  trailing: Text(
                                    '${Fmt.balance(
                                      e.value.toString(),
                                      decimals,
                                    )} $symbol',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      CandidateDetailPage.route,
                                      arguments: widget
                                          .store.gov!.council.councilMembers!
                                          .firstWhere((i) {
                                        return i == e.address;
                                      }),
                                    );
                                  },
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      )
                    : Container()
              ],
            );
          },
        ),
      ),
    );
  }
}
