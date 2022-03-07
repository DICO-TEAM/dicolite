import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/treasury/spendProposals.dart';
import 'package:dicolite/pages/me/treasury/tips.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/top_taps.dart';

class TreasuryPage extends StatefulWidget {
  TreasuryPage(this.store);

  static const String route = '/gov/treasury/index';

  final AppStore store;

  @override
  _TreasuryPageState createState() => _TreasuryPageState();
}

class _TreasuryPageState extends State<TreasuryPage> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      webApi!.gov!.fetchCouncilInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    var tabs = [dic.treasury, dic.treasury_tip];
    if(widget.store.gov==null){
      return Scaffold(
        appBar: myAppBar(context, dic.treasury),
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
                Observer(
                  builder: (_) {
                    return Expanded(
                      child: widget.store.gov!.council.members == null
                          ? CupertinoActivityIndicator()
                          : _tab == 0
                              ? SpendProposals(widget.store)
                              : MoneyTips(widget.store),
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
