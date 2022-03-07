import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/pages/me/democracy/democracy.dart';
import 'package:dicolite/pages/me/democracy/proposals.dart';
import 'package:dicolite/store/app.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/top_taps.dart';

class DemocracyPage extends StatefulWidget {
  DemocracyPage(this.store);

  static const String route = '/gov/democracy/index';

  final AppStore store;

  @override
  _DemocracyPageState createState() => _DemocracyPageState();
}

class _DemocracyPageState extends State<DemocracyPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    var tabs = [dic.democracy_referendum, dic.democracy_proposal];
  
    if(widget.store.gov==null){
      return Scaffold(
         appBar: myAppBar(context, dic.democracy),
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
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/images/dico/back.png',width: 11,),
                      onPressed: () => Navigator.of(context).pop(),
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
                Expanded(
                  child: _tab == 0
                      ? Democracy(widget.store)
                      : Proposals(widget.store),
                ),
              ],
            ),
          ),
        ),
      // ),
    );
  }
}
