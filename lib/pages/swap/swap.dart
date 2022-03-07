import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/pages/swap/exchange.dart';
import 'package:dicolite/pages/swap/farms/farms.dart';
import 'package:dicolite/pages/swap/liquidity/liquidity.dart';
import 'package:dicolite/pages/swap/pools/pools.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/top_taps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Swap extends StatefulWidget {
  Swap(this.store);
  final AppStore store;
  @override
  _SwapState createState() => _SwapState(store);
}

class _SwapState extends State<Swap> with AutomaticKeepAliveClientMixin {
  _SwapState(this.store);
  AppStore store;

  int _tab = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    S dic = S.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dico/bg-swap.jpg'),
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              TopTabs(
                names: [dic.swap, dic.liquidity, dic.farms, dic.pools],
                activeTab: _tab,
                activeColor: Colors.white,
                unselectColor: Colors.white70,
                onTab: (v) {
                  setState(() {
                    if (_tab != v) {
                      _tab = v;
                    }
                  });
                },
              ),
              Observer(
                builder: (_) {
                  if (store.account!.currentAccountPubKey.isEmpty) {
                    return Scaffold(
                      body: Center(
                        child: LoadingWidget(),
                      ),
                    );
                  }
                  return Expanded(
                    child: widget.store.settings?.networkState.endpoint == null
                        ? LoadingWidget()
                        : _tab == 0
                            ? Exchange(widget.store)
                            : _tab == 1
                                ? Liquidity(widget.store)
                                : _tab == 2
                                    ? Farms(widget.store)
                                    : Pools(widget.store),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
