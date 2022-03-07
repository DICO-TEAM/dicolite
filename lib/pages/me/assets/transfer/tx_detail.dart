import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/jump_to_browser_link.dart';
import 'package:dicolite/widgets/my_appbar.dart';

class TxDetail extends StatelessWidget {
  TxDetail({
    required this.success,
    required this.networkName,
    required this.action,
    required this.eventId,
    required this.hash,
    required this.blockTime,
    required this.blockNum,
    required this.info,
  });

  final bool success;
  final String networkName;
  final String action;
  final String eventId;
  final String hash;
  final String blockTime;
  final int blockNum;
  final List<DetailInfoItem> info;

  List<Widget> _buildListView(BuildContext context) {
    final S dic = S.of(context);
    Widget buildLabel(String name) {
      return Container(
          padding: EdgeInsets.only(left: 8),
          width: 80,
          child: Text(name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )));
    }

    var list = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(24),
            child: success
                ? Image.asset('assets/images/main/receive-success.png')
                : Text(''),
          ),
          Text(
            '$action ${success ? dic.success : dic.fail}',
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 32),
            child: Text(blockTime),
          ),
        ],
      ),
      Divider(),
    ];
    info.forEach((i) {
      list.add(ListTile(
        leading: buildLabel(i.label),
        title: Text(i.title),
        subtitle: i.subtitle != null ? Text(i.subtitle!) : null,
        trailing: i.address != null
            ? IconButton(
                icon: Image.asset('assets/images/main/copy.png'),
                onPressed: () => {copy(context, i.address)},
              )
            : null,
      ));
    });

    String scanLink = '${Config.scanUrl}/transaction/$hash';

    list.addAll(<Widget>[
      ListTile(
        leading: buildLabel(dic.event),
        title: Text(eventId),
      ),
      ListTile(
        leading: buildLabel(dic.block),
        title: Text('#$blockNum'),
      ),
      ListTile(
        leading: buildLabel(dic.hash),
        title: Text(Fmt.address(hash)),
        trailing: Container(
          width: 100,
          child: JumpToBrowserLink(
            scanLink,
            text: 'SCAN',
          ),
        ),
      ),
    ]);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, '${S.of(context).detail}',
          backgroundColor: Config.bgColor),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 32),
          children: _buildListView(context),
        ),
      ),
    );
  }
}

class DetailInfoItem {
  DetailInfoItem(
      {required this.label, required this.title, this.subtitle, this.address});
  final String label;
  final String title;
  final String? subtitle;
  final String? address;
}
