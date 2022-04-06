import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/farm_pool_model.dart';
import 'package:dicolite/model/farm_rule_data_model.dart';
import 'package:dicolite/model/my_liquidity_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/setting/set_node/set_node.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/apr_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/tvl_widget.dart';

import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Farm extends StatefulWidget {
  Farm(this.store);
  static final String route = '/swap/Farm';
  final AppStore store;

  @override
  _Farm createState() => _Farm(store);
}

class _Farm extends State<Farm> with TickerProviderStateMixin {
  _Farm(this.store);

  final AppStore store;

  TabController? controller;

  final _stakeFormKey = GlobalKey<FormState>();
  final _withdrawFormKey = GlobalKey<FormState>();
  final TextEditingController _stakeAmountCtrl = new TextEditingController();
  final TextEditingController _withdrawAmountCtrl = new TextEditingController();
  bool _enableStakeBtn = false;
  bool _enableWithdrawBtn = false;

  int poolId = 0;
  FarmPoolModel? pool;
  TextStyle valStyle =
      TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);
  MyLiquidityModel? myLiquidity;
  bool hasGetMyLiquidity = false;
  Timer? _timer;

  Decimal? lpSupply;
  bool isRequesting = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      int? id = ModalRoute.of(context)!.settings.arguments as int?;
      if (id != null && mounted) {
        setState(() {
          poolId = id;
        });
        int blockTime = widget.store.settings?.blockDuration ?? 12;
        _getSuplyFreeBalance();

        _timer = Timer.periodic(Duration(milliseconds: blockTime), (timer) {
          _getSuplyFreeBalance();
        });

        _getMyLiquidity(id);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stakeAmountCtrl.dispose();
    _withdrawAmountCtrl.dispose();
    _timer?.cancel();
  }

  _getSuplyFreeBalance() async {
    if (isRequesting) return;
    isRequesting = true;

    BigInt? res = await webApi?.dico?.fetchFarmSupplyBalance(
        pool!.currencyId,
        default_ss58_map[
                store.settings!.networkState.tokenSymbol.toLowerCase()] ??
            42);
    isRequesting = false;
    if (mounted && res != null) {
      setState(() {
        lpSupply = Decimal.fromBigInt(res);
      });
    }
  }

  /// Calculate the number of halvings
  int phase(int blockNumber, int halvingPeriod, int startBlock) {
    if (halvingPeriod == 0) return 0;

    if (blockNumber > startBlock) {
      return (blockNumber - startBlock - 1) ~/ halvingPeriod;
    }

    return 0;
  }

  /// Calculate the current number of rewards for each block, dicoPerBlock is stored in the storage, indicating the number of rewards for each block at the initial stage
  Decimal getBlockReward(
      int blockNumber, BigInt dicoPerBlock, int halvingPeriod, int startBlock) {
    int _phase = phase(blockNumber, halvingPeriod, startBlock);
    Decimal blockReward =
        Decimal.fromBigInt(dicoPerBlock) ~/ (Decimal.fromInt(2).pow(_phase));
    return blockReward;
  }

  /// # Calculate the revenue from the block that received the reward last time to the current block
  Decimal getBlockRewards(
      int blockNumber, int lastRewardBlock, FarmRuleDataModel farmRule) {
    if (blockNumber <= lastRewardBlock) return Decimal.zero;
    BigInt dicoPerBlock = farmRule.dicoPerBlock;
    int halvingPeriod = farmRule.halvingPeriod;
    int startBlock = farmRule.startBlock;

    int n = phase(lastRewardBlock, halvingPeriod, startBlock);
    int m = phase(blockNumber, halvingPeriod, startBlock);

    Decimal blockRewards = Decimal.zero;

    while (n < m) {
      n += 1;
      int r = n * halvingPeriod + startBlock;
      Decimal rReward =
          getBlockReward(r, dicoPerBlock, halvingPeriod, startBlock);
      Decimal rBlockReward = Decimal.fromInt(r - lastRewardBlock) * rReward;

      blockRewards += rBlockReward;
      lastRewardBlock = r;
    }

    Decimal yBlockReward = Decimal.fromInt(blockNumber - lastRewardBlock) *
        getBlockReward(blockNumber, dicoPerBlock, halvingPeriod, startBlock);
    blockRewards += yBlockReward;
    return blockRewards;
  }

  Decimal _getAccRewardPerShare(FarmPoolModel pool) {
    int blocks = (store.dico?.newHeads?.number ?? 0) - pool.lastRewardBlock;
    Decimal old = Decimal.fromBigInt(pool.accDicoPerShare);

    if (lpSupply != Decimal.zero &&
        blocks > 0 &&
        pool.totalAmount != BigInt.zero &&
        !pool.isFinished &&
        store.dico!.totalFarmAllocPoint != null &&
        store.dico!.totalFarmAllocPoint != 0 &&
        store.dico!.farmRuleData != null) {
      Decimal blockRewards = getBlockRewards(
          (store.dico?.newHeads?.number ?? 0),
          pool.lastRewardBlock,
          store.dico!.farmRuleData!);
      Decimal poolRewards = blockRewards *
          Decimal.fromInt(pool.allocPoint) ~/
          Decimal.fromInt(store.dico!.totalFarmAllocPoint!);

      return old + (poolRewards * Decimal.fromInt(10).pow(12) ~/ lpSupply!);
    }
    return old;
  }

  /// new
  BigInt? _getRewardData(int poolId) {
    int i = store.dico?.farmPools?.indexWhere((e) => e.poolId == poolId) ?? -1;
    pool = i == -1 ? null : store.dico!.farmPools![i];
    if (pool == null || pool!.myAmount == BigInt.zero || lpSupply == null)
      return null;
    BigInt earned = BigInt.zero;
    if (pool!.myAmount != BigInt.zero) {
      earned = BigInt.parse((Decimal.fromBigInt(pool!.myAmount) *
                  _getAccRewardPerShare(pool!) ~/
                  Decimal.fromInt(10).pow(12))
              .toStringAsFixed(0)) -
          pool!.myRewardDebt;
    }

    return earned;
  }

  Future<void> _getMyLiquidity(int poolId) async {
    int i = store.dico?.farmPools?.indexWhere((e) => e.poolId == poolId) ?? -1;
    pool = i == -1 ? null : store.dico!.farmPools![i];
    if (pool == null || !pool!.isLP) return;
    await webApi?.dico?.fetchLiquidityTokenBalance();
    int index = store.dico!.myLiquidityList
            ?.indexWhere((e) => e.liquidity.liquidityId == pool!.currencyId) ??
        -1;
    if (!mounted) return;
    if (store.dico!.myLiquidityList != null && index != -1) {
      setState(() {
        myLiquidity = store.dico!.myLiquidityList![index];
      });
    }
    setState(() {
      hasGetMyLiquidity = true;
    });
  }

  Future _stake() async {
    if (_stakeFormKey.currentState!.validate()) {
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).stake,
        module: 'farm',
        call: 'depositLp',
        detail: jsonEncode({
          "info": {
            "poolId": poolId,
            "amount": _stakeAmountCtrl.text.trim(),
          }
        }),
        params: [
          poolId,
          Fmt.tokenInt(_stakeAmountCtrl.text.trim(), pool!.poolDeciaml)
              .toString(),
        ],
        onSuccess: (res) {
          globalFarmsRefreshKey.currentState?.show();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  Future _withdraw() async {
    if (_withdrawFormKey.currentState!.validate()) {
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).withdraw,
        module: 'farm',
        call: 'withdrawLp',
        detail: jsonEncode({
          "info": {
            "poolId": poolId,
            "amount": _withdrawAmountCtrl.text.trim(),
          }
        }),
        params: [
          poolId,
          Fmt.tokenInt(_withdrawAmountCtrl.text.trim(), pool!.poolDeciaml)
              .toString(),
        ],
        onSuccess: (res) {
          globalFarmsRefreshKey.currentState?.show();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  Future _harvest() async {
    TxConfirmParams args = TxConfirmParams(
      title: S.of(context).harvest,
      module: 'farm',
      call: 'withdrawLp',
      detail: jsonEncode({
        "info": {
          "poolId": poolId,
          "amount": 0,
        }
      }),
      params: [
        poolId,
        0,
      ],
      onSuccess: (res) {
        globalFarmsRefreshKey.currentState?.show();
      },
    );

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(Home.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Observer(builder: (_) {
      int decimals = store.settings!.networkState.tokenDecimals;
      String symbol = store.settings!.networkState.tokenSymbol;
      poolId = ModalRoute.of(context)!.settings.arguments as int;
      int index =
          store.dico?.farmPools?.indexWhere((e) => e.poolId == poolId) ?? -1;
      pool = index == -1 ? null : store.dico!.farmPools![index];

      return Scaffold(
        appBar: myAppBar(context, dic.farm),
        backgroundColor: Colors.white,
        body: pool == null
            ? Container()
            : ListView(
                children: [
                  Container(color: Colors.white, child: Divider()),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Logo(currencyId: pool!.isLP?pool!.liquidity!.liquidityId:pool!.currencyId),
                            Text(
                              pool!.symbol,
                              style: valStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text("TVL")),
                            TvlWidget(store, pool!),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(dic.APR)),
                            AprWidget(store, pool!),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(dic.multiplier),
                                Tooltip(
                                  message: dic.multiplierTip,
                                  child: Icon(
                                    Icons.info,
                                    color: Colors.black12,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              pool!.multiplier,
                              style: valStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        hasGetMyLiquidity || !pool!.isLP
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(dic.staked),
                                  Text(
                                    Fmt.token(
                                            pool!.myAmount, pool!.poolDeciaml) +
                                        " " +
                                        pool!.symbol,
                                    style: valStyle,
                                  ),
                                ],
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(dic.earned),
                                ],
                              ),
                              Builder(builder: (context) {
                                BigInt? earned = _getRewardData(poolId);
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        Fmt.token(earned, decimals) +
                                            " $symbol",
                                        style: valStyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    ElevatedButton(
                                        child: Text(dic.harvest),
                                        onPressed: earned == null ||
                                                earned == BigInt.zero
                                            ? null
                                            : _harvest)
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(8, 15, 8, 15),
                          child: Row(
                            children: [
                              TabBar(
                                controller: controller,
                                unselectedLabelColor: Colors.grey,
                                labelColor: Theme.of(context).primaryColor,
                                labelStyle: TextStyle(
                                    fontSize: Adapt.px(26),
                                    fontWeight: FontWeight.w500),
                                isScrollable: true,
                                tabs: [
                                  Tab(
                                    text: dic.stake,
                                  ),
                                  Tab(
                                    text: dic.withdraw,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 400,
                          child: TabBarView(
                            controller: controller,
                            children: [
                              hasGetMyLiquidity || !pool!.isLP
                                  ? stakeWidget()
                                  : Container(),
                              pool!.myAmount != BigInt.zero
                                  ? withdrawWidget()
                                  : Container(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      );
    });
  }

  Widget stakeWidget() {
    S dic = S.of(context);

    return Column(
      children: [
        Form(
          key: _stakeFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () => setState(
              () => _enableStakeBtn = _stakeFormKey.currentState!.validate()),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: !pool!.isLP
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: "0.0",
                                helperText: "${dic.available}: " +
                                    Fmt.token(pool!.token?.tokenBalance.free,
                                        pool!.poolDeciaml) +
                                    " " +
                                    pool!.symbol,
                              ),
                              controller: _stakeAmountCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                UI.decimalInputFormatter(pool!.poolDeciaml)
                              ],
                              validator: (v) {
                                if (pool!.token!.tokenBalance.free <=
                                    BigInt.zero) {
                                  return dic.available + ": 0";
                                }
                                String val = v!.trim();
                                if (val.length == 0 ||
                                    Decimal.parse(val) == Decimal.zero) {
                                  return dic.required;
                                } else if (Fmt.bigIntToDecimal(
                                        pool!.token!.tokenBalance.free,
                                        pool!.poolDeciaml) <
                                    Decimal.parse(val)) {
                                  return dic.amount_low;
                                }
                                return null;
                              },
                            )),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(dic.amount_max,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                              onTap: () {
                                String val = "";
                                if (pool!.token!.currencyId == "0") {
                                  val = (Fmt.bigIntToDecimal(
                                              pool!.token!.tokenBalance.free,
                                              pool!.token!.decimals) -
                                          Decimal.parse('0.02'))
                                      .toString();
                                } else {
                                  val = Fmt.bigIntToDecimalString(
                                      pool!.token!.tokenBalance.free,
                                      pool!.poolDeciaml);
                                }
                                setState(() {
                                  _stakeAmountCtrl.text = val;
                                });
                              },
                            ),
                          ],
                        )
                      :
                      //////////////////////////// LP token
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  hintText: "0.0",
                                  helperText: myLiquidity != null
                                      ? ("${dic.available}: " +
                                          Fmt.token(myLiquidity!.balance.free,
                                              pool!.poolDeciaml) +
                                          " " +
                                          pool!.symbol)
                                      : "",
                                ),
                                controller: _stakeAmountCtrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  UI.decimalInputFormatter(pool!.poolDeciaml)
                                ],
                                validator: (v) {
                                  if (myLiquidity == null ||
                                      myLiquidity!.balance.free <=
                                          BigInt.zero) {
                                    return dic.available + ": 0";
                                  }
                                  String val = v!.trim();
                                  if (val.length == 0 ||
                                      Decimal.parse(val) == Decimal.zero) {
                                    return dic.required;
                                  } else if (Fmt.bigIntToDecimal(
                                          myLiquidity!.balance.free,
                                          pool!.poolDeciaml) <
                                      Decimal.parse(val)) {
                                    return dic.amount_low;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(dic.amount_max,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                              onTap: () {
                                if (pool!.isLP && myLiquidity == null) return;
                                String val = "";

                                val = Fmt.bigIntToDecimalString(
                                    myLiquidity!.balance.free,
                                    pool!.poolDeciaml);

                                setState(() {
                                  _stakeAmountCtrl.text = val;
                                });
                              },
                            ),
                          ],
                        ),
                ),
              ),
              RoundedButton(
                text: dic.stake,
                onPressed: _enableStakeBtn ? _stake : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget withdrawWidget() {
    S dic = S.of(context);
    return Column(
      children: [
        Form(
          key: _withdrawFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () => setState(() =>
              _enableWithdrawBtn = _withdrawFormKey.currentState!.validate()),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: true,
                            hintText: "0.0",
                            helperText: "${dic.available}: " +
                                Fmt.token(pool!.myAmount, pool!.poolDeciaml) +
                                " " +
                                pool!.symbol,
                          ),
                          controller: _withdrawAmountCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            UI.decimalInputFormatter(pool!.poolDeciaml)
                          ],
                          validator: (v) {
                            String val = v!.trim();
                            if (val.length == 0 ||
                                Decimal.parse(val) == Decimal.zero) {
                              return dic.required;
                            } else if (Fmt.bigIntToDecimal(
                                    pool!.myAmount, pool!.poolDeciaml) <
                                Decimal.parse(val)) {
                              return dic.amount_low;
                            }
                            return null;
                          },
                        ),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(dic.amount_max,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        ),
                        onTap: () {
                          if (pool?.myAmount == null) return;
                          String val = "";

                          val = Fmt.bigIntToDecimalString(
                              pool!.myAmount, pool!.poolDeciaml);

                          setState(() {
                            _withdrawAmountCtrl.text = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              RoundedButton(
                text: dic.withdraw,
                onPressed: _enableWithdrawBtn ? _withdraw : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
