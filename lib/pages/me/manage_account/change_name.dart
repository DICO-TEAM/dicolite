import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/store/account/account.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class ChangeName extends StatefulWidget {
  ChangeName(this.store);
  static final String route = '/me/manageAccount/name';
  final AccountStore store;

  @override
  _ChangeName createState() => _ChangeName(store);
}

class _ChangeName extends State<ChangeName> {
  _ChangeName(this.store);

  final AccountStore store;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = new TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nameCtrl.text = store.currentAccount.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Scaffold(
      appBar: myAppBar(context, dic.name_change),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
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
                          hintText: dic.create_name,
                        ),
                        controller: _nameCtrl,
                        maxLength: 10,
                        validator: (v) {
                          String name = v!.trim();
                          if (name.length == 0) {
                            return dic.contact_name_error;
                          }
                          int exist = store.optionalAccounts
                              .indexWhere((i) => i.name == name);
                          if (exist > -1) {
                            return dic.contact_name_exist;
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
                text: dic.save,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    store.updateAccountName(_nameCtrl.text.trim());
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
