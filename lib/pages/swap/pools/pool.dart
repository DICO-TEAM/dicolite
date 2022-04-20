import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/farm_pool_extend_model.dart';
import 'package:dicolite/model/my_liquidity_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/apr_pool_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/tvl_pool_widget.dart';
import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Pool extends StatefulWidget {
  Pool(this.store);
  static final String route = '/swap/Pool';
  final AppStore store;

  @override
  _Pool createState() => _Pool(store);
}

class _Pool extends State<Pool> with TickerProviderStateMixin {
  _Pool(this.store);

  final AppStore store;

  TabController? controller;

  final _stakeFormKey = GlobalKey<FormState>();
  final _withdrawFormKey = GlobalKey<FormState>();
  final TextEditingController _stakeAmountCtrl = new TextEditingController();
  final TextEditingController _withdrawAmountCtrl = new TextEditingController();
  bool _enableStakeBtn = false;
  bool _enableWithdrawBtn = false;

  int poolId = 0;
  FarmPoolExtendModel? pool;
  TextStyle valStyle =
      TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);
  MyLiquidityModel? myLiquidity;
  bool hasGetMyLiquidity = false;

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

        _getMyLiquidity(id);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stakeAmountCtrl.dispose();
    _withdrawAmountCtrl.dispose();
  }

  Decimal _getAccRewardPerShare(FarmPoolExtendModel pool) {
    int currentBlocks = store.dico?.newHeads?.number ?? 0;
    int blocks = currentBlocks > pool.endBlock
        ? (pool.endBlock - pool.lastRewardBlock)
        : (currentBlocks - pool.lastRewardBlock);
    Decimal old = Decimal.fromBigInt(pool.accRewardPerShare);

    if (blocks > 0 && pool.totalStakeAmount != BigInt.zero) {
      return old +
          (Decimal.fromInt(blocks) *
              Decimal.fromInt(10).pow(12) *
              Decimal.fromBigInt(pool.rewardPerBlock) /
              Decimal.fromBigInt(pool.totalStakeAmount));
    }
    return old;
  }

  BigInt? _getRewardData(int poolId) {
    int i =
        store.dico?.farmPoolExtends?.indexWhere((e) => e.poolId == poolId) ??
            -1;
    pool = i == -1 ? null : store.dico!.farmPoolExtends![i];
    if (pool == null || pool!.myAmount == BigInt.zero) return null;

    BigInt earned = BigInt.zero;
    if (pool!.myAmount != BigInt.zero &&
        (store.dico?.newHeads?.number ?? 0) > pool!.startBlock) {
      earned = BigInt.parse((Decimal.fromBigInt(pool!.myAmount) *
                  _getAccRewardPerShare(pool!) /
                  Decimal.fromInt(10).pow(12))
              .toStringAsFixed(0)) -
          pool!.myRewardDebt;
    }
    return earned;
  }

  Future<void> _getMyLiquidity(int poolId) async {
    int i =
        store.dico?.farmPoolExtends?.indexWhere((e) => e.poolId == poolId) ??
            -1;
    pool = i == -1 ? null : store.dico!.farmPoolExtends![i];
    if (pool == null || !pool!.isStakeLP) return;
    await webApi?.dico?.fetchLiquidityTokenBalance();
    int index = store.dico!.myLiquidityList?.indexWhere(
            (e) => e.liquidity.liquidityId == pool!.stakeCurrencyId) ??
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
        module: 'farmExtend',
        call: 'depositAsset',
        detail: jsonEncode({
          "info": {
            "poolExtendId": poolId,
            "amount": _stakeAmountCtrl.text.trim(),
          }
        }),
        params: [
          poolId,
          Fmt.tokenInt(_stakeAmountCtrl.text.trim(), pool!.stakeDecimals)
              .toString(),
        ],
        onSuccess: (res) {
          globalPoolsRefreshKey.currentState?.show();
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
        module: 'farmExtend',
        call: 'withdrawAsset',
        detail: jsonEncode({
          "info": {
            "poolExtendId": poolId,
            "amount": _withdrawAmountCtrl.text.trim(),
          }
        }),
        params: [
          poolId,
          Fmt.tokenInt(_withdrawAmountCtrl.text.trim(), pool!.stakeDecimals)
              .toString(),
        ],
        onSuccess: (res) {
          globalPoolsRefreshKey.currentState?.show();
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
      module: 'farmExtend',
      call: 'withdrawAsset',
      detail: jsonEncode({
        "info": {
          "poolExtendId": poolId,
          "amount": 0,
        }
      }),
      params: [
        poolId,
        0,
      ],
      onSuccess: (res) {
        globalPoolsRefreshKey.currentState?.show();
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
      poolId = ModalRoute.of(context)!.settings.arguments as int;
      int index =
          store.dico?.farmPoolExtends?.indexWhere((e) => e.poolId == poolId) ??
              -1;
      pool = index == -1 ? null : store.dico!.farmPoolExtends![index];
      int blockTime = store.settings?.blockDuration ?? 0;
      return Scaffold(
        appBar: myAppBar(context, dic.pool),
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
                            Expanded(child: Text(dic.reward)),
                            Row(
                              children: [
                                Text(
                                  pool!.rewardSymbol,
                                  style: valStyle,
                                ),
                                SizedBox(width: 4),
                                Logo(
                                    currencyId: pool!.isRewardLP
                                        ? pool!.rewardLiquidity!.liquidityId
                                        : pool!.rewardCurrencyId),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(dic.stake)),
                            Row(
                              children: [
                                Text(
                                  pool!.stakeSymbol,
                                  style: valStyle,
                                ),
                                SizedBox(width: 4),
                                Logo(
                                    currencyId: pool!.isStakeLP
                                        ? pool!.stakeLiquidity!.liquidityId
                                        : pool!.stakeCurrencyId),
                              ],
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
                            TvlPoolWidget(store, pool!),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(dic.APR)),
                            AprPoolWidget(store, pool!),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(dic.owner)),
                            pool!.owner == store.account!.currentAddress
                                ? Text(
                                    dic.me,
                                    style: valStyle.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  )
                                : Row(
                                    children: [
                                      AddressIcon(pool!.owner),
                                      SizedBox(width: 4),
                                      Text(
                                        Fmt.address(pool!.owner),
                                        style: valStyle,
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _timeWidget(dic, pool!, blockTime),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dic.rewardAmount),
                            Text(
                              Fmt.token(pool!.rewardCurrencyAmount,
                                      pool!.rewardDecimals) +
                                  " " +
                                  pool!.rewardSymbol,
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
                            Text(dic.totalStaked),
                            Text(
                              Fmt.token(pool!.totalStakeAmount,
                                      pool!.stakeDecimals) +
                                  " " +
                                  pool!.stakeSymbol,
                              style: valStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        hasGetMyLiquidity || !pool!.isStakeLP
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(dic.my + " " + dic.staked),
                                  Text(
                                    Fmt.token(pool!.myAmount,
                                            pool!.stakeDecimals) +
                                        " " +
                                        pool!.stakeSymbol +
                                        "(${pool!.totalStakeAmount == BigInt.zero ? 0 : Fmt.decimalFixed(Decimal.fromInt(100) * (Decimal.parse(pool!.myAmount.toString())) / (Decimal.parse(pool!.totalStakeAmount.toString())), 3)}%)",
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
                                BigInt? earn = _getRewardData(poolId);
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        Fmt.token(earn, pool!.rewardDecimals) +
                                            " ${pool!.rewardSymbol}",
                                        style: valStyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    ElevatedButton(
                                        child: Text(dic.harvest),
                                        onPressed:
                                            earn == null || earn == BigInt.zero
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
                              hasGetMyLiquidity || !pool!.isStakeLP
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
                  child: !pool!.isStakeLP
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
                                    Fmt.token(
                                        pool!.stakeToken?.tokenBalance.free,
                                        pool!.stakeDecimals) +
                                    " " +
                                    pool!.stakeSymbol,
                              ),
                              controller: _stakeAmountCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                UI.decimalInputFormatter(pool!.stakeDecimals)
                              ],
                              validator: (v) {
                                if (pool!.stakeToken!.tokenBalance.free <=
                                    BigInt.zero) {
                                  return dic.available + ": 0";
                                }
                                String val = v!.trim();
                                if (val.length == 0 ||
                                    Decimal.parse(val) == Decimal.zero) {
                                  return dic.required;
                                } else if (Fmt.bigIntToDecimal(
                                        pool!.stakeToken!.tokenBalance.free,
                                        pool!.stakeDecimals) <
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
                                if (pool!.stakeToken!.currencyId == "0") {
                                  val = (Fmt.bigIntToDecimal(
                                              pool!.stakeToken!.tokenBalance
                                                  .free,
                                              pool!.stakeToken!.decimals) -
                                          Decimal.parse('0.02'))
                                      .toString();
                                } else {
                                  val = Fmt.bigIntToDecimalString(
                                      pool!.stakeToken!.tokenBalance.free,
                                      pool!.stakeDecimals);
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
                                              pool!.stakeDecimals) +
                                          " " +
                                          pool!.stakeSymbol)
                                      : "",
                                ),
                                controller: _stakeAmountCtrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  UI.decimalInputFormatter(pool!.stakeDecimals)
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
                                          pool!.stakeDecimals) <
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
                                if (pool!.isStakeLP && myLiquidity == null)
                                  return;
                                String val = "";

                                val = Fmt.bigIntToDecimalString(
                                    myLiquidity!.balance.free,
                                    pool!.stakeDecimals);

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
                                Fmt.token(pool!.myAmount, pool!.stakeDecimals) +
                                " " +
                                pool!.stakeSymbol,
                          ),
                          controller: _withdrawAmountCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            UI.decimalInputFormatter(pool!.stakeDecimals)
                          ],
                          validator: (v) {
                            String val = v!.trim();
                            if (val.length == 0 ||
                                Decimal.parse(val) == Decimal.zero) {
                              return dic.required;
                            } else if (pool!.myAmount <
                                Fmt.tokenInt(val, pool!.stakeDecimals)) {
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

                          val = Fmt.numFixed(
                              Fmt.bigIntToDouble(
                                  pool!.myAmount, pool!.stakeDecimals),
                              20);

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
