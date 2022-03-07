import 'dart:convert';
import 'dart:math';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/democracy/democracyPage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/gov/types/referendumInfoData.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class ReferendumVotePage extends StatefulWidget {
  ReferendumVotePage(this.store);
  static final String route = '/gov/referenda';
  final AppStore store;
  @override
  _ReferendumVoteState createState() => _ReferendumVoteState(store);
}

class _ReferendumVoteState extends State<ReferendumVotePage> {
  _ReferendumVoteState(this.store);
  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountCtrl = new TextEditingController();

  final List<int> _voteConvictionOptions = [0, 1, 2, 3, 4, 5, 6];

  int _voteConviction = 0;

  void _onSubmit(BigInt id, bool voteYes) async {
    if (_formKey.currentState!.validate()) {
      var dic = S.of(context);
      int decimals = store.settings!.networkState.tokenDecimals;
      String amt = _amountCtrl.text.trim();
      Map vote = {
        'balance': (double.parse(amt) * pow(10, decimals)).toInt(),
        'vote': {'aye': voteYes, 'conviction': _voteConviction},
      };
      TxConfirmParams args = TxConfirmParams(
        title: dic.vote_proposal,
        module: 'democracy',
        call: 'vote',
        detail: jsonEncode({
          "id": id.toInt(),
          "balance": amt,
          "vote": vote['vote'],
        }),
        params: [
          // "id"
          id.toInt(),
          // "options"
          {"Standard": vote},
        ],
        onSuccess: (res) {
          globalDemocracyRefreshKey.currentState?.show();
        },
      );
      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(DemocracyPage.route));
       
      }
    }
  }

  String _getConvictionLabel(int value) {
    var dic = S.of(context);
    final Map conviction =
        value > 0 ? store.gov!.voteConvictions![value - 1] : {};
    return value == 0
        ? dic.locked_no
        : '${dic.lockedFor} ${conviction['period']} ${dic.day} (${conviction['lock']}x)';
  }

  void _showConvictionSelect() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          itemExtent: 58,
          scrollController:
              FixedExtentScrollController(initialItem: _voteConviction),
          children: _voteConvictionOptions.map((i) {
            return Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  _getConvictionLabel(i),
                  style: TextStyle(fontSize: Adapt.px(32)),
                ));
          }).toList(),
          onSelectedItemChanged: (v) {
            setState(() {
              _voteConviction = v;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Scaffold(
      appBar: myAppBar(context, dic.vote_proposal),
      body: Observer(
        builder: (_) {
          final S dic = S.of(context);
          int decimals = store.settings!.networkState.tokenDecimals;
          String symbol = store.settings!.networkState.tokenSymbol;

          BigInt balance =
              store.assets!.balances[symbol]!.freeBalance ?? BigInt.zero;

          Map args = ModalRoute.of(context)!.settings.arguments as Map;
          ReferendumInfo info = args['referenda'];
          bool voteYes = args['voteYes'];
          return SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            voteYes ? dic.yes_text : dic.no_text,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                                  balance / BigInt.from(pow(10, decimals))) {
                                return dic.amount_low;
                              }
                              return null;
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(dic.lockedFor),
                          subtitle: Text(_getConvictionLabel(_voteConviction)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: _showConvictionSelect,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: RoundedButton(
                    text: S.of(context).submit_tx,
                    onPressed: () => _onSubmit(info.index, voteYes),
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
