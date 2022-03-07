import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/pages/me/contacts/contact_page.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/app.dart';

import 'package:dicolite/widgets/account_select-list.dart';
import 'package:dicolite/widgets/my_appbar.dart';

class ContactListPage extends StatelessWidget {
  ContactListPage(this.store);

  static final String route = '/me/contacts/list';
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final List<AccountData>? args = ModalRoute.of(context)!.settings.arguments as List<AccountData>?;
    return Scaffold(
      appBar: myAppBar(
        context,
        args == null
            ? S.of(context).contact
            : S.of(context).list,
        actions: <Widget>[
          args == null
              ? Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(Icons.add, size: 28),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(ContactPage.route),
                  ),
                )
              : Container()
        ],
      ),
      body: SafeArea(
        child: AccountSelectList(
          store,
          args ?? store.settings!.contactListAll.toList(),
        ),
      ),
    );
  }
}
