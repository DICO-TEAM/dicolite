import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dicolite/common/reg_input_formatter.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/my_utils.dart';

import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class AddPool extends StatefulWidget {
  AddPool(this.store);
  static final String route = '/lbp/addPool';
  final AppStore store;

  @override
  _AddPool createState() => _AddPool(store);
}

class _AddPool extends State<AddPool> {
  _AddPool(this.store);

  final AppStore store;

  CurrencyModel? currency;
  CurrencyModel? stakeCurrency;
  bool currencyValidating = false;
  bool stakeCurrencyValidating = false;
  Timer? _debounceTimerCurrency;
  Timer? _debounceTimerStakeCurrency;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currencyIdCtrl = new TextEditingController();
  final TextEditingController _stakeCurrencyIdCtrl =
      new TextEditingController();

  final TextEditingController _amountCtrl = new TextEditingController();

  final TextEditingController _startBlockCtrl =
      new TextEditingController(text: "1");
  final TextEditingController _durationCtrl =
      new TextEditingController(text: "30");

  bool _enableBtn = false;

  @override
  void initState() {
    super.initState();
  }

  /// get token info by currencyId
  Future _getTokenInfo() async {
    debounce(() async {
      String currencyId = _currencyIdCtrl.text.trim();
      if (RegExp("^[0-9]+\$").hasMatch(currencyId) && currencyId.isNotEmpty) {
        var res = await webApi?.dico?.fetchTokenInfo(currencyId);

        if (mounted) {
          setState(() {
            currencyValidating = false;
            currency = res != null && res["metadata"] != null
                ? CurrencyModel.fromJson(res)
                : null;
          });
        }
      }
    }, _debounceTimerCurrency, delay: Duration(seconds: 3));
  }

  /// get token info by stake currencyId
  Future _getStakeTokenInfo() async {
    debounce(() async {
      String stakeCurrencyId = _stakeCurrencyIdCtrl.text.trim();
      if (RegExp("^[0-9]+\$").hasMatch(stakeCurrencyId) &&
          stakeCurrencyId.isNotEmpty) {
        var res = await webApi?.dico?.fetchTokenInfo(stakeCurrencyId);

        if (mounted) {
          setState(() {
            stakeCurrencyValidating = false;
            stakeCurrency = res != null && res["metadata"] != null
                ? CurrencyModel.fromJson(res)
                : null;
          });
        }
      }
    }, _debounceTimerStakeCurrency, delay: Duration(seconds: 3));
  }

