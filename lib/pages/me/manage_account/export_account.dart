
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/pages/me/manage_account/export_result.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/account/account.dart';

import 'package:dicolite/widgets/my_appbar.dart';

class ExportAccount extends StatelessWidget {
  ExportAccount(this.store);
  static final String route = '/me/manageAccount/export';
  static final String exportTypeKeystore = 'keystore';
  final AccountStore store;

  final TextEditingController _passCtrl = new TextEditingController();

  void _showPasswordDialog(BuildContext context, String seedType) {
    final S dic = S.of(context);

    Future<void> onOk() async {
      Loading.showLoading(context);
      var res = await webApi!.account!.checkAccountPassword(_passCtrl.text);
      Loading.hideLoading(context);
      if (res == null) {
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
        Navigator.of(context).pop();
        String? seed = await store.decryptSeed(
            store.currentAccount.pubKey, seedType, _passCtrl.text.trim());
        Navigator.of(context).pushNamed(ExportResult.route, arguments: {
          'key': seed,
          'type': seedType,
        });
      }
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(dic.inputPasswordConfirm),
          content: Padding(
            padding: EdgeInsets.only(top: 16),
            child: CupertinoTextField(
              placeholder: dic.pass_old,
              controller: _passCtrl,
              clearButtonMode: OverlayVisibilityMode.editing,
              obscureText: true,
            ),
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _passCtrl.clear();
              },
            ),
            CupertinoButton(
              child: Text(S.of(context).ok),
              onPressed: onOk,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dic = S.of(context);
    return Scaffold(
      appBar: myAppBar(context, dic.export),
      body: ListView(
        children: <Widget>[
          
          FutureBuilder(
            future: store.checkSeedExist(
                AccountStore.seedTypeMnemonic, store.currentAccount.pubKey),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(dic.mnemonic),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () => _showPasswordDialog(
                        context, AccountStore.seedTypeMnemonic),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          FutureBuilder(
            future: store.checkSeedExist(
                AccountStore.seedTypeRawSeed, store.currentAccount.pubKey),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Container(
                   color: Colors.white,
                  child: ListTile(
                    title: Text(dic.rawSeed),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () => _showPasswordDialog(
                        context, AccountStore.seedTypeRawSeed),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
