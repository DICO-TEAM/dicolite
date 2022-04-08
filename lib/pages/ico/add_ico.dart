import 'dart:async';
import 'dart:convert';

import 'package:dicolite/common/reg_input_formatter.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/ico/select_mult_area.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/my_stepper.dart' as myStep;

import 'package:flutter/material.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';

class FMStepperModel {
  String title;
  Widget content;
  int index;
  myStep.StepState state = myStep.StepState.indexed;

  FMStepperModel(this.title, this.content, this.index);
}

class AddIco extends StatefulWidget {
  AddIco(this.store);
  static final String route = '/ico/addico';
  final AppStore store;

  @override
  _AddIco createState() => _AddIco(store);
}

class _AddIco extends State<AddIco> {
  _AddIco(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  CurrencyModel? currency;
  CurrencyModel? exchangeToken;

  final TextEditingController descCtrl = new TextEditingController();
  final TextEditingController currencyIdCtrl = new TextEditingController();

  final TextEditingController officialWebsiteCtrl = new TextEditingController();
  final TextEditingController userIcoMaxTimesCtrl =
      new TextEditingController(text: "1");
  bool isMustKycCtrl = true;
  final TextEditingController totalIssuanceCtrl = new TextEditingController();
  final TextEditingController totalCirculationCtrl =
      new TextEditingController();
  final TextEditingController icoDurationCtrl =
      new TextEditingController(text: "30");
  final TextEditingController totalIcoAmountCtrl = new TextEditingController();
  final TextEditingController userMinAmountCtrl =
      new TextEditingController(text: "100");
  final TextEditingController userMaxAmountCtrl =
      new TextEditingController(text: "10000");
  final TextEditingController exchangeTokenCtrl = new TextEditingController();
  final TextEditingController exchangeTokenTotalAmountCtrl =
      new TextEditingController();
  List<String> excludeArea = [];
  final TextEditingController excludeAreaCtrl = new TextEditingController();
  final TextEditingController lockProportionCtrl =
      new TextEditingController(text: "70");
  final TextEditingController unlockDurationCtrl =
      new TextEditingController(text: "360");
  final TextEditingController perDurationUnlockAmountCtrl =
      new TextEditingController();

  bool _enableBtn = false;
  bool currencyValidating = false;
  bool exchangeTokenValidating = false;
  Timer? _debounceTimerCurrency;
  Timer? _debounceTimerExchangeToken;
  BigInt? _minUsdt;
  BigInt? _maxUsdt;

  List<FMStepperModel> _datas = [];

  @override
  void initState() {
    super.initState();
    _getMinMaxUSDTAmount();

    WidgetsBinding.instance!.addPostFrameCallback((_) {});
  }

  _getMinMaxUSDTAmount() async {
    List? list = await webApi?.dico?.fetchMinMaxUSDTAmount();
    if (mounted && list != null) {
      setState(() {
        _minUsdt = BigInt.parse(list[0].toString());
        _maxUsdt = BigInt.parse(list[1].toString());
      });
    }
  }

  /// get token info by currencyId
  Future _getTokenInfo() async {
    debounce(() async {
      String currencyId = currencyIdCtrl.text.trim();
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

  /// get Exchange token info by currencyId
  _getExchangeTokenInfo() async {
    debounce(() async {
      String exchangeTokenId = exchangeTokenCtrl.text.trim();
      if (RegExp("^[0-9]+\$").hasMatch(exchangeTokenId) &&
          exchangeTokenId.isNotEmpty) {
        var res = await webApi?.dico?.fetchTokenInfo(exchangeTokenId);

        if (mounted) {
          setState(() {
            exchangeTokenValidating = false;
            exchangeToken = res != null && res["metadata"] != null
                ? CurrencyModel.fromJson(res)
                : null;
          });
        }
      }
    }, _debounceTimerExchangeToken, delay: Duration(seconds: 3));
  }

  Widget form1() {
    var dic = S.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(
            Adapt.px(30),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
              labelText: dic.desc,
            ),
            controller: descCtrl,
            maxLength: 200,
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              }
              if (!Fmt.isEnglish(val)) {
                return dic.pleaseInEnglish;
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
              labelText: dic.currencyId,
              helperText: "Symbol: ${currency?.symbol ?? '~'}",
            ),
            controller: currencyIdCtrl,
            keyboardType: TextInputType.number,
            maxLength: 9,
            inputFormatters: [RegExInputFormatter.withRegex('^[0-9]{0,9}\$')],
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
            Adapt.px(30),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
              labelText: dic.officialWebsite + dic.https,
            ),
            controller: officialWebsiteCtrl,
            maxLength: 200,
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              } else if (!RegExp(r"^http").hasMatch(val.toLowerCase())) {
                return dic.formatMistake;
              } else if (RegExp(r".svg$").hasMatch(val.toLowerCase())) {
                return dic.notSupportSVG;
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
              labelText: dic.totalIssuance,
              suffixText: currency?.symbol,
            ),
            controller: totalIssuanceCtrl,
            keyboardType: TextInputType.number,
            maxLength: 20,
            inputFormatters: [UI.decimalInputFormatter(0)],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
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
              labelText: dic.totalCirculation,
              suffixText: currency?.symbol,
            ),
            controller: totalCirculationCtrl,
            keyboardType: TextInputType.number,
            maxLength: 20,
            inputFormatters: [UI.decimalInputFormatter(0)],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              } else if (totalIssuanceCtrl.text.trim().isNotEmpty &&
                  BigInt.parse(totalIssuanceCtrl.text.trim()) <=
                      BigInt.parse(val)) {
                return dic.totalCirculationError;
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget form2() {
    var dic = S.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(
            Adapt.px(30),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
              labelText: dic.userIcoMaxTimes + " (1~255)",
            ),
            controller: userIcoMaxTimesCtrl,
            keyboardType: TextInputType.number,
            maxLength: 3,
            inputFormatters: [RegExInputFormatter.withRegex('^[0-9]{0,3}\$')],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              } else if (!RegExp("^[0-9]+\$").hasMatch(val)) {
                return dic.formatMistake;
              } else if (int.parse(val) > 255 || int.parse(val) < 1) {
                return dic.formatMistake;
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
            value: isMustKycCtrl,
            items: [false, true]
                .map((f) => DropdownMenuItem(
                      child: Text(
                        f.toString(),
                        textAlign: TextAlign.left,
                      ),
                      value: f,
                    ))
                .toList(),
            onChanged: (v) {
              setState(() {
                isMustKycCtrl = v as bool;
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(15, 10, 0, 15),
              filled: true,
              labelText: dic.isMustKyc,
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
                labelText: dic.lockProportion,
                suffixText: "%"),
            controller: lockProportionCtrl,
            keyboardType: TextInputType.number,
            maxLength: 3,
            inputFormatters: [RegExInputFormatter.withRegex('^[0-9]{0,3}\$')],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              } else if (int.parse(val) > 100) {
                return dic.formatMistake;
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
              labelText: dic.unlockDuration,
              suffixText: dic.days,
            ),
            controller: unlockDurationCtrl,
            keyboardType: TextInputType.number,
            maxLength: 5,

            inputFormatters: [
              RegExInputFormatter.withRegex('^[0-9]{0,6}(\\.[0-9]{0,3})?\$')
            ],
            // inputFormatters: [RegExInputFormatter.withRegex('^[0-9]{0,5}\$')],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
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
              labelText: dic.perDurationUnlockAmount,
              suffixText: currency?.symbol,
            ),
            controller: perDurationUnlockAmountCtrl,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLength: 20,
            inputFormatters: [UI.decimalInputFormatter(0)],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              } else if (totalIcoAmountCtrl.text.trim().isNotEmpty &&
                  BigInt.parse(totalIcoAmountCtrl.text.trim()) <=
                      BigInt.parse(val)) {
                return dic.amountTooHigh;
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget form3() {
    var dic = S.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(
            Adapt.px(30),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
              labelText: dic.icoDuration,
              suffixText: dic.days,
            ),
            controller: icoDurationCtrl,
            keyboardType: TextInputType.number,
            maxLength: 5,

            inputFormatters: [
              RegExInputFormatter.withRegex('^[0-9]{0,6}(\\.[0-9]{0,3})?\$')
            ],
            // inputFormatters: [RegExInputFormatter.withRegex('^[0-9]{0,5}\$')],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
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
              labelText: dic.userMinAmount,
              suffixText: "USD",
            ),
            controller: userMinAmountCtrl,
            keyboardType: TextInputType.number,
            maxLength: 20,
            inputFormatters: [UI.decimalInputFormatter(0)],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              } else if (_minUsdt != null &&
                  Fmt.tokenInt(val, Config.USDtokenDecimals) < _minUsdt!) {
                return dic.amount_too_low +
                    "; >" +
                    Fmt.token(_minUsdt, Config.USDtokenDecimals);
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
              labelText: dic.userMaxAmount,
              suffixText: "USD",
            ),
            controller: userMaxAmountCtrl,
            keyboardType: TextInputType.number,
            maxLength: 20,
            inputFormatters: [UI.decimalInputFormatter(0)],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              } else if (userMinAmountCtrl.text.trim().isNotEmpty &&
                  BigInt.parse(userMinAmountCtrl.text.trim()) >
                      BigInt.parse(val)) {
                return dic.userMaxAmountError;
              } else if (_maxUsdt != null &&
                  Fmt.tokenInt(val, Config.USDtokenDecimals) > _maxUsdt!) {
                return dic.amount_too_high +
                    "; <" +
                    Fmt.token(_maxUsdt, Config.USDtokenDecimals);
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
              labelText: dic.totalIcoAmount,
              suffixText: currency?.symbol,
            ),
            controller: totalIcoAmountCtrl,
            keyboardType: TextInputType.number,
            maxLength: 20,
            inputFormatters: [UI.decimalInputFormatter(0)],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              } else if (totalCirculationCtrl.text.trim().isNotEmpty &&
                  BigInt.parse(totalCirculationCtrl.text.trim()) <=
                      BigInt.parse(val)) {
                return dic.amountTooHigh;
              } else if (currency != null &&
                  Fmt.tokenInt(val, currency!.decimals) >
                      currency!.totalIssuance!) {
                return dic.totalIcoAmountError +
                    " " +
                    Fmt.token(currency!.totalIssuance, currency!.decimals);
              } else if (currency != null &&
                  Fmt.tokenInt(val, currency!.decimals) >
                      currency!.tokenBalance.free) {
                return dic.amount_low +
                    "; " +
                    dic.available +
                    " " +
                    Fmt.token(currency!.tokenBalance.free, currency!.decimals) +
                    currency!.symbol;
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
              labelText: dic.exchangeTokenId,
              helperText: "Symbol: ${exchangeToken?.symbol ?? '~'}",
            ),
            controller: exchangeTokenCtrl,
            keyboardType: TextInputType.number,
            maxLength: 9,
            inputFormatters: [RegExInputFormatter.withRegex('^[0-9]{0,9}\$')],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              } else if (!RegExp("^[0-9]+\$").hasMatch(val)) {
                return dic.formatMistake;
              } else if (currencyIdCtrl.text.trim().isNotEmpty &&
                  currencyIdCtrl.text.trim() == val) {
                return dic.exchangeTokenError;
              } else if (exchangeTokenValidating) {
                return dic.validating;
              } else if (exchangeToken == null) {
                return dic.exchangeTokenIdNotFind;
              }
              return null;
            },
            onChanged: (v) async {
              if (v.trim().isNotEmpty) {
                setState(() {
                  exchangeToken = null;
                  exchangeTokenValidating = true;
                });
                if (currencyIdCtrl.text.trim().isNotEmpty &&
                    currencyIdCtrl.text.trim() == v.trim()) {
                  return;
                }
                _getExchangeTokenInfo();
              }
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
                labelText: dic.exchangeTokenTotalAmount,
                suffixText: exchangeToken?.symbol),
            controller: exchangeTokenTotalAmountCtrl,
            keyboardType: TextInputType.number,
            maxLength: 20,
            inputFormatters: [UI.decimalInputFormatter(0)],
            validator: (v) {
              String val = v!.trim();
              if (val.length == 0) {
                return dic.required;
              }

              return null;
            },
          ),
        ),
        isMustKycCtrl
            ? Padding(
                padding: EdgeInsets.all(
                  Adapt.px(30),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true,
                    labelText: dic.excludeArea,
                  ),
                  controller: excludeAreaCtrl,
                  readOnly: true,
                  onTap: () async {
                    List<String>? list = await Navigator.of(context).pushNamed(
                        SelectMultArea.route,
                        arguments: excludeArea) as List<String>?;
                    if (list != null && mounted) {
                      setState(() {
                        excludeAreaCtrl.text = list.join(',');
                        excludeArea = list;
                      });
                    }
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    descCtrl.dispose();
    currencyIdCtrl.dispose();
    officialWebsiteCtrl.dispose();
    userIcoMaxTimesCtrl.dispose();
    totalIssuanceCtrl.dispose();
    totalCirculationCtrl.dispose();
    icoDurationCtrl.dispose();
    totalIcoAmountCtrl.dispose();
    userMinAmountCtrl.dispose();
    userMaxAmountCtrl.dispose();
    excludeAreaCtrl.dispose();
    exchangeTokenCtrl.dispose();
    exchangeTokenTotalAmountCtrl.dispose();
    lockProportionCtrl.dispose();
    unlockDurationCtrl.dispose();
    perDurationUnlockAmountCtrl.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      if (currency?.decimals == null || exchangeToken?.decimals == null) {
        return showErrorMsg(S.of(context).tryItLater);
      }
      int blockTime = widget.store.settings?.blockDuration ?? 0;
      if (!isMustKycCtrl) {
        setState(() {
          excludeArea = [];
          excludeAreaCtrl.text = "";
        });
      }

      TxConfirmParams args = TxConfirmParams(
          title: S.of(context).add_project,
          module: 'ico',
          call: 'initiateIco',
          detail: jsonEncode({
            "info": {
              "desc": descCtrl.text.trim(),
              "currencyId": currencyIdCtrl.text.trim(),
              "officialWebsite": officialWebsiteCtrl.text.trim(),
              "userIcoMaxTimes": userIcoMaxTimesCtrl.text.trim(),
              "isMustKyc": isMustKycCtrl,
              "totalIssuance": totalIssuanceCtrl.text.trim(),
              "totalCirculation": totalCirculationCtrl.text.trim(),
              "icoDuration": Fmt.daysToblock(
                  double.parse(icoDurationCtrl.text.trim()), blockTime),
              "totalIcoAmount": totalIcoAmountCtrl.text.trim(),
              "userMinAmount": userMinAmountCtrl.text.trim(),
              "userMaxAmount": userMaxAmountCtrl.text.trim(),
              "exchangeToken": exchangeTokenCtrl.text.trim(),
              "exchangeTokenTotalAmount":
                  exchangeTokenTotalAmountCtrl.text.trim(),
              "excludeArea": excludeArea,
              "lockProportion": lockProportionCtrl.text.trim(),
              "unlockDuration": Fmt.daysToblock(
                  double.parse(unlockDurationCtrl.text.trim()), blockTime),
              "perDurationUnlockAmount":
                  perDurationUnlockAmountCtrl.text.trim(),
            }
          }),
          params: [
            {
              "desc": descCtrl.text.trim(),
              "currencyId": currencyIdCtrl.text.trim(),
              "officialWebsite": officialWebsiteCtrl.text.trim(),
              "userIcoMaxTimes": userIcoMaxTimesCtrl.text.trim(),
              "isMustKyc": isMustKycCtrl,
              "totalIssuance": Fmt.tokenInt(
                      totalIssuanceCtrl.text.trim(), currency!.decimals)
                  .toString(),
              "totalCirculation": Fmt.tokenInt(
                      totalCirculationCtrl.text.trim(), currency!.decimals)
                  .toString(),
              "icoDuration": Fmt.daysToblock(
                  double.parse(icoDurationCtrl.text.trim()), blockTime),
              "totalIcoAmount": Fmt.tokenInt(
                      totalIcoAmountCtrl.text.trim(), currency!.decimals)
                  .toString(),
              "userMinAmount": Fmt.tokenInt(
                      userMinAmountCtrl.text.trim(), Config.USDtokenDecimals)
                  .toString(),
              "userMaxAmount": Fmt.tokenInt(
                      userMaxAmountCtrl.text.trim(), Config.USDtokenDecimals)
                  .toString(),
              "exchangeToken": exchangeTokenCtrl.text.trim(),
              "exchangeTokenTotalAmount": Fmt.tokenInt(
                      exchangeTokenTotalAmountCtrl.text.trim(),
                      exchangeToken!.decimals)
                  .toString(),
              "excludeArea": excludeArea,
              "lockProportion": lockProportionCtrl.text.trim(),
              "unlockDuration": Fmt.daysToblock(
                  double.parse(unlockDurationCtrl.text.trim()), blockTime),
              "perDurationUnlockAmount": Fmt.tokenInt(
                      perDurationUnlockAmountCtrl.text.trim(),
                      currency!.decimals)
                  .toString(),
            }
          ],
          onSuccess: (res) {
            webApi?.dico?.fetchAddedIcoList();
          });

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  int _currentStep = 0;

  /// create steps data
  List<myStep.Step> _steps(dic) {
    List<myStep.Step> steps = [];

    _datas = [
      FMStepperModel(dic.projecInfo, form1(), 0),
      FMStepperModel(dic.raiseInfo, form2(), 1),
      FMStepperModel(dic.ICOInfo, form3(), 2),
    ];
    _datas.forEach((model) {
      if (_currentStep < model.index) {
        model.state = myStep.StepState.indexed;
      } else if (_currentStep == model.index) {
        model.state = myStep.StepState.editing;
      } else if (_currentStep > model.index) {
        model.state = myStep.StepState.complete;
      }

      steps.add(
        myStep.Step(
          title: Text(model.title),
          content: model.content,
          isActive: (_currentStep == _datas.indexOf(model)),
          state: model.state,
        ),
      );
    });
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);

    return Scaffold(
      appBar: myAppBar(context, dic.add_project),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () =>
            setState(() => _enableBtn = _formKey.currentState!.validate()),
        child: Container(
          child: myStep.Stepper(
            currentStep: _currentStep,
            type: myStep.StepperType.horizontal,
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _currentStep == 2 && !_enableBtn
                            ? null
                            : details.onStepContinue,
                        child: Text(_currentStep == 2 ? dic.submit : dic.next),
                      ),
                    ),
                  ],
                ),
              );
            },
            onStepTapped: (index) {
              print(index);
              setState(() {
                _currentStep = index;
              });
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              }
            },
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() {
                  _currentStep++;
                });
              } else {
                _submit();
              }
            },
            steps: _steps(dic),
          ),
        ),
      ),
    );
  }
}
