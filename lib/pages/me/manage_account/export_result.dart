import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/pages/me/manage_account/export_account.dart';

import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/my_appbar.dart';

class ExportResult extends StatelessWidget {
  static final String route = '/me/manageAccount/key';

  
  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: myAppBar(context, dic.export),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  args['type'] == ExportAccount.exportTypeKeystore
                      ? Container()
                      : Text(dic.export_warn),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(
                          S.of(context).copy,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          copy(context, args['key']);
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black12,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      args['key'],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
