import 'dart:async';
import 'dart:convert';

import 'package:dicolite/common/reg_input_formatter.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/ico_add_list_model.dart';
import 'package:dicolite/pages/ico/manage/ico_manage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';

import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class IcoRequestRelease extends StatefulWidget {
  IcoRequestRelease(this.store);
  static final String route = '/ico/IcoRequestRelease';
  final AppStore store;

  @override
  _IcoRequestRelease createState() => _IcoRequestRelease(store);
}

class _IcoRequestRelease extends State<IcoRequestRelease> {
  _IcoRequestRelease(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController percentCtrl = new TextEditingController();

  bool _enableBtn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    percentCtrl.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      var data = ModalRoute.of(context)!.settings.arguments as IcoAddListModel;

      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).requestRelease,
          module: 'ico',
          call: 'requestRelease',
       
        detail: jsonEncode({
          "currencyId": data.currencyId,
          "index": data.index,
          "percent": percentCtrl.text.trim(),
        }),
       params: [
          data.currencyId,
          data.index,
          percentCtrl.text.trim(),
        ],
        onSuccess:(res){
           webApi?.dico?.fetchAddedIcoList();
            globalDaoRefreshKey.currentState?.show();
        }
      );

    
       var res = await Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
        if (res != null) {
         
          Navigator.popUntil(context, ModalRoute.withName(IcoManage.route));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);

    return Scaffold(
      appBar: myAppBar(context, dic.requestRelease),
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
                       15
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                          labelText: dic.releaseProgress,
                          suffixText: "%",
                        ),
                        controller: percentCtrl,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        inputFormatters: [
                          RegExInputFormatter.withRegex('^[0-9]{0,3}\$')
                        ],
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
