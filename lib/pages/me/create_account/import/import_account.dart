import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/pages/me/create_account/create/create_account_form.dart';
import 'package:dicolite/pages/me/create_account/import/import_account_form.dart';

import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/utils/loading.dart';
import 'package:dicolite/widgets/my_appbar.dart';

import '../../../home.dart';

class ImportAccountPage extends StatefulWidget {
  const ImportAccountPage(this.store);

  static final String route = '/me/createAccount/import';
  final AppStore store;

  @override
  _ImportAccountPageState createState() => _ImportAccountPageState(store);
}

class _ImportAccountPageState extends State<ImportAccountPage> {
  _ImportAccountPageState(this.store);
  final AppStore store;

  int _step = 0;
  String _keyType = '';
  String _cryptoType = '';
  String _derivePath = '';
  bool _submitting = false;

  Future<void> _importAccount(bool useBiometricAuthorizen,String password) async {
    setState(() {
      _submitting = true;
    });
    Loading.showLoading(context);

    Map<String, dynamic>? acc = await webApi!.account!.importAccount(
      keyType: _keyType,
      cryptoType: _cryptoType,
      derivePath: _derivePath,
    );
    setState(() {
      _submitting = false;
    });
    Loading.hideLoading(context);

    /// check if account duplicate
    if (acc != null) {
      if (acc['error'] != null) {
        UI.alertWASM(context, () {
          setState(() {
            _step = 0;
          });
        });
        return;
      }
      _checkAccountDuplicate(acc, useBiometricAuthorizen, password);
      return;
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final S dic = S.of(context);
        return CupertinoAlertDialog(
          title: Container(),
          content: Text('${dic.import_invalid} ${dic.create_password}'),
          actions: <Widget>[
            CupertinoButton(
              child: Text(S.of(context).cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkAccountDuplicate(
      Map<String, dynamic> acc, bool useBiometricAuthorizen,String password) async {
    int index =
        store.account!.accountList.indexWhere((i) => i.pubKey == acc['pubKey']);
    if (index > -1) {
      Map<String, String> pubKeyMap =
          store.account!.pubKeyAddressMap[store.settings!.endpoint.ss58]!;
      String? address = pubKeyMap[acc['pubKey']];
      if (address != null) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(Fmt.address(address)),
              content: Text(S.of(context).import_duplicate),
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
                    _saveAccount(acc, useBiometricAuthorizen, password);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      _saveAccount(acc, useBiometricAuthorizen, password);
    }
  }

  Future<void> _saveAccount(
      Map<String, dynamic> acc, bool useBiometricAuthorizen,String password) async {
    Loading.showLoading(context);
    await webApi!.account!.saveAccount(acc);

    Loading.hideLoading(context);
    if (useBiometricAuthorizen) {
     await setBiometricAuth(context, acc["pubKey"],password);
    }
    if (store.account?.accountList.length != null &&
        store.account!.accountList.length > 1) {
      Navigator.popUntil(context, ModalRoute.withName(Home.route));
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Home.route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 1) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).import),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Image.asset(
              'assets/images/dico/back.png',
              width: 11,
            ),
            onPressed: () {
              setState(() {
                _step = 0;
              });
            },
          ),
        ),
        body: SafeArea(
          child: CreateAccountForm(
            setNewAccount: store.account!.setNewAccount,
            submitting: _submitting,
            onSubmit: _importAccount,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: myAppBar(context, S.of(context).import),
      body: SafeArea(
        child: ImportAccountForm(store.account!, (Map<String, dynamic> data) {
          if (data['finish'] == null) {
            setState(() {
              _keyType = data['keyType'];
              _cryptoType = data['cryptoType'];
              _derivePath = data['derivePath'];
              _step = 1;
            });
          } else {
            setState(() {
              _keyType = data['keyType'];
              _cryptoType = data['cryptoType'];
              _derivePath = data['derivePath'];
            });
            _importAccount(false,'');
          }
        }),
      ),
    );
  }
}
