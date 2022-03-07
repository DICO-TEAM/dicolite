import 'dart:convert';

import 'package:dicolite/config/country_code_english.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/kyc_info_model.dart';
import 'package:dicolite/pages/me/kyc/kyc.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/loading.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class AddKyc extends StatefulWidget {
  AddKyc(this.store);
  static final String route = '/me/kyc/addkyc';
  final AppStore store;

  @override
  _AddKyc createState() => _AddKyc(store);
}

class _AddKyc extends State<AddKyc> {
  _AddKyc(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = new TextEditingController();
  String _area = countryCodeEnglish[0]["code"]!;

  final TextEditingController _curvePublicKeyCtrl = new TextEditingController();
  final TextEditingController _emailCtrl = new TextEditingController();
  bool _enableBtn = false;
  FocusNode _nameNode = FocusNode();
  FocusNode _emailNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var args =
          ModalRoute.of(context)!.settings.arguments as KycInfoModel?;

      if (args != null) {
        _nameCtrl.text = args.info.name;
        _area = args.info.area;
        _curvePublicKeyCtrl.text = args.info.curvePublicKey;
        _emailCtrl.text = args.info.email;
      }
    });
  }

  Future _getCurvePublicKey() async {
    Loading.showLoading(context);
    String? res = await webApi?.dico?.fetchKYCMyCurvePublicKey(context);
   
    if (res != null && res.isNotEmpty) {
      setState(() {
        _curvePublicKeyCtrl.text = "0x" + res;
      });
    }
    Loading.hideLoading(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameCtrl.dispose();
    _curvePublicKeyCtrl.dispose();
    _emailCtrl.dispose();
    _nameNode.dispose();
    _emailNode.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).set_kyc,
        
          module: 'kyc',
          call: 'setKyc',
        detail: jsonEncode({
          "info": {
            "name": _nameCtrl.text.trim(),
            "area": _area,
            "curvePublicKey": _curvePublicKeyCtrl.text.trim(),
            "email": _emailCtrl.text.trim(),
          }
        }),
        params: [
          {
            "name": _nameCtrl.text.trim(),
            "area": _area,
            "curvePublicKey": _curvePublicKeyCtrl.text.trim(),
            "email": _emailCtrl.text.trim(),
          }
        ],
        onSuccess: (res) {
          globalKycInfoRefreshKey.currentState?.show();
        },
      );

     
      var res = await Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args) ;
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Kyc.route));
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);

    return Scaffold(
      appBar: myAppBar(context, dic.set_kyc),
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
                        value: _area,
                        items: countryCodeEnglish
                            .map((f) => DropdownMenuItem(
                                  child: Container(
                                    width: Adapt.px(560),
                                    child: Text(
                                      f["name"]! + "(${f['code']})",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  value: f["code"]!,
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _area = v as String;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 0, 15),
                            filled: true,
                            labelText: dic.area),
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(
                        Adapt.px(30),
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: dic.curvePublicKey,
                                ),
                                controller: _curvePublicKeyCtrl,
                                textInputAction: TextInputAction.next,
                                readOnly: true,
                                validator: (v) {
                                  String val = v!.trim();
                                  if (val.length == 0) {
                                    return dic.required;
                                  } else if (!RegExp("^0x[A-Za-z0-9]{64}\$")
                                      .hasMatch(val)) {
                                    return dic.input_invalid;
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 6,
                                right: 6,
                              ),
                              child: ElevatedButton(
                                onPressed: _getCurvePublicKey,
                                child: Text(dic.generate),
                              ),
                            ),
                          ],
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
                          labelText: dic.name+dic.optional,
                        ),
                        controller: _nameCtrl,
                        focusNode: _nameNode,
                        textInputAction: TextInputAction.next,
                        maxLength: 20,
                        
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
                          labelText: dic.email+dic.optional,
                        ),
                        controller: _emailCtrl,
                        maxLength: 30,
                        focusNode: _emailNode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          String val = v!.trim();
                          if (val.length == 0) {
                            return null;
                          } else if (!RegExp(
                                  "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$")
                              .hasMatch(val)) {
                            return dic.input_invalid;
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
