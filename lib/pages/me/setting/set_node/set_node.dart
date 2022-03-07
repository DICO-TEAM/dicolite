import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/pages/me/setting/set_node/add_node.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/settings.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/utils/local_storage.dart';
import 'package:dicolite/widgets/my_appbar.dart';

const default_ss58_map = {
  'kusama': 2,
  'dico': 42,
  'kico': 42,
  'substrate': 42,
  'polkadot': 0,
};

const network_ss58_map = {
  'kusama': 2,
  'dico': 42,
  'kico': 42,
  'substrate': 42,
  'polkadot': 0,
};

EndpointData testNode = EndpointData.fromJson({
  'info': 'dico',
  'text': 'Test node',
  'value': Config.testNode,
  'ss58': default_ss58_map['dico']
});

EndpointData defaultNode = EndpointData.fromJson({
  'info': 'kico',
  'text': 'KICO node',
  'value': Config.kicoNode,
  'ss58': default_ss58_map['kico']
});

List<EndpointData> networkEndpoints = [
  defaultNode,
  testNode,
];

class SetNode extends StatefulWidget {
  static const route = '/me/setting/setNode';
  SetNode(this.store);

  final SettingsStore store;

  @override
  _SetNodeState createState() => _SetNodeState();
}

class _SetNodeState extends State<SetNode> {
  final Api? api = webApi;
  List<EndpointData> _nodeList = networkEndpoints;
  @override
  void initState() {
    _getCustomNodeList();
    super.initState();
  }

  _getCustomNodeList() async {
    Iterable<Map<String, dynamic>> list =
        await LocalStorage.getCustomEnterPointList();
    setState(() {
      _nodeList = [];
      _nodeList.addAll(networkEndpoints);
      _nodeList.addAll(list.map((e) => EndpointData.fromJson(e)).toList());
    });
  }

  /// Clear all custom node
  _clearAllCustomNode(BuildContext context) {
    var dic = S.of(context);
    showConfrim(
      context,
      Text(
        dic.clearCustomNodes + "?",
      ),
      () {
        LocalStorage.removeCustomEnterPointList();
        setState(() {
          _nodeList = [];
          _nodeList.addAll(networkEndpoints);
        });
      },
      okText: dic.clear,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = _nodeList
        .map((i) => ListTile(
              title: Text(i.info.toUpperCase()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(i.text),
                  Text(i.value),
                ],
              ),
              leading: Config.networkList.contains(i.info.toLowerCase())
                  ? Image.asset(
                      'assets/images/coins/${i.info.toLowerCase()}.png',
                      width: Adapt.px(70),
                      height: Adapt.px(70),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.grey,
                    ),
              isThreeLine: true,
              selected: widget.store.endpoint.value == i.value,
              trailing: widget.store.endpoint.value == i.value
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () async {
                if (widget.store.endpoint.value == i.value) {
                  Navigator.of(context).pop();
                  return;
                }
                widget.store.setEndpoint(i);
                api?.changeNode();
                // await api.close();
                // api.init();
                // RestartWidget.restartApp(context);
                Navigator.of(context).pop();
              },
            ))
        .toList();

    return Scaffold(
      appBar: myAppBar(context, S.of(context).selectNode, actions: <Widget>[
        IconButton(
          icon: Icon(Icons.clear_outlined),
          onPressed: () {
            _clearAllCustomNode(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            var res = await Navigator.pushNamed(context, AddNode.route);
            if (res == 1) {
              _getCustomNodeList();
            }
          },
        ),
      ]),
      body: SafeArea(
        child: ListView(padding: EdgeInsets.only(top: 8), children: list),
      ),
    );
  }
}
