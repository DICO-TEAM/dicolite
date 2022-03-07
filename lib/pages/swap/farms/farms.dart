import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/farm_pool_model.dart';
import 'package:dicolite/pages/swap/farms/farm.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/widgets/apr_widget.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:dicolite/widgets/tvl_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Farms extends StatefulWidget {
  Farms(this.store);
  final AppStore store;

  @override
  _Farms createState() => _Farms(store);
}

class _Farms extends State<Farms> {
  _Farms(this.store);

  final AppStore store;
  TextStyle valStyle =
      TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

  /// 0 :live  1:finished
  int _finshed = 0;

  bool _onlyStaked = false;

  Future<void> _onRefresh() async {
    await webApi?.dico?.subFarmPoolsChange();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Observer(builder: (_) {
      List<FarmPoolModel>? list;
      if (store.dico?.farmPools != null) {
        list = store.dico!.farmPools!.toList();
        if (_onlyStaked) {
          list = list.where((e) => e.isStaked).toList();
        }
        list = list.where((e) => e.isFinished == (_finshed == 1)).toList();
      }

      return RefreshIndicator(
          key: globalFarmsRefreshKey,
          onRefresh: _onRefresh,
          child: RoundedCard(
            margin: EdgeInsets.fromLTRB(15, 30, 15, 15),
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.only(top: 4.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CupertinoSwitch(
                              activeColor: Theme.of(context).primaryColor,
                              value: _onlyStaked,
                              onChanged: (v) {
                                setState(() {
                                  _onlyStaked = v;
                                });
                              }),
                          Text(dic.stakedOnly,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      CupertinoSlidingSegmentedControl(
                          children: {
                            0: Text(dic.live,
                                style: Theme.of(context).textTheme.bodyText1),
                            1: Text(dic.finished,
                                style: Theme.of(context).textTheme.bodyText1),
                          },
                          groupValue: _finshed,
                          onValueChanged: (v) {
                            setState(() {
                              _finshed = v as int;
                            });
                          }),
                    ],
                  ),
                ),
                Expanded(
                  child: list == null
                      ? ListView(
                          children: [
                            RoundedCard(
                              radius: 15,
                              margin: EdgeInsets.fromLTRB(15, 15, 15, 8),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: LoadingWidget(),
                              ),
                            ),
                          ],
                        )
                      : list.isEmpty
                          ? ListView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 110),
                                  child: NoData(),
                                ),
                              ],
                            )
                          : ListView(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              children: list
                                  .map((e) => GestureDetector(
                                        key: Key(e.currencyId),
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(Farm.route,
                                                arguments: e.poolId),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            margin: EdgeInsets.fromLTRB(
                                                15, 15, 15, 0),
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Logo(symbol: e.symbol),
                                                    Text(
                                                      e.symbol,
                                                      style: valStyle,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Text("TVL")),
                                                    TvlWidget(store, e),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Text(dic.APR)),
                                                    AprWidget(store, e),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(dic.multiplier),
                                                        Tooltip(
                                                          message:
                                                              dic.multiplierTip,
                                                          child: Icon(
                                                            Icons.info,
                                                            color:
                                                                Colors.black12,
                                                            size: 24,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      e.multiplier,
                                                      style: valStyle,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ))
                                  .toList(),
                            ),
                )
              ],
            ),
          ));
    });
  }
}
