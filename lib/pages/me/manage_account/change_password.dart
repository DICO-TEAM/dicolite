import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/pages/me/manage_account/manage_account.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/account/account.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/utils/local_storage.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword(this.store);

  static final String route = '/me/manageAccount/password';
  final AccountStore store;

  @override
  _ChangePassword createState() => _ChangePassword(store);
}

class _ChangePassword extends State<ChangePassword> {
  _ChangePassword(this.store);

  final Api? api = webApi;
  final AccountStore store;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passOldCtrl = new TextEditingController();
  final TextEditingController _passCtrl = new TextEditingController();
  final TextEditingController _pass2Ctrl = new TextEditingController();
  bool _supportBiometric = false;

  bool _useBiometricAuthorizen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _checkBiometricAuth(context);
    });
  }

  Future<void> _checkBiometricAuth(BuildContext context) async {
    bool supportBiometric = await checkBiometricAuth(context);
    setState(() {
      _supportBiometric = supportBiometric;
      _useBiometricAuthorizen = supportBiometric;
    });
  }

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate()) {
      var dic = S.of(context);
      var acc = await api!.evalJavascript(
          'account.changePassword("${store.currentAccount.pubKey}", "${_passOldCtrl.text}", "${_passCtrl.text}")');
      if (acc == null) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(dic.pass_error),
              content: Text(dic.pass_error_txt),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(S.of(context).ok),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else {
        String publicKey = store.currentAccount.pubKey;
        if (_useBiometricAuthorizen) {
          try {
            final storeFile =
                await getBiometricPassStoreFile(context, publicKey);

            storeFile.write(_passCtrl.text.trim());
            LocalStorage.setUseBio(true, publicKey);
          } catch (e) {}
        } else {
          LocalStorage.setUseBio(false, publicKey);
        }

        // use local name, not webApi returned name
        Map<String, dynamic> localAcc =
            AccountData.toJson(store.currentAccount);
        acc['meta']['name'] = localAcc['meta']['name'];
        store.updateAccount(acc);
        // update encrypted seed after password updated
        store.updateSeed(
            store.currentAccount.pubKey, _passOldCtrl.text, _passCtrl.text);
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(dic.pass_success),
              content: Text(dic.pass_success_txt),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(S.of(context).ok),
                  onPressed: () => Navigator.popUntil(
                      context, ModalRoute.withName(ManageAccount.route)),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Scaffold(
      appBar: myAppBar(context, dic.pass_change),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(Adapt.px(30)),
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: dic.pass_old,
                        suffixIcon: IconButton(
                          iconSize: 18,
                          icon: Icon(
                            CupertinoIcons.clear_thick_circled,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                          onPressed: () {
                            WidgetsBinding.instance!.addPostFrameCallback(
                                (_) => _passOldCtrl.clear());
                          },
                        ),
                      ),
                      controller: _passOldCtrl,
                      validator: (v) {
                        return Fmt.checkPassword(v!.trim())
                            ? null
                            : dic.create_password_error;
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: dic.pass_new,
                      ),
                      controller: _passCtrl,
                      validator: (v) {
                        return Fmt.checkPassword(v!.trim())
                            ? null
                            : dic.create_password_error;
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: dic.pass_new2,
                      ),
                      controller: _pass2Ctrl,
                      validator: (v) {
                        return v!.trim() != _passCtrl.text
                            ? dic.create_password2_error
                            : null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    _supportBiometric
                        ? ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              S.of(context).unlock_bio_enable,
                              style: TextStyle(
                                color: Config.color333,
                                fontSize: Adapt.px(30),
                              ),
                            ),
                            leading: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              value: _useBiometricAuthorizen,
                              onChanged: (bool? v) {
                                setState(() {
                                  _useBiometricAuthorizen = v!;
                                });
                              },
                            ))
                        : Container(),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: RoundedButton(text: dic.save, onPressed: _onSave),
            ),
          ],
        ),
      ),
    );
  }
}
