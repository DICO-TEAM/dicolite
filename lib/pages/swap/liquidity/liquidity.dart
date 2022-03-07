import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/my_liquidity_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/pages/swap/liquidity/liquidity_list.dart';
import 'package:dicolite/pages/swap/select_token.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/pairs.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Liquidity extends StatefulWidget {
  const Liquidity(this.store, {Key? key}) : super(key: key);

  final AppStore store;
  @override
  _LiquidityState createState() => _LiquidityState(store);
}

class _LiquidityState extends State<Liquidity> {
  _LiquidityState(this.store);
  AppStore store;

  final _formKey = GlobalKey<FormState>();
  final _removeLiquidityformKey = GlobalKey<FormState>();
  bool _enableBtn = false;
  bool _removeLiquidityEnableBtn = false;
  bool _isShowAddLiquidity = false;
  bool _isShowRemoveLiquidity = false;

  MyLiquidityModel? removeLiquidityData;
  CurrencyModel? token1;
  CurrencyModel? token2;

  final TextEditingController token1Ctrl = new TextEditingController();
  final TextEditingController token2Ctrl = new TextEditingController();
  final TextEditingController removeLiquidityCtrl = new TextEditingController();

  Pairs? pairs;
  bool _isShowMyLiquidity = false;

  @override
  void initState() {
    super.initState();
    _getMyLiquidity();
  }

