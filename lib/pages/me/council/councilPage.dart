

import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/council/council.dart';
import 'package:dicolite/pages/me/council/motions.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/top_taps.dart';

class CouncilPage extends StatefulWidget {
  CouncilPage(this.store);

  static const String route = '/gov/council/index';

  final AppStore store;

  @override
  _GovernanceState createState() => _GovernanceState();
}

class _GovernanceState extends State<CouncilPage> {
  int _tab = 0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.store.settings!.loading) {
        return;
      }
      webApi!.gov!.fetchCouncilInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
   
    var dic = S.of(context);
    var tabs = [dic.council, dic.council_motions];
    if (widget.store.gov == null) {
      return Scaffold(
        appBar: myAppBar(context, dic.council),
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    return
       
        Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          // color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset('assets/images/dico/back.png',width: 11,),
                  ),
                  Expanded(
                    child: TopTabs(
                      names: tabs,
                      activeTab: _tab,
                      onTab: (v) {
                        setState(() {
                          if (_tab != v) {
                            _tab = v;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              Observer(
                builder: (_) {
                  return Expanded(
                    child: widget.store.gov!.council.members == null
                        ? CupertinoActivityIndicator()
                        : _tab == 0
                            ? Council(widget.store)
                            : Motions(widget.store),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
