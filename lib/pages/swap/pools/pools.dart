import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/farm_pool_extend_model.dart';
import 'package:dicolite/pages/swap/pools/add_pool.dart';
import 'package:dicolite/pages/swap/pools/pool.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/apr_pool_widget.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:dicolite/widgets/tvl_pool_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Pools extends StatefulWidget {
  Pools(this.store);
  final AppStore store;

  @override
  _Pools createState() => _Pools(store);
}

class _Pools extends State<Pools> {
  _Pools(this.store);

  final AppStore store;
  TextStyle valStyle =
      TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

  bool _onlyStaked = false;

  Future<void> _onRefresh() async {
    await webApi?.dico?.subFarmPoolExtendsChange();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Observer(builder: (_) {
      List<FarmPoolExtendModel>? list;
      int blockTime = store.settings?.blockDuration ?? 0;
      int now = store.dico?.newHeads?.number ?? 0;
      if (store.dico?.farmPoolExtends != null &&
          store.dico?.newHeads?.number != null) {
        list = store.dico!.farmPoolExtends!.toList();
        if (_onlyStaked) {
          list = list.where((e) => e.isStaked).toList();
        } else {
          /// show before start time 1 day list
          list = list
              .where((e) =>
                  (e.endBlock >= now) &&
                  e.startBlock - now < (24 * 3600 ~/ (blockTime ~/ 1000)))
              .toList();
        }
      }
      return RefreshIndicator(
          key: globalPoolsRefreshKey,
          onRefresh: _onRefresh,
          child: RoundedCard(
            margin: EdgeInsets.fromLTRB(15, 30, 15, 15),
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15),
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
                      store.dico?.newHeads != null
                          ? TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(AddPool.route),
                              child: Text(dic.addPool))
                          : Container(),
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
                                  padding: EdgeInsets.only(top: 105),
                                  child: NoData(),
                                ),
                              ],
                            )
                          : ListView(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              children: list
                                  .map((e) => GestureDetector(
                                        key: Key(e.poolId.toString()),
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(Pool.route,
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
                                                    Expanded(
                                                        child:
                                                            Text(dic.reward)),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          e.rewardSymbol,
                                                          style: valStyle,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Logo(
                                                            symbol:
                                                                e.rewardSymbol),
                                                      ],
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
                                                        child: Text(dic.stake)),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          e.stakeSymbol,
                                                          style: valStyle,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Logo(
                                                            symbol:
                                                                e.stakeSymbol),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                _timeWidget(dic, e, blockTime),
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
                                                    TvlPoolWidget(store, e),
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
                                                    AprPoolWidget(store, e),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
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

  _timeWidget(S dic, FarmPoolExtendModel e, int blockTime) {
    int now = store.dico?.newHeads?.number ?? 0;
    if (e.endBlock < now) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dic.status,
          ),
          Text(
            dic.finished,
            style: boldStyle.copyWith(color: Colors.amber),
          )
        ],
      );
    }
    if (e.startBlock > now) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dic.startIn,
          ),
          Text(
            Fmt.blockToTime(e.startBlock - now, blockTime),
            style: boldStyle.copyWith(color: Colors.amber),
          )
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dic.timeLeft,
        ),
        Text(
          Fmt.blockToTime(e.endBlock - now, blockTime),
          style: boldStyle.copyWith(color: Colors.black),
        )
      ],
    );
  }
}