  @override
  void dispose() {
    super.dispose();
    _currencyIdCtrl.dispose();
    _stakeCurrencyIdCtrl.dispose();
    _amountCtrl.dispose();
    _startBlockCtrl.dispose();
    _durationCtrl.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      int blockTime = widget.store.settings?.blockDuration ?? 0;
      int now = widget.store.dico?.newHeads?.number ?? 0;
      int startBlock = now +
          Fmt.daysToblock(double.parse(_startBlockCtrl.text.trim()), blockTime);
      int endBlock = startBlock +
          Fmt.daysToblock(double.parse(_durationCtrl.text.trim()), blockTime);

      Decimal rewardPerBlock = Decimal.parse(_amountCtrl.text.trim()) /
          Decimal.fromInt(endBlock - startBlock);

      TxConfirmParams args = TxConfirmParams(
          title: S.of(context).createLbp,
          module: 'farmExtend',
          call: 'createPool',
          detail: jsonEncode({
            "currencyId": _currencyIdCtrl.text.trim(),
            "startBlock": startBlock,
            "endBlock": endBlock,
            "rewardPerBlock": rewardPerBlock.toString(),
            "stakeCurrencyId": _stakeCurrencyIdCtrl.text.trim(),
          }),
          params: [
            _currencyIdCtrl.text.trim(),
            startBlock,
            endBlock,
            Fmt.tokenInt(rewardPerBlock.toString(), currency!.decimals)
                .toString(),
            _stakeCurrencyIdCtrl.text.trim(),
          ],
          onSuccess: (res) {
            globalPoolsRefreshKey.currentState?.show();
          });

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  Widget mainWidget() {
    var dic = S.of(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () =>
                setState(() => _enableBtn = _formKey.currentState!.validate()),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info,
                        color: Theme.of(context).unselectedWidgetColor,
                        size: 24,
                      ),
                      SizedBox(width: 4),
                      Expanded(child: Text(dic.addPoolTips)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    15,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.rewardCurrencyId,
                      helperText: "Symbol: ${currency?.symbol ?? '~'}",
                    ),
                    controller: _currencyIdCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 20,
                    inputFormatters: [
                      RegExInputFormatter.withRegex('^[0-9]{0,20}\$')
                    ],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (!RegExp("^[0-9]+\$").hasMatch(val)) {
                        return dic.formatMistake;
                      } else if (currencyValidating) {
                        return dic.validating;
                      } else if (currency == null) {
                        return dic.currencyIdNotFind;
                      }
                      return null;
                    },
                    onChanged: (v) async {
                      if (v.trim().isNotEmpty) {
                        setState(() {
                          currency = null;
                          currencyValidating = true;
                        });
                      }
                      _getTokenInfo();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    15,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.stakeCurrencyId,
                      helperText: "Symbol: ${stakeCurrency?.symbol ?? '~'}",
                    ),
                    controller: _stakeCurrencyIdCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 20,
                    inputFormatters: [
                      RegExInputFormatter.withRegex('^[0-9]{0,20}\$')
                    ],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (!RegExp("^[0-9]+\$").hasMatch(val)) {
                        return dic.formatMistake;
                      } else if (stakeCurrencyValidating) {
                        return dic.validating;
                      } else if (stakeCurrency == null) {
                        return dic.currencyIdNotFind;
                      }
                      return null;
                    },
                    onChanged: (v) async {
                      if (v.trim().isNotEmpty) {
                        setState(() {
                          stakeCurrency = null;
                          stakeCurrencyValidating = true;
                        });
                      }
                      _getStakeTokenInfo();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    15,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: currency != null
                          ? "${dic.rewardAmount} (${dic.available} ${Fmt.token(currency!.tokenBalance.free, currency!.decimals)})"
                          : dic.rewardAmount,
                      suffixText: currency?.symbol,
                    ),
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 20,
                    inputFormatters: [
                      UI.decimalInputFormatter(currency?.decimals ?? 5)
                    ],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (currency != null &&
                          Fmt.tokenInt(val, currency!.decimals) >
                              currency!.tokenBalance.free) {
                        return dic.amount_low;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    15,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.startTime,
                      suffixText: dic.daysLater,
                    ),
                    controller: _startBlockCtrl,
                    keyboardType: TextInputType.number,

                   
                    inputFormatters: [
                      RegExInputFormatter.withRegex(
                          '^[0-9]{0,6}(\\.[0-9]{0,3})?\$')
                    ],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (Decimal.parse(val) < Decimal.parse("0.003")) {
                        return dic.min + ": 0.003 " + dic.daysLater;
                      } else if (Decimal.parse(val) > Decimal.parse("3")) {
                        return dic.max + ": 3 " + dic.daysLater;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(dic.poolShowTimeTips),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    15,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.duration,
                      suffixText: dic.days,
                    ),
                    controller: _durationCtrl,
                    keyboardType: TextInputType.number,

                   
                    inputFormatters: [
                      RegExInputFormatter.withRegex(
                          '^[0-9]{0,6}(\\.[0-9]{0,3})?\$')
                    ],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (Decimal.parse(val) < Decimal.parse("5")) {
                        return dic.min + ": 5 " + dic.days;
                      } else if (Decimal.parse(val) > Decimal.parse("3600")) {
                        return dic.max + ": 3600 " + dic.days;
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(16),
          child: RoundedButton(
            text: dic.submit,
            onPressed: _enableBtn ? _submit : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);

    return Scaffold(
      appBar: myAppBar(context, dic.addPool),
      body: mainWidget(),
    );
  }
}
