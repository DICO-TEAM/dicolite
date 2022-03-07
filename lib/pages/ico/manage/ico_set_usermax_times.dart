import 'dart:async';
import 'dart:convert';

import 'package:dicolite/common/reg_input_formatter.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/ico_add_list_model.dart';
import 'package:dicolite/pages/ico/manage/ico_manage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class IcoSetUsermaxTimes extends StatefulWidget {
  IcoSetUsermaxTimes(this.store);
  static final String route = '/ico/IcoSetUsermaxTimes';
  final AppStore store;

  @override
  _IcoSetUsermaxTimes createState() => _IcoSetUsermaxTimes(store);
}

class _IcoSetUsermaxTimes extends State<IcoSetUsermaxTimes> {
  _IcoSetUsermaxTimes(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController userIcoMaxTimesCtrl = new TextEditingController();
  bool _enableBtn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    userIcoMaxTimesCtrl.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      S dic = S.of(context);
      var data = ModalRoute.of(context)!.settings.arguments as IcoAddListModel;
      TxConfirmParams args = TxConfirmParams(
        title: dic.changeUserIcoMaxTimes,
        module: 'ico',
        call: 'initiatorSetIcoMaxTimes',
        detail: jsonEncode({
          "currencyId": data.currencyId,
          "index": data.index,
          "userIcoMaxTimes": userIcoMaxTimesCtrl.text.trim(),
        }),
        params: [
          data.currencyId,
          data.index,
          userIcoMaxTimesCtrl.text.trim(),
        ],
        onSuccess: (res) {
          webApi?.dico?.fetchAddedIcoList();
        },
      );

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
      appBar: myAppBar(context, dic.changeUserIcoMaxTimes),
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
                          labelText: dic.userIcoMaxTimes,
                        ),
                        controller: userIcoMaxTimesCtrl,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        inputFormatters: [
                          RegExInputFormatter.withRegex('^[0-9]{0,3}\$')
                        ],
                        validator: (v) {
                          String val = v!.trim();
                          if (val.length == 0) {
                            return dic.required;
                          } else if (!RegExp("^[0-9]+\$").hasMatch(val)) {
                            return dic.formatMistake;
                          } else if (int.parse(val) > 255 ||
                              int.parse(val) < 1) {
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
