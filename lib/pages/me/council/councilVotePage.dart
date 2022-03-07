import 'dart:convert';
import 'dart:math';

import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/council/candidateListPage.dart';
import 'package:dicolite/pages/me/council/councilPage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class CouncilVotePage extends StatefulWidget {
  CouncilVotePage(this.store);
  static final String route = '/gov/vote';
  final AppStore store;
  @override
  _CouncilVote createState() => _CouncilVote(store);
}

class _CouncilVote extends State<CouncilVotePage> {
  _CouncilVote(this.store);
  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountCtrl = new TextEditingController();

  List<List> _selected = <List>[];

  Future<void> _handleCandidateSelect() async {
    var res = await Navigator.of(context)
        .pushNamed(CandidateListPage.route, arguments: _selected);
    if (res != null) {
      setState(() {
        _selected = List<List>.of(res as List<List>);
      });
    }
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      var dic = S.of(context);
      int decimals = store.settings!.networkState.tokenDecimals;
      String amt = _amountCtrl.text.trim();
      List selected = _selected.map((i) => i[0]).toList();
      TxConfirmParams args = TxConfirmParams(
        title: dic.vote_candidate,
        module: 'elections',
        call: 'vote',
        detail: jsonEncode({
          "votes": selected,
          "voteValue": amt,
        }),
        params: [
          // "votes"
          selected,
          // "voteValue"
          Fmt.tokenInt(amt, decimals).toString(),
        ],
        onSuccess: (res) {
          globalCouncilRefreshKey.currentState?.show();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(CouncilPage.route));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Scaffold(
      appBar: myAppBar(context, dic.vote_candidate),
      body: Observer(
        builder: (_) {
          final S dic = S.of(context);
          int decimals = store.settings!.networkState.tokenDecimals;
          String symbol = store.settings!.networkState.tokenSymbol;

          BigInt? balance = store.assets!.balances[symbol]!.freeBalance;

          return SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 16, left: 16, right: 16, bottom: 16),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: dic.amount,
                              labelText:
                                  '${dic.amount} (${dic.balance}: ${Fmt.token(balance, decimals)})',
                            ),
                            inputFormatters: [
                              UI.decimalInputFormatter(decimals)
                            ],
                            controller: _amountCtrl,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return dic.amount_error;
                              }
                              if (double.parse(v.trim()) >=
                                  balance! / BigInt.from(pow(10, decimals)) -
                                      0.001) {
                                return dic.amount_low;
                              }
                              return null;
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(dic.candidate),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {
                            _handleCandidateSelect();
                          },
                        ),
                        Column(
                          children: _selected.map((i) {
                            var accInfo = store.account!.addressIndexMap[i[0]];
                            return Container(
                              margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 32,
                                    margin: EdgeInsets.only(right: 8),
                                    child: AddressIcon(
                                      i[0],
                                      size: 32,
                                      tapToCopy: false,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Fmt.accountDisplayName(i[0], accInfo),
                                        Text(
                                          Fmt.address(i[0]),
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: RoundedButton(
                    text: S.of(context).submit_tx,
                    onPressed: _selected.length == 0 ? null : _onSubmit,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
