import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/pages/me/address_qr.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/pages/me/manage_account/change_name.dart';
import 'package:dicolite/pages/me/manage_account/change_password.dart';
import 'package:dicolite/pages/me/manage_account/export_account.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/utils/loading.dart';
import 'package:dicolite/utils/local_storage.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/my_tile.dart';

import '../../home.dart';

class ManageAccount extends StatefulWidget {
  ManageAccount(this.store);
  static const route = '/me/manageAccount';
  final AppStore store;

  @override
  _ManageAccountState createState() => _ManageAccountState(store);
}

class _ManageAccountState extends State<ManageAccount> {
  _ManageAccountState(this.store);
  final Api? api = webApi;
  final AppStore store;

  final TextEditingController _passCtrl = new TextEditingController();

  bool _supportBiometric = false; // if device support biometric
  bool _isBiometricAuthorized = false; // if user authorized biometric usage

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _checkBiometricAuth(context);
    });
  }

  Future<void> _checkBiometricAuth(BuildContext context) async {
    bool supportBiometric = await checkBiometricAuth(context);

    if (!supportBiometric) {
      return;
    }
    bool isUseBio =
        await LocalStorage.getUseBio(store.account!.currentAccountPubKey);
    if (mounted) {
      setState(() {
        _supportBiometric = supportBiometric;
        _isBiometricAuthorized = isUseBio;
      });
    }
  }

  changeBio(v) async {
    if (v != _isBiometricAuthorized) {
      String? password = await showPasswordDialog(
          context, store.account!.currentAccountPubKey,
          isShowGoAuth: false);

      if (password == null) return;
      if (v) {
        try {
          bool isSupport = await checkBiometricAuth(context);
          if (isSupport == false) return;

          final authStorage = await getBiometricPassStoreFile(
              context, store.account!.currentAccountPubKey);
          await authStorage.write(password);
        } catch (e) {
          print(e);
          return;
        }
      }
      await LocalStorage.setUseBio(v, store.account!.currentAccountPubKey);
      if (mounted) {
        setState(() {
          _isBiometricAuthorized = v;
        });
      }
    }
  }

  void _onDeleteAccount(BuildContext context) {
    final S dic = S.of(context);

    Future<void> onOk() async {
      Loading.showLoading(context);
      var res = await api!.account!.checkAccountPassword(_passCtrl.text);
      Loading.hideLoading(context);
      if (res == null) {
        showErrorMsg(dic.pass_error);
      } else {
        await LocalStorage.setUseBio(
            false, store.account!.currentAccountPubKey);
        await store.account!.removeAccount(store.account!.currentAccount);
        store.dico!.clearState();

        store.assets!.loadAccountCache();

        webApi!.afterLoadAccountData();

        // Navigator.popUntil(context, ModalRoute.withName(Home.route));
        if (store.account?.accountList.length != null &&
            store.account!.accountList.length > 0) {
          Navigator.popUntil(context, ModalRoute.withName(Home.route));
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Home.route, (route) => false);
        }
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
              obscureText: true,
              clearButtonMode: OverlayVisibilityMode.editing,
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
    final S dic = S.of(context);

    return Observer(builder: (_) {
      if (store.account!.currentAccountPubKey.isEmpty) {
        return Scaffold(
          body: Center(
            child: LoadingWidget(),
          ),
        );
      }
      return Scaffold(
        appBar: myAppBar(context, S.of(context).manageAccount),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: ListTile(
                        leading: widget.store.dico?.activeNftToken?.imageUrl !=
                                    null &&
                                widget.store.dico!.activeNftToken!.imageUrl
                                    .isNotEmpty
                            ? Logo(
                                logoUrl:
                                    widget.store.dico?.activeNftToken?.imageUrl,
                                size: Adapt.px(100),
                              )
                            : AddressIcon(
                                '',
                                size: Adapt.px(100),
                                pubKey:
                                    widget.store.account?.currentAccount.pubKey,
                              ),
                        title: Text(
                          store.account!.currentAccount.name ?? 'name',
                          style: TextStyle(
                              fontSize: Adapt.px(36), color: Config.color333),
                        ),
                        subtitle: Text(
                          Fmt.address(store.account!.currentAddress),
                          style: TextStyle(
                              fontSize: Adapt.px(26), color: Config.color999),
                        ),
                        onTap: () =>
                            Navigator.pushNamed(context, AddressQR.route),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          myTile(
                            title: dic.name_change,
                            onTap: () => Navigator.of(context)
                                .pushNamed(ChangeName.route),
                          ),
                          myTile(
                            title: dic.pass_change,
                            onTap: () => Navigator.of(context)
                                .pushNamed(ChangePassword.route),
                          ),
                          myTile(
                            title: dic.export,
                            onTap: () => Navigator.of(context)
                                .pushNamed(ExportAccount.route),
                            noborder: !_supportBiometric,
                          ),
                          _supportBiometric
                              ? ListTile(
                                  title: Text(
                                    S.of(context).unlock_bio_enable,
                                    style: TextStyle(
                                      color: Config.color333,
                                      fontSize: Adapt.px(30),
                                    ),
                                  ),
                                  trailing: CupertinoSwitch(
                                    activeColor: Theme.of(context).primaryColor,
                                    value: _isBiometricAuthorized,
                                    onChanged: changeBio,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                        backgroundColor: MaterialStateProperty.all(Colors.pink),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        dic.deleteAccount,
                      ),
                      onPressed: () => _onDeleteAccount(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
