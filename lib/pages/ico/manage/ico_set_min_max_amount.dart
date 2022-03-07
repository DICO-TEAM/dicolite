import 'dart:async';
import 'dart:convert';

import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/ico_add_list_model.dart';
import 'package:dicolite/pages/ico/manage/ico_manage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class IcoSetMinMaxAmount extends StatefulWidget {
  IcoSetMinMaxAmount(this.store);
  static final String route = '/ico/IcoSetMinMaxAmount';
  final AppStore store;

  @override
  _IcoSetMinMaxAmount createState() => _IcoSetMinMaxAmount(store);
}

class _IcoSetMinMaxAmount extends State<IcoSetMinMaxAmount> {
  _IcoSetMinMaxAmount(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController userMinAmountCtrl = new TextEditingController();
  final TextEditingController userMaxAmountCtrl = new TextEditingController();

  bool _enableBtn = false;
  BigInt? _minUsdt;
  BigInt? _maxUsdt;

  @override
  void initState() {
    super.initState();
    _getMinMaxUSDTAmount();
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

  @override
  void dispose() {
    super.dispose();
    userMinAmountCtrl.dispose();
    userMaxAmountCtrl.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      var data = ModalRoute.of(context)!.settings.arguments as IcoAddListModel;

      TxConfirmParams args = TxConfirmParams(
          title: S.of(context).add_project,
          module: 'ico',
          call: 'initiatorSetIcoAmountBound',
          detail: jsonEncode({
            "currencyId": data.currencyId,
            "index": data.index,
            "minAmount": userMinAmountCtrl.text.trim(),
            "maxAmount": userMaxAmountCtrl.text.trim(),
          }),
          params: [
            data.currencyId,
            data.index,
            Fmt.tokenInt(userMinAmountCtrl.text.trim(), Config.kUSDDecimals)
                .toString(),
            Fmt.tokenInt(userMaxAmountCtrl.text.trim(), Config.kUSDDecimals)
                .toString(),
          ],
          onSuccess: (res) {
            webApi?.dico?.fetchAddedIcoList();
          });

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(IcoManage.route));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);

    return Scaffold(
      appBar: myAppBar(context, dic.add_project),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: () => setState(
                    () => _enableBtn = _formKey.currentState!.validate()),
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
                          labelText: dic.userMinAmount,
                          suffixText: "USDT",
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
                              Fmt.tokenInt(val, Config.kUSDDecimals) <
                                  _minUsdt!) {
                            return dic.amount_too_low +
                                "; >" +
                                Fmt.token(_minUsdt, Config.kUSDDecimals);
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
                          suffixText: "USDT",
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
                              Fmt.tokenInt(val, Config.kUSDDecimals) >
                                  _maxUsdt!) {
                            return dic.amount_too_high +
                                "; <" +
                                Fmt.token(_maxUsdt, Config.kUSDDecimals);
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
        ),
      ),
    );
  }
}
