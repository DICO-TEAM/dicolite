import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dicolite/common/reg_input_formatter.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/loading_widget.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class AddLbp extends StatefulWidget {
  AddLbp(this.store);
  static final String route = '/lbp/addLbp';
  final AppStore store;

  @override
  _AddLbp createState() => _AddLbp(store);
}

class _AddLbp extends State<AddLbp> {
  _AddLbp(this.store);

  final AppStore store;

  List<CurrencyModel>? supportFundraisingAssetsList;
  CurrencyModel? afsCurrency;
  bool afsCurrencyValidating = false;
  bool exchangeTokenValidating = false;
  Timer? _debounceTimerCurrency;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _afsAssetCtrl = new TextEditingController();
  CurrencyModel? _fundraisingAssetCtrl;
  final TextEditingController _afsBalanceCtrl = new TextEditingController();
  final TextEditingController _fundraisingBalanceCtrl =
      new TextEditingController();
  final TextEditingController _afsStartWeightCtrl =
      new TextEditingController(text: "90");
  final TextEditingController _afsEndWeightCtrl =
      new TextEditingController(text: "10");
  final TextEditingController _fundraisingStartWeightCtrl =
      new TextEditingController(text: "10");
  final TextEditingController _fundraisingEndWeightCtrl =
      new TextEditingController(text: "90");
  final TextEditingController _startBlockCtrl =
      new TextEditingController(text: "1");
  final TextEditingController _durationCtrl =
      new TextEditingController(text: "3");
  final TextEditingController _stepsCtrl =
      new TextEditingController(text: "864");

