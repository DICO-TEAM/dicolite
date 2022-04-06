import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/liquidity_model.dart';
import 'package:dicolite/model/my_liquidity_model.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LiquidityList extends StatefulWidget {
  LiquidityList(this.store, this.isShowMyLiquidity, this.addLiquidity,
      this.removeLiquidity);
  final AppStore store;
  final bool isShowMyLiquidity;
  final Function(String currencyId1, String currencyId2) addLiquidity;
  final Function(MyLiquidityModel data) removeLiquidity;

  @override
  _LiquidityListState createState() => _LiquidityListState(store);
}

class _LiquidityListState extends State<LiquidityList> {
  _LiquidityListState(this.store);
  AppStore store;

  Widget allList() {
    S dic = S.of(context);
    List<LiquidityModel>? list = store.dico!.liquidityList;
    if (list != null && list.isNotEmpty) {
      list = list
          .where((e) =>
              e.token1Amount != BigInt.zero &&
              e.token2Amount != BigInt.zero &&
              e.totalIssuance != BigInt.zero)
          .toList();
    }
    return list == null
        ? ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: LoadingWidget(),
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
                children: list
                    .map((e) => Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Logo(
                                    symbol: e.symbol,
                                  ),
                                  Text(e.symbol),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          e.showDetail = !e.showDetail;
                                        });
                                      },
                                      child: Text(dic.detail)),
                                ],
                              ),
                              e.showDetail
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(e.symbol1),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    Fmt.token(e.token1Amount,
                                                        e.decimals1),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Logo(
                                                    symbol: e.symbol1,
                                                    size: 25,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(e.symbol2),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    Fmt.token(e.token2Amount,
                                                        e.decimals2),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Logo(
                                                    symbol: e.symbol2,
                                                    size: 25,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        RoundedButton(
                                            round: false,
                                            text:
                                                "${dic.addLiquidity} ${e.symbol}",
                                            onPressed: () {
                                              widget.addLiquidity(
                                                  e.currencyId1, e.currencyId2);
                                            })
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ))
                    .toList(),
              );
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    return Observer(builder: (_) {
      if (!widget.isShowMyLiquidity) return allList();

      return store.dico!.myLiquidityList == null
          ? Padding(
              padding: const EdgeInsets.all(30.0),
              child: LoadingWidget(),
            )
          : store.dico!.myLiquidityList!.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: NoData(),
                )
              : ListView(
                  children: store.dico!.myLiquidityList!
                      .map((e) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Logo(
                                      symbol: e.liquidity.symbol,
                                    ),
                                    Text(e.liquidity.symbol),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          e.showDetail = !e.showDetail;
                                        });
                                      },
                                      child: Text(dic.manage),
                                    ),
                                  ],
                                ),
                                e.showDetail
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(dic.yourTotalPoolTokens),
                                              Expanded(
                                                child: Text(
                                                  Fmt.token(e.balance.free,
                                                      Config.liquidityDecimals),
                                                  textAlign: TextAlign.right,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(e.liquidity.symbol1),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      Fmt.token(
                                                          e.myToken1Amount,
                                                          e.liquidity
                                                              .decimals1),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Logo(
                                                      symbol:
                                                          e.liquidity.symbol1,
                                                      size: 25,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(e.liquidity.symbol2),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      Fmt.token(
                                                          e.myToken2Amount,
                                                          e.liquidity
                                                              .decimals2),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Logo(
                                                      symbol:
                                                          e.liquidity.symbol2,
                                                      size: 25,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(dic.shareOfRate),
                                              Text(e.shareRate + " %"),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  child: Text(dic.add),
                                                  onPressed: () =>
                                                      widget.addLiquidity(
                                                          e.liquidity
                                                              .currencyId1,
                                                          e.liquidity
                                                              .currencyId2),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  child: Text(dic.remove),
                                                  onPressed: () =>
                                                      widget.removeLiquidity(e),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ))
                      .toList(),
                );
    });
  }
}
