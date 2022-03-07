import 'dart:async';

import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:update_app/bean/download_process.dart';
import 'package:update_app/update_app.dart';

class DownloadDialog extends StatefulWidget {
  DownloadDialog(this.url);
  final String url;

  @override
  _DownloadDialog createState() => _DownloadDialog(url);
}

class _DownloadDialog extends State<DownloadDialog> {
  _DownloadDialog(this.url);
  final String url;
 

  Timer? timer;

  double downloadProcess = 0;

  ProcessState downloadStatus = ProcessState.STATUS_PENDING;



  @override
  void initState() {
    super.initState();
    download();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void download() async {
    var downloadId = await UpdateApp.updateApp(url: url, appleId: "000000000",description:"Update app");

    // find same apk in local
    if (downloadId == 0) {
      setState(() {
        downloadProcess = 1;
        downloadStatus = ProcessState.STATUS_SUCCESSFUL;
      });
      return;
    }

    //faild
    if (downloadId == -1) {
      setState(() {
        downloadProcess = 1;
        downloadStatus = ProcessState.STATUS_FAILED;
      });
      return;
    }

    //dowload file
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      var process = await UpdateApp.downloadProcess(downloadId: downloadId);
      //update
      if (!mounted) return;
      setState(() {
        downloadProcess = process.current / process.count;
        downloadStatus = process.status;
      });

      if (process.status == ProcessState.STATUS_SUCCESSFUL ||
          process.status == ProcessState.STATUS_FAILED) {
      
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double progressWidth = 200;
    double progress = progressWidth * downloadProcess;
   
    S dic = S.of(context);
    return CupertinoAlertDialog(
      title:
         
          Text(downloadStatus == ProcessState.STATUS_PENDING
              ? dic.update_start
              : downloadStatus == ProcessState.STATUS_FAILED
                  ? dic.update_error
                  : dic.update_download),
      content: Padding(
        padding: EdgeInsets.only(top: 12),
        child: Stack(
          children: <Widget>[
            Container(
              width: progressWidth,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 4, color: Colors.black12),
                ),
              ),
            ),
            Container(
              width: progress,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 4, color: Theme.of(context).primaryColor),
                ),
              ),
            )
          ],
        ),
      ),
      actions: downloadStatus == ProcessState.STATUS_FAILED
          ? <Widget>[
              CupertinoButton(
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
          : const <Widget>[],
    );
  }
}
