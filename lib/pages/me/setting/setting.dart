import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/pages/me/contacts/contacts_page.dart';
import 'package:dicolite/pages/me/manage_account/manage_account.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/widgets/loading_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/setting/about.dart';
import 'package:dicolite/pages/me/setting/custom_types.dart';
import 'package:dicolite/pages/me/setting/set_node/set_node.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/my_tile.dart';

class Setting extends StatefulWidget {
  static const route = '/me/setting';
  final AppStore store;
  final Function changeLang;

  Setting(
    this.store,
    this.changeLang,
  );
  @override
  _SettingState createState() => _SettingState(store, changeLang);
}

class _SettingState extends State<Setting> {
  _SettingState(
    this.store,
    this.changeLang,
  );

  final AppStore store;
  final Function changeLang;


  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: myAppBar(context, S.of(context).setting),
      body: Observer(builder: (_) {
        if (store.account!.currentAccountPubKey.isEmpty) {
          return Scaffold(
            body: Center(
              child: LoadingWidget(),
            ),
          );
        }
        return Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    store.account?.currentAccount.observation != null &&
                            !store.account!.currentAccount.observation
                        ? myTile(
                            title: S.of(context).manageAccount,
                            onTap: () => Navigator.of(context)
                                .pushNamed(ManageAccount.route),
                          )
                        : Container(),
                    myTile(
                      title: S.of(context).contact,
                      onTap: () =>
                          Navigator.of(context).pushNamed(ContactsPage.route),
                      noborder: true,
                    ),
                  ],
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
                      title: S.of(context).setNode,
                      onTap: () =>
                          Navigator.of(context).pushNamed(SetNode.route),
                    ),
                    myTile(
                      title: S.of(context).custom_types,
                      onTap: () =>
                          Navigator.of(context).pushNamed(CustomTypes.route),
                      noborder: true,
                    ),
                    // myTile(
                    //   title: S.of(context).language,
                    //   onTap: _onLanguageTap,
                    //   noborder: true,
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: myTile(
                  title: S.of(context).about,
                  noborder: true,
                  onTap: () => Navigator.of(context).pushNamed(About.route),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
