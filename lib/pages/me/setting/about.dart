import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/widgets/jump_to_browser_link.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/service/check_version.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';

class About extends StatefulWidget {
  static const route = '/me/setting/about';
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  String? _version;

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  Future<void> getVersion() async {
    String version = await CheckVersion.getPackageVersion();
    setState(() {
      _version = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, S.of(context).about,
          backgroundColor: Config.bgColor),
      body: Container(
          child: Center(
              child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/dico.png', width: Adapt.px(160)),
            SizedBox(
              height: 20,
            ),
            Text(
              "DICO",
              style: TextStyle(
                  color: Config.color333,
                  fontSize: Adapt.px(36),
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 19, 10, 10),
              child: Text(
                S.of(context).appDesc1,
                textAlign: TextAlign.center,
                style: TextStyle(color: Config.color333, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
              child: Text(
                S.of(context).appDesc2,
                textAlign: TextAlign.center,
                style: TextStyle(color: Config.color333, fontSize: 14),
              ),
            ),
            JumpToBrowserLink("https://dico.io"),
            SizedBox(
              height: 15,
            ),
            Text(
              S.of(context).version + ": $_version",
              style: TextStyle(color: Config.color999, fontSize: 12),
            ),
            SizedBox(
              height: 55,
            ),
          ],
        ),
      ))),
    );
  }
}
