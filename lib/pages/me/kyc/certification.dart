import 'dart:async';
import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/kyc_fileds_model.dart';
import 'package:dicolite/pages/me/kyc/kyc.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/my_utils.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Certification extends StatefulWidget {
  Certification(this.store);
  static final String route = '/me/kyc/certification';
  final AppStore store;

  @override
  _Certification createState() => _Certification(store);
}

class _Certification extends State<Certification> {
  _Certification(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  String _fileds = kycFiledsModelList[0];
  final TextEditingController _maxFeeCtrl = new TextEditingController();

  bool _enableBtn = false;
  BigInt? _recommandFee;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _getRecommandFee();
  }

  Future _getRecommandFee() async {
    BigInt? res = await webApi?.dico?.fetchKYCRecommandFee(_fileds);
    if (res != null && mounted) {
      setState(() {
        _recommandFee = res;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    _maxFeeCtrl.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      int decimals = store.settings!.networkState.tokenDecimals;
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).applyCertification,
        module: 'kyc',
        call: 'applyCertification',
        detail: jsonEncode({
          "kycFields": _fileds,
          "maxFee": _maxFeeCtrl.text.trim(),
        }),
        params: [
          _fileds,
          Fmt.tokenInt(_maxFeeCtrl.text.trim(), decimals).toString()
        ],
        onSuccess: (res) {
          globalKycInfoRefreshKey.currentState?.show();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Kyc.route));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Observer(builder: (_) {
      String symbol = store.settings!.networkState.tokenSymbol;
      int decimals = store.settings!.networkState.tokenDecimals;
      return Scaffold(
        appBar: myAppBar(context, dic.applyCertification),
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
                        child: DropdownButtonFormField(
                          value: _fileds,
                          items: kycFiledsModelList
                              .map((f) => DropdownMenuItem(
                                    onTap: () {
                                      debounce(_getRecommandFee, timer);
                                    },
                                    child: Text(
                                      f.toString(),
                                      textAlign: TextAlign.left,
                                    ),
                                    value: f,
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _fileds = v as String;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 0, 15),
                            filled: true,
                            labelText: dic.fileds,
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
                            labelText: dic.max_fee +
                                (_recommandFee != null
                                    ? " (${dic.recommend}:${Fmt.token(_recommandFee, decimals)} $symbol)"
                                    : ""),
                            suffixText: symbol,
                          ),
                          controller: _maxFeeCtrl,
                          inputFormatters: [UI.decimalInputFormatter(decimals)],
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.done,
                          validator: (v) {
                            String val = v!.trim();
                            if (val.isEmpty) {
                              return dic.amount_error;
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
    });
  }
}
