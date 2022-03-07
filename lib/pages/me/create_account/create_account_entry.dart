import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/widgets/jump_to_browser_link.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/pages/me/create_account/create/create_account.dart';
import 'package:dicolite/pages/me/create_account/import/import_account.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/rounded_button.dart';
import 'package:flutter/services.dart';

class CreateAccountEntryPage extends StatelessWidget {
  static final String route = '/me/createAccount/entry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(S.of(context).create,style: TextStyle(color: Config.color333),),
        backgroundColor: Config.bgColor,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        // centerTitle: true,
        leading: Container(),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              width: Adapt.px(400),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: Adapt.px(150),
                  ),
                  Image.asset('assets/images/dico.png', width: Adapt.px(160)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'DICO',
                    style: TextStyle(fontSize: Adapt.px(36)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  JumpToBrowserLink("https://dico.io"),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: RoundedButton(
                      round: true,
                      text: S.of(context).create,
                      onPressed: () {
                        Navigator.pushNamed(context, CreateAccountPage.route);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: RoundedButton(
                      round: true,
                      backgroundColor: Config.secondColor,
                      text: S.of(context).import,
                      onPressed: () {
                        Navigator.pushNamed(context, ImportAccountPage.route);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      S.of(context).appDesc1,
                      style: TextStyle(
                          color: Config.color999, fontSize: Adapt.px(32)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      S.of(context).appDesc2,
                      style: TextStyle(
                        color: Config.color999,
                        fontSize: Adapt.px(24),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
