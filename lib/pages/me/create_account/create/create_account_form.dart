import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/my_utils.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/rounded_button.dart';

class CreateAccountForm extends StatefulWidget {
  CreateAccountForm(
      {required this.setNewAccount,
      required this.submitting,
      required this.onSubmit});

  final Function setNewAccount;
  final Function onSubmit;
  final bool submitting;

  @override
  State<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = new TextEditingController();

  final TextEditingController _passCtrl = new TextEditingController();

  final TextEditingController _pass2Ctrl = new TextEditingController();

  final FocusNode _nameFocusNode = new FocusNode();

  final FocusNode _passFocusNode = new FocusNode();

  final FocusNode _pass2FocusNode = new FocusNode();

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

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: dic.create_name,
                    ),
                    focusNode: _nameFocusNode,
                    onFieldSubmitted: (v) {
                      _passFocusNode.requestFocus();
                    },
                    maxLength: 8,
                    textInputAction: TextInputAction.next,
                    controller: _nameCtrl,
                    validator: (v) {
                      return v!.trim().length > 0
                          ? null
                          : dic.create_name_error;
                    },
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
                      hintText: dic.create_password,
                    ),
                    focusNode: _passFocusNode,
                    onFieldSubmitted: (v) {
                      _pass2FocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
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
                      hintText: dic.create_password2,
                    ),
                    focusNode: _pass2FocusNode,
                    textInputAction: TextInputAction.done,
                    controller: _pass2Ctrl,
                    obscureText: true,
                    validator: (v) {
                      return _passCtrl.text != v
                          ? dic.create_password2_error
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 10,
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
                          )
                         
                          )
                      : Container(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: S.of(context).next,
                onPressed: widget.submitting
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          widget.setNewAccount(
                              _nameCtrl.text.trim(), _passCtrl.text.trim());
                          widget.onSubmit(_useBiometricAuthorizen,_passCtrl.text.trim());
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
