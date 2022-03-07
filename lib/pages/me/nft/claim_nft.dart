import 'dart:convert';

import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:flutter/material.dart';

import 'nft.dart';

class ClaimNft extends StatefulWidget {
  const ClaimNft(this.store, {Key? key}) : super(key: key);

  final AppStore store;
  static final String route = '/me/ClaimNft';

  @override
  _ClaimNftState createState() => _ClaimNftState(store);
}

class _ClaimNftState extends State<ClaimNft> {
  _ClaimNftState(this.store);
  final AppStore store;
  BigInt? _myTotalValueOfIco;
  List _canClaimNftList = [];

  List? _selectClass;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    List? res = await webApi?.dico?.fetchCanClaimNftListAndMyIcoTotalUsd();
    if (!mounted || res == null) return;
    List list = (res[0] as List);
    list.sort((a, b) => a[0].compareTo(b[0]));
    BigInt myTotalValueOfIco =
        res[1] == null ? BigInt.zero : BigInt.parse(res[1].toString());
    list = list.where(((e) {
      String classId = e[0].toString();
      int index = Config.nftList.indexWhere((x) => x[3] == classId);

      if (index != -1) {
        if (Fmt.tokenInt(
                Config.nftList[index][1].toString(), Config.kUSDDecimals) <
            myTotalValueOfIco) {
          return true;
        }
      }
      return false;
    })).toList();
    setState(() {
      _myTotalValueOfIco = myTotalValueOfIco;
      _canClaimNftList = list;
      _selectClass = list.isNotEmpty ? list[0] : null;
    });
  }

  Future<void> _submit() async {
    if (_selectClass == null) return;
    TxConfirmParams args = TxConfirmParams(
      title: S.of(context).mint_nft,
      module: 'nft',
      call: 'claim',
      detail: jsonEncode({
        "token": [
          _selectClass![0],
          _selectClass![1],
        ]
      }),
      params: [
        [
          _selectClass![0],
          _selectClass![1],
        ]
      ],
      onSuccess: (res) {
        webApi?.dico?.fetchMyNftTokenList();
      },
    );

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(Nft.route));
    }
  }

  Widget ruleWiget(S dic) {
    List<TableRow> list = Config.nftList
        .map(
          (item) => TableRow(
            children: [
              Text(
                item[0],
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Center(
                child: Text(
                  Fmt.doubleFormat(double.parse(item[1].toString())),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Color(0xFFFF3D00)),
                ),
              ),
              Center(
                child: Text(
                  Fmt.doubleFormat(double.parse(item[2].toString())),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Color(0xFFFF3D00)),
                ),
              ),
            ],
          ),
        )
        .toList();
    String symbol = store.settings!.networkState.tokenSymbol;

    return Column(
      children: [
        RoundedCard(
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          padding: const EdgeInsets.all(15),
          child: Table(
            children: [
              TableRow(children: [
                Text(dic.name),
                Center(child: Text(dic.condition)),
                Center(child: Text(dic.fee + " ($symbol)")),
              ])
            ],
          ),
        ),
        RoundedCard(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          child: Table(
            children: list,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);

    return Scaffold(
      appBar: myAppBar(context, dic.mint_nft, isThemeBg: true),
      body: ListView(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Divider(
                  color: Colors.white30,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  Fmt.token(_myTotalValueOfIco, Config.kUSDDecimals),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(dic.totalRemainValueOfMyIco + " (USD)",
                    style: TextStyle(color: Colors.white60)),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 100,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 50,
                        child: Container(
                          height: 80,
                          width: Adapt.px(750),
                          decoration: BoxDecoration(
                            color: Config.bgColor,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(25)),
                          ),
                        ),
                      ),
                      Positioned(child: claimCard(dic)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ruleWiget(dic),
        ],
      ),
    );
  }

  Widget claimCard(S dic) {
    return RoundedCard(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: _myTotalValueOfIco == null
          ? Container()
          : Row(
              children: [
                _selectClass == null
                    ? Expanded(
                        child: Text(
                          dic.noQuota,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Color(0xFFFF3D00),
                                    fontSize: Adapt.px(25),
                                  ),
                        ),
                      )
                    : Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField(
                                value: _selectClass,
                                items: _canClaimNftList
                                    .map((f) => DropdownMenuItem(
                                          child: Container(
                                            width: Adapt.px(340),
                                            child: Text(
                                              Config.nftList.firstWhere((e) =>
                                                  e[3] == f[0].toString())[0],
                                              style: TextStyle(
                                                  fontSize: Adapt.px(28)),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          value: f,
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _selectClass = v as List;
                                  });
                                },
                                decoration: InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  fillColor: Config.bgColor,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 10, 5, 15),
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all((RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))))),
                  child: Text(dic.mint_nft),
                  onPressed: _selectClass == null ? null : _submit,
                )
              ],
            ),
    );
  }
}