  bool _enableBtn = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    List<CurrencyModel>? res =
        await webApi?.dico?.fetchLbpSupportFundraisingAssetsList();
    if (res != null && mounted) {
      setState(() {
        supportFundraisingAssetsList = res;
        _fundraisingAssetCtrl = res.isNotEmpty ? res[0] : null;
      });
    }
  }

  /// get token info by currencyId
  Future _getTokenInfo() async {
    debounce(() async {
      String currencyId = _afsAssetCtrl.text.trim();
      if (currencyId == Config.tokenId) {
        setState(() {
          afsCurrencyValidating = false;
          afsCurrency = store.dico!.tokensSort[0];
        });
        return;
      }
      if (RegExp("^[0-9]+\$").hasMatch(currencyId) && currencyId.isNotEmpty) {
        var res = await webApi?.dico?.fetchTokenInfo(currencyId);

        if (mounted) {
          setState(() {
            afsCurrencyValidating = false;
            afsCurrency = res != null && res["metadata"] != null
                ? CurrencyModel.fromJson(res)
                : null;
          });
        }
      }
    }, _debounceTimerCurrency, delay: Duration(seconds: 3));
  }

  @override
  void dispose() {
    super.dispose();
    _afsAssetCtrl.dispose();
    _afsBalanceCtrl.dispose();
    _fundraisingBalanceCtrl.dispose();
    _afsStartWeightCtrl.dispose();
    _afsEndWeightCtrl.dispose();
    _fundraisingStartWeightCtrl.dispose();
    _fundraisingEndWeightCtrl.dispose();
    _startBlockCtrl.dispose();
    _durationCtrl.dispose();
    _stepsCtrl.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      int blockTime = widget.store.settings?.blockDuration ?? 0;
      int now = widget.store.dico?.newHeads?.number ?? 0;
      int startBlock = now +
          Fmt.daysToblock(double.parse(_startBlockCtrl.text.trim()), blockTime);
      int endBlock = startBlock +
          Fmt.daysToblock(double.parse(_durationCtrl.text.trim()), blockTime);
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).createLbp,
        module: 'lbp',
        call: 'createLbp',
        detail: jsonEncode({
          "afsAsset": _afsAssetCtrl.text.trim(),
          "fundraisingAsset": _fundraisingAssetCtrl!.currencyId,
          "afsBalance": _afsBalanceCtrl.text.trim(),
          "fundraisingBalance": _fundraisingBalanceCtrl.text.trim(),
          "afsStartWeight": _afsStartWeightCtrl.text.trim(),
          "afsEndWeight": _afsEndWeightCtrl.text.trim(),
          "fundraisingStartWeight": _fundraisingStartWeightCtrl.text.trim(),
          "fundraisingEndWeight": _fundraisingEndWeightCtrl.text.trim(),
          "startBlock": startBlock,
          "endBlock": endBlock,
          "steps": _stepsCtrl.text.trim(),
        }),
        params: [
          _afsAssetCtrl.text.trim(),
          _fundraisingAssetCtrl!.currencyId,
          Fmt.tokenInt(_afsBalanceCtrl.text.trim(), afsCurrency!.decimals)
              .toString(),
          Fmt.tokenInt(_fundraisingBalanceCtrl.text.trim(),
                  _fundraisingAssetCtrl!.decimals)
              .toString(),
          Fmt.tokenInt(
                  _afsStartWeightCtrl.text.trim(), Config.lbpWeightDecimals)
              .toString(),
          Fmt.tokenInt(_afsEndWeightCtrl.text.trim(), Config.lbpWeightDecimals)
              .toString(),
          Fmt.tokenInt(_fundraisingStartWeightCtrl.text.trim(),
                  Config.lbpWeightDecimals)
              .toString(),
          Fmt.tokenInt(_fundraisingEndWeightCtrl.text.trim(),
                  Config.lbpWeightDecimals)
              .toString(),
          startBlock,
          endBlock,
          _stepsCtrl.text.trim(),
        ],
        onSuccess: (Map res) {
          globalLbpRefreshKey.currentState?.show();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  Widget mainWidget() {
    var dic = S.of(context);
    if (supportFundraisingAssetsList == null) {
      return LoadingWidget();
    } else if (supportFundraisingAssetsList!.isEmpty) {
      return Center(
        child: Text(
          dic.waitingForAddFundraisingAssets,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    }
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
                  padding: EdgeInsets.all(
                    Adapt.px(30),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.afsAssetId,
                      helperText: "Symbol: ${afsCurrency?.symbol ?? '~'}",
                    ),
                    controller: _afsAssetCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                    inputFormatters: [
                      RegExInputFormatter.withRegex('^[0-9]{0,9}\$')
                    ],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (!RegExp("^[0-9]+\$").hasMatch(val)) {
                        return dic.formatMistake;
                      } else if (supportFundraisingAssetsList!
                          .map((e) => e.currencyId)
                          .contains(val)) {
                        return dic.cannotUseFundraisingAssets;
                      } else if (afsCurrencyValidating) {
                        return dic.validating;
                      } else if (afsCurrency == null) {
                        return dic.currencyIdNotFind;
                      }
                      return null;
                    },
                    onChanged: (v) async {
                      if (v.trim().isNotEmpty) {
                        setState(() {
                          afsCurrency = null;
                          afsCurrencyValidating = true;
                        });
                      }
                      _getTokenInfo();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    Adapt.px(30),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: afsCurrency != null
                          ? "${dic.afsBalance} (${dic.available} ${Fmt.token(afsCurrency!.tokenBalance.free, afsCurrency!.decimals)})"
                          : dic.afsBalance,
                      suffixText: afsCurrency?.symbol,
                    ),
                    controller: _afsBalanceCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 20,
                    inputFormatters: [
                      UI.decimalInputFormatter(afsCurrency?.decimals ?? 5)
                    ],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (afsCurrency != null &&
                          Fmt.tokenInt(val, afsCurrency!.decimals) >
                              afsCurrency!.tokenBalance.free) {
                        return dic.amount_low;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    Adapt.px(30),
                  ),
                  child: DropdownButtonFormField(
                    value: _fundraisingAssetCtrl,
                    items: supportFundraisingAssetsList!
                        .map((f) => DropdownMenuItem(
                              child: Container(
                                width: Adapt.px(560),
                                child: Text(
                                  f.symbol,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              value: f,
                            ))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _fundraisingAssetCtrl = v as CurrencyModel;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.fromLTRB(15, 10, 0, 15),
                      filled: true,
                      labelText: dic.fundraisingAsset,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    Adapt.px(30),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText:
                          "${dic.fundraisingBalance} (${dic.available} ${Fmt.token(_fundraisingAssetCtrl!.tokenBalance.free, _fundraisingAssetCtrl!.decimals)})",
                      suffixText: _fundraisingAssetCtrl?.symbol,
                    ),
                    controller: _fundraisingBalanceCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 20,
                    inputFormatters: [
                      UI.decimalInputFormatter(_fundraisingAssetCtrl!.decimals)
                    ],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (_fundraisingAssetCtrl != null &&
                          Fmt.tokenInt(val, _fundraisingAssetCtrl!.decimals) >
                              _fundraisingAssetCtrl!.tokenBalance.free) {
                        return dic.amount_low;
                      } else if (_fundraisingAssetCtrl != null &&
                          Fmt.tokenInt(val, _fundraisingAssetCtrl!.decimals) <
                              _fundraisingAssetCtrl!.minFundraisingAmount!) {
                        return dic.min +
                            ": " +
                            Fmt.token(
                                _fundraisingAssetCtrl!.minFundraisingAmount!,
                                _fundraisingAssetCtrl!.decimals);
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    Adapt.px(30),
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
                  padding: EdgeInsets.all(
                    Adapt.px(30),
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
                      } else if (Decimal.parse(val) < Decimal.parse("0.021")) {
                        return dic.min + ": 0.021 " + dic.days;
                      } else if (Decimal.parse(val) > Decimal.parse("3")) {
                        return dic.max + ": 3 " + dic.days;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    Adapt.px(30),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.steps + "(6~864)",
                    ),
                    controller: _stepsCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [UI.decimalInputFormatter(0)],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (int.parse(val) < int.parse("6")) {
                        return dic.min + ": 6";
                      } else if (int.parse(val) > int.parse("864")) {
                        return dic.max + ": 864";
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    Adapt.px(30),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.afsStartWeight,
                    ),
                    controller: _afsStartWeightCtrl,
                    inputFormatters: [UI.decimalInputFormatter(0)],
                    textInputAction: TextInputAction.next,
                    maxLength: 20,
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (int.parse(val) > 100) {
                        return dic.max + ": 100";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    Adapt.px(30),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.afsEndWeight,
                    ),
                    controller: _afsEndWeightCtrl,
                    inputFormatters: [UI.decimalInputFormatter(0)],
                    textInputAction: TextInputAction.next,
                    maxLength: 20,
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (int.parse(val) > 100) {
                        return dic.max + ": 100";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    Adapt.px(30),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.fundraisingStartWeight,
                    ),
                    controller: _fundraisingStartWeightCtrl,
                    inputFormatters: [UI.decimalInputFormatter(0)],
                    textInputAction: TextInputAction.next,
                    maxLength: 20,
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (int.parse(val) > 100) {
                        return dic.max + ": 100";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    Adapt.px(30),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: dic.fundraisingEndWeight,
                    ),
                    controller: _fundraisingEndWeightCtrl,
                    inputFormatters: [UI.decimalInputFormatter(0)],
                    textInputAction: TextInputAction.next,
                    maxLength: 20,
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0) {
                        return dic.required;
                      } else if (int.parse(val) > 100) {
                        return dic.max + ": 100";
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
      appBar: myAppBar(context, dic.createLbp),
      body: mainWidget(),
    );
  }
}
