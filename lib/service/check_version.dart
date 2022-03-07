import 'dart:io';

import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:dicolite/service/request_service.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/download_dialog.dart';

class CheckVersion {
  String? version = '';

  String _newVersion = '';

  String? _downloadUrl;

  /// Get package version
  static Future<String> getPackageVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  void _setNewVersion(newVersion, downloadUrl) {
    _newVersion = newVersion;
    _downloadUrl = downloadUrl;
  }

  /// Get new version
  void getNewVersion(BuildContext context, String lang) async {
    version = await getPackageVersion();
    print('version:$version');
    var response = await RequestService.getNewVersionData();
    if (response.code != 500) {
      String url;
      List versionList = response.data["versionlist"];
      if (versionList.isNotEmpty && versionList.first != null) {
        url = versionList.first["url"];

        var changes = lang == 'en'
            ? versionList.first["changes"]
            : versionList.first["changes-" + lang];
        _setNewVersion(versionList.first["version"], url);
        print('newversion:$_newVersion');
        if (changes == null) {
          changes = [];
        }
        _showUpdateDiloag(context, changes);
      }
    }
  }

  _showUpdateDiloag(BuildContext context, List changes) {
    if (version != null && _newVersion.isNotEmpty && version != _newVersion) {
      S dic = S.of(context);
        showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              dic.appStoreDowload,
            ),
            content: changes.isEmpty
                ? null
                : Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: changes
                          .asMap()
                          .keys
                          .map((i) => Text(
                                "${i + 1}. " + changes[i],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.visible,
                                style: TextStyle(fontSize: Adapt.px(25)),
                              ))
                          .toList(),
                    ),
                  ),
            actions: <Widget>[
              CupertinoButton(
                child: Text(
                  dic.cancel,
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
               
                  Navigator.pop(context);
                },
              ),
              CupertinoButton(
                child: Text(dic.updateNow),
                onPressed: () async {
                  Navigator.pop(context, true);
                  if (Platform.isIOS) {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Container(),
                          content:
                              Text("Please update in the apple testflight"),
                          actions: <Widget>[
                            CupertinoButton(
                              child: Text(S.of(context).ok),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (Platform.isAndroid) {
                      showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DownloadDialog(_downloadUrl!);
                      },
                    );
                    
                  }
                },
              ),
            ],
          );
        },
      );
      
    }
  }


}