  void _showResult(dynamic res) {
    if (mounted) {
      S dic = S.of(context);
      CurrencyModel t1 = store.dico!.tokensSort
          .firstWhere((e) => e.currencyId == res[2].toString());
      CurrencyModel t2 = store.dico!.tokensSort
          .firstWhere((e) => e.currencyId == res[3].toString());
      String result =
          "${dic.addLiquidity}: ${Fmt.token(BigInt.parse(res[4].toString()), t1.decimals)} ${t1.symbol}/${Fmt.token(BigInt.parse(res[5].toString()), t2.decimals)} ${t2.symbol}";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
        content: Text(result),
        action: SnackBarAction(label: dic.close, onPressed: () {}),
      ));
    }
  }

  Future<void> _onRefresh() async {
    await webApi?.dico?.subLiquidityListChange();
    _getMyLiquidity();
  }

  Future<void> _getMyLiquidity() async {
    setState(() {
      _isShowAddLiquidity = false;
      _isShowRemoveLiquidity = false;
    });
    Future.delayed(Duration(seconds: 3));
    await webApi?.dico?.fetchLiquidityTokenBalance();
  }

  Future<void> _addLiquidity(String currencyId1, String currencyId2) async {
    int index1 =
        store.dico!.tokensSort.indexWhere((e) => e.currencyId == currencyId1);
    int index2 =
        store.dico!.tokensSort.indexWhere((e) => e.currencyId == currencyId2);
    setState(() {
      _isShowAddLiquidity = true;
      token1Ctrl.text = '';
      token2Ctrl.text = '';
      token1 = index1 != -1 ? store.dico!.tokensSort[index1] : null;
      token2 = index2 != -1 ? store.dico!.tokensSort[index2] : null;
    });
  }

  Future<void> _removeLiquidity(MyLiquidityModel data) async {
    setState(() {
      _isShowRemoveLiquidity = true;
      removeLiquidityCtrl.text = '';
      removeLiquidityData = data;
    });
  }

  onToken2Change() {
    if (token2 != null && token1 != null) {
      String? val = pairs!.calToken1Amount(token2Ctrl.text);
      if (val != null) {
        setState(() {
          token1Ctrl.text = val;
        });
      }
    }
  }

  onToken1Change() {
    if (token1 != null && token2 != null) {
      String? val = pairs!.calToken2Amount(token1Ctrl.text);
      if (val != null) {
        setState(() {
          token2Ctrl.text = val;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    token1Ctrl.dispose();
    token2Ctrl.dispose();
    removeLiquidityCtrl.dispose();
  }

  /// Add liquidity submit
  Future _addLiquiditySubmit() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).addLiquidity,
        module: 'amm',
        call: 'addLiquidity',
        detail: jsonEncode({
          "assetA": token1!.currencyId,
          "assetB": token2!.currencyId,
          "amountADesired": token1Ctrl.text.trim(),
          "amountBDesired": token2Ctrl.text.trim(),
          "amountAMin": 0,
          "amountBMin": 0,
        }),
        params: [
          token1!.currencyId,
          token2!.currencyId,
          Fmt.tokenInt(token1Ctrl.text.trim(), token1!.decimals).toString(),
          Fmt.tokenInt(token2Ctrl.text.trim(), token2!.decimals).toString(),
          0,
          0,
        ],
        onSuccess: (res) {
          _showResult(res["successRes"]);
          globalLiquidityRefreshKey.currentState?.show();
        },
      );

      Map? res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args) as Map?;
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  /// Remove liquidity submit
  /// Calculate the amount of trading pairs of assets that can be obtained when remove liquidity.
  /// Calculation formula:
  /// - remove_liquidity / total_liquidity = remove_a / reserve_a
  /// - remove_liquidity / total_liquidity = remove_b / reserve_b
  Future _removeLiquiditySubmit() async {
    if (removeLiquidityData != null &&
        _removeLiquidityformKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).removeLiquidity,
        module: 'amm',
        call: 'removeLiquidity',
        detail: jsonEncode({
          "assetA": removeLiquidityData!.liquidity.currencyId1,
          "assetB": removeLiquidityData!.liquidity.currencyId2,
          "removeLiquidity": removeLiquidityCtrl.text.trim(),
          "amountAMin": 0,
          "amountBMin": 0,
        }),
        params: [
          removeLiquidityData!.liquidity.currencyId1,
          removeLiquidityData!.liquidity.currencyId2,
          Fmt.tokenInt(
                  removeLiquidityCtrl.text.trim(), Config.liquidityDecimals)
              .toString(),
          0,
          0,
        ],
        onSuccess: (res) async {
          await webApi?.dico?.subLiquidityListChange();
          globalLiquidityRefreshKey.currentState?.show();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  _token1Select() async {
    CurrencyModel? res = await Navigator.of(context)
        .pushNamed(SelectToken.route) as CurrencyModel?;
    if (res != null && mounted) {
      if (token2 != null && token2!.currencyId == res.currencyId) {
        setState(() {
          token2 = token1;
          token1 = res;
        });
      } else {
        setState(() {
          token1 = res;
        });
      }
      if (token1 != null && token2 != null) {
        pairs = Pairs(
          liquidityList: store.dico!.liquidityList!.toList(),
          tokenA: token1!,
          tokenB: token2!,
        );
      }
      onToken1Change();
    }
  }

  _token2Select() async {
    CurrencyModel? res = await Navigator.of(context)
        .pushNamed(SelectToken.route) as CurrencyModel?;
    if (res != null && mounted) {
      if (token1 != null && token1!.currencyId == res.currencyId) {
        setState(() {
          token1 = token2;
          token2 = res;
        });
      } else {
        setState(() {
          token2 = res;
        });
      }
      if (token1 != null && token2 != null) {
        pairs = Pairs(
          liquidityList: store.dico!.liquidityList!.toList(),
          tokenA: token1!,
          tokenB: token2!,
        );
      }
      onToken2Change();
    }
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    return RefreshIndicator(
      key: globalLiquidityRefreshKey,
      onRefresh: _onRefresh,
      child: RoundedCard(
          radius: 15,
          margin: EdgeInsets.fromLTRB(15, 30, 15, 15),
          padding: EdgeInsets.only(bottom: 15),
          child: _isShowRemoveLiquidity
              ? removeLiquidityWidget()
              : _isShowAddLiquidity
                  ? addLiquidityWidget()
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CupertinoSwitch(
                                      value: _isShowMyLiquidity,
                                      onChanged: (v) {
                                        setState(() {
                                          _isShowMyLiquidity = v;
                                        });
                                      }),
                                  Text(dic.my,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                ],
                              ),
                              store.dico?.liquidityList != null
                                  ? TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isShowAddLiquidity = true;
                                          _isShowRemoveLiquidity = false;
                                          token1Ctrl.text = '';
                                          token2Ctrl.text = '';
                                          token1 = null;
                                          token2 = null;
                                        });
                                      },
                                      child: Text(dic.addLiquidity),
                                    )
                                  : SizedBox(
                                      height: 7,
                                    ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: LiquidityList(store, _isShowMyLiquidity,
                              _addLiquidity, _removeLiquidity),
                        )
                      ],
                    )),
    );
  }

  Widget addLiquidityWidget() {
    S dic = S.of(context);
    if (token1 != null && token2 != null) {
      pairs = Pairs(
        liquidityList: store.dico!.liquidityList!.toList(),
        tokenA: token1!,
        tokenB: token2!,
      );
    }

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () =>
          setState(() => _enableBtn = _formKey.currentState!.validate()),
      child: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isShowAddLiquidity = false;
                  });
                },
                icon: Image.asset(
                  'assets/images/dico/back.png',
                  width: 11,
                ),
              ),
              Text(
                dic.addLiquidity,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontSize: Adapt.px(40)),
              ),
              SizedBox(
                width: 5,
              ),
              Tooltip(
                message: dic.addLiquidityTip,
                child: Icon(
                  Icons.info,
                  color: Theme.of(context).unselectedWidgetColor,
                  size: 24,
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 5),
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
                      helperText: token1 != null
                          ? ("${dic.balance}: " +
                              Fmt.token(
                                  token1!.tokenBalance.free, token1!.decimals))
                          : "",
                    ),
                    controller: token1Ctrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      UI.decimalInputFormatter(token1?.decimals ?? 4)
                    ],
                    onChanged: (v) => onToken1Change(),
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0 ||
                          Decimal.parse(val) == Decimal.zero) {
                        return dic.required;
                      } else if (token1 == null) {
                        return dic.selectToken;
                      } else if (Fmt.bigIntToDecimal(
                              token1!.tokenBalance.free, token1!.decimals) <
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
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  onTap: () {
                    if (token1 == null) return;
                    String val = "";
                    if (token1!.currencyId == "0") {
                      val = (Fmt.bigIntToDecimal(
                                  token1!.tokenBalance.free, token1!.decimals) -
                              Decimal.parse('0.02'))
                          .toString();
                    } else {
                      val = Fmt.bigIntToDecimalString(
                          token1!.tokenBalance.free, token1!.decimals);
                    }
                    setState(() {
                      token1Ctrl.text = val;
                    });
                    onToken1Change();
                  },
                ),
                Container(
                  child: token1 != null
                      ? ElevatedButton.icon(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(5)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black12),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black87),
                          ),
                          onPressed: _token1Select,
                          icon: Logo(
                            symbol: token1!.symbol,
                            size: 25,
                          ),
                          label: Text(token1!.symbol),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(5)),
                          ),
                          onPressed: _token1Select,
                          child: Text(dic.selectToken),
                        ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(child: Text("+")),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 5),
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
                      helperText: token2 != null
                          ? ("${dic.balance}: " +
                              Fmt.token(
                                  token2!.tokenBalance.free, token2!.decimals))
                          : "",
                    ),
                    controller: token2Ctrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      UI.decimalInputFormatter(token2?.decimals ?? 4)
                    ],
                    onChanged: (v) => onToken2Change(),
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0 ||
                          Decimal.parse(val) == Decimal.zero) {
                        return dic.required;
                      } else if (token2 == null) {
                        return dic.selectToken;
                      } else if (Fmt.bigIntToDecimal(
                              token2!.tokenBalance.free, token2!.decimals) <
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
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  onTap: () {
                    if (token2 == null) return;
                    String val = "";
                    if (token2!.currencyId == "0") {
                      val = (Fmt.bigIntToDecimal(
                                  token2!.tokenBalance.free, token2!.decimals) -
                              Decimal.parse('0.02'))
                          .toString();
                    } else {
                      val = Fmt.bigIntToDecimalString(
                          token2!.tokenBalance.free, token2!.decimals);
                    }
                    setState(() {
                      token2Ctrl.text = val;
                    });
                    onToken2Change();
                  },
                ),
                Container(
                  child: token2 != null
                      ? ElevatedButton.icon(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(5)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black12),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black87),
                          ),
                          onPressed: _token2Select,
                          icon: Logo(
                            symbol: token2!.symbol,
                            size: 25,
                          ),
                          label: Text(token2!.symbol),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(5)),
                          ),
                          onPressed: _token2Select,
                          child: Text(dic.selectToken),
                        ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          token1 != null && token2 != null
              ? Container(
                  padding:
                      EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dic.pricesAndPoolShare,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(pairs!.priceOf(true)),
                              Text(
                                "${token2!.symbol}  ${dic.per} ${token1!.symbol}",
                                style: TextStyle(fontSize: Adapt.px(22)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(pairs!.priceOf(false)),
                              Text(
                                "${token1!.symbol}  ${dic.per} ${token2!.symbol}",
                                style: TextStyle(fontSize: Adapt.px(22)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(pairs!.shareOfRate(token1Ctrl.text)),
                              Text(
                                dic.shareOfRate,
                                style: TextStyle(fontSize: Adapt.px(22)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: _enableBtn ? _addLiquiditySubmit : null,
                child: Text(dic.supply),
              ))
            ],
          )
        ],
      ),
    );
  }

  /// Remove liquidity
  Widget removeLiquidityWidget() {
    S dic = S.of(context);
    return Form(
      key: _removeLiquidityformKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () => setState(() => _removeLiquidityEnableBtn =
          _removeLiquidityformKey.currentState!.validate()),
      child: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isShowRemoveLiquidity = false;
                  });
                },
                icon: Image.asset(
                  'assets/images/dico/back.png',
                  width: 11,
                ),
              ),
              Text(
                dic.removeLiquidity,
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 5),
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
                      helperText: removeLiquidityData != null
                          ? ("${dic.available}: " +
                              Fmt.token(removeLiquidityData!.balance.free,
                                  Config.liquidityDecimals))
                          : "",
                    ),
                    controller: removeLiquidityCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [UI.decimalInputFormatter(22)],
                    validator: (v) {
                      String val = v!.trim();
                      if (val.length == 0 ||
                          Decimal.parse(val) == Decimal.zero) {
                        return dic.required;
                      } else if (removeLiquidityData == null) {
                        return dic.waiting;
                      } else if (Fmt.bigIntToDecimal(
                              removeLiquidityData!.balance.free,
                              Config.liquidityDecimals) <
                          Decimal.parse(val)) {
                        return dic.amount_low;
                      }
                      return null;
                    },
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(dic.amount_max,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  onTap: () {
                    if (removeLiquidityData == null) return;
                    setState(() {
                      removeLiquidityCtrl.text = Fmt.bigIntToDecimalString(
                          removeLiquidityData!.balance.free,
                          Config.liquidityDecimals);
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed:
                    _removeLiquidityEnableBtn ? _removeLiquiditySubmit : null,
                child: Text(dic.remove),
              ))
            ],
          )
        ],
      ),
    );
  }
}
