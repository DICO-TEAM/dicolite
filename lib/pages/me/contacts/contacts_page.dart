import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/contacts/contact_page.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/settings.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/no_data.dart';

class ContactsPage extends StatelessWidget {
  ContactsPage(this.store);

  static final String route = '/me/contacts';
  final SettingsStore store;

  void _showActions(BuildContext pageContext, AccountData i) {
    showCupertinoModalPopup(
      context: pageContext,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              S.of(context).edit,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ContactPage.route, arguments: i);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              S.of(context).delete,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _removeItem(pageContext, i);
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _removeItem(BuildContext context, AccountData i) {
    var dic = S.of(context);
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(dic.contact_delete_warn),
          content: Text(Fmt.accountName(context, i)),
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
                store.removeContact(i);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          return Scaffold(
            appBar: myAppBar(
              context,
              S.of(context).contact,
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(Icons.add, size: 28),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(ContactPage.route),
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: store.contactList.isNotEmpty
                  ? ListView(
                      children: store.contactList.map((i) {
                        return ListTile(
                          leading: AddressIcon(i.address),
                          title: Text(Fmt.accountName(context, i)),
                          subtitle: Text(Fmt.address(i.address)),
                          trailing: Container(
                            width: 36,
                            child: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () => _showActions(context, i),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Center(
                      child: NoData(),
                    ),
            ),
          );
        },
      );
}
