import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/pages/me/create_account/create/backup_account.dart';
import 'package:dicolite/pages/me/create_account/create/create_account_form.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage(this.setNewAccount);

  static final String route = '/me/createAccount/create';
  final Function setNewAccount;

  @override
  _CreateAccountPageState createState() =>
      _CreateAccountPageState(setNewAccount);
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  _CreateAccountPageState(this.setNewAccount);

  final Function setNewAccount;
  bool _useBiometricAuthorizen = false;
  String _password = '';

  int _step = 1;

  void _onFinish() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Container(),
          content: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 16, bottom: 24),
                child: Text(
                  S.of(context).create_warn9,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Text(S.of(context).create_warn10),
            ],
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoButton(
              child: Text(S.of(context).ok),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, BackupAccountPage.route,
                    arguments: [_useBiometricAuthorizen, _password]);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStep2(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    final S dic = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).create),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/dico/back.png',
            width: 11,
          ),
          onPressed: () {
            setState(() {
              _step = 1;
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(dic.create_warn1, style: theme.bodyText1),
                  ),
                  Text(dic.create_warn2),
                  Container(
                    padding: EdgeInsets.only(bottom: 16, top: 32),
                    child: Text(dic.create_warn3, style: theme.bodyText1),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(dic.create_warn4),
                  ),
                  Text(dic.create_warn5),
                  Container(
                    padding: EdgeInsets.only(bottom: 16, top: 32),
                    child: Text(dic.create_warn6, style: theme.bodyText1),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(dic.create_warn7),
                  ),
                  Text(dic.create_warn8),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: S.of(context).next,
                onPressed: _onFinish,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 2) {
      return _buildStep2(context);
    }
    return Scaffold(
      appBar: myAppBar(context, S.of(context).create),
      body: SafeArea(
        child: CreateAccountForm(
          setNewAccount: setNewAccount,
          submitting: false,
          onSubmit: (bool useBiometricAuthorizen, String password) {
            setState(() {
              _step = 2;
              _useBiometricAuthorizen = useBiometricAuthorizen;
              _password = password;
            });
          },
        ),
      ),
    );
  }
}
