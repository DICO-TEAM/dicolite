import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/lbp_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/lbp_swap_output_data.dart';
import 'package:dicolite/widgets/lbp_chart.dart';
import 'package:dicolite/widgets/lbp_detail_widget.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/outlined_button_small.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LbpExchange extends StatefulWidget {
  LbpExchange(this.store);
  static final String route = '/lbp/LbpExchange';
  final AppStore store;

  @override
  _LbpExchange createState() => _LbpExchange(store);
}

class _LbpExchange extends State<LbpExchange> {
  _LbpExchange(this.store);

  final AppStore store;
  final _formKey = GlobalKey<FormState>();
  bool _enableBtn = false;
  String? tokenPayId = "0";
  String? tokenReceiveId;
  CurrencyModel? tokenPay;
  CurrencyModel? tokenReceive;

  final TextEditingController _amountPayCtrl = new TextEditingController();
  final TextEditingController _amountReceiveCtrl = new TextEditingController();
  final TextEditingController _amountSlippageCtrl = new TextEditingController();

  final FocusNode _slippageFocusNode = FocusNode();

  double _slippage = 0.005;
  String? _slippageError;
  bool _insufficientLiquidity = false;
  bool _showSettings = false;
  bool _isShowDetail = false;

  bool _swapExactInMode = true;
  LbpSwapOutputData? _lbpswapOutput;

  String _minReceived = "";
  String _maxSent = "";
  TextStyle valStyle =
      TextStyle(color: Colors.black54, fontWeight: FontWeight.bold);
  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);
  String? lbpId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      String? id = ModalRoute.of(context)?.settings.arguments as String?;
      if (id != null) {
        int index =
            store.dico!.lbpPoolsInProgress!.indexWhere((e) => e.lbpId == id);
        if (index == -1) {
          Navigator.of(context).pop();
        } else {
          setState(() {
            lbpId = id;
            tokenPayId =
                store.dico!.lbpPoolsInProgress![index].fundraisingAsset;
            tokenReceiveId = store.dico!.lbpPoolsInProgress![index].afsAsset;
          });
        }
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  void _init() {
    if (!mounted) return;
    setState(() {
      _enableBtn = false;
      _amountPayCtrl.text = '';
      _amountReceiveCtrl.text = '';
      _insufficientLiquidity = false;
      _swapExactInMode = true;
      _lbpswapOutput = null;
      _minReceived = "";
      _maxSent = "";
    });
  }

  void _showResult(dynamic res) {
    if (mounted) {
      S dic = S.of(context);
      CurrencyModel t1 = tokenPay!;
      CurrencyModel t2 = tokenReceive!;
      String result =
          "${Fmt.token(BigInt.parse(res[4].toString()), t1.decimals)} ${t1.symbol} ${dic.exchanged} ${Fmt.token(BigInt.parse(res[5].toString()), t2.decimals)} ${t2.symbol}";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
        content: Text(result),
        action: SnackBarAction(label: dic.close, onPressed: () {}),
      ));
      _init();
    }
  }

  String _getFee() {
    if (_amountPayCtrl.text.trim().isEmpty) return "0";
    return Fmt.decimalFixed(
        Decimal.parse(_amountPayCtrl.text.trim()) *
            Decimal.parse(Config.lbpSwapfee.toString()),
        5);
  }

  void _switchPair() {
    CurrencyModel? x = tokenPay;
    setState(() {
      tokenPay = tokenReceive;
      tokenPayId = tokenReceiveId;
      tokenReceiveId = x?.currencyId;
      tokenReceive = x;
    });
    if (tokenPay != null && tokenReceive != null) {
      _lbpswapOutput = LbpSwapOutputData(
        slippage: _slippage,
        lbp:
            store.dico!.lbpPoolsInProgress!.firstWhere((e) => e.lbpId == lbpId),
        tokenPay: tokenPay!,
        tokenRecieve: tokenReceive!,
      );
    }
    _updateSwapAmount();
  }

  _ontokenReceiveChange() {
    setState(() {
      _swapExactInMode = false;
      _insufficientLiquidity = false;
    });
    if (tokenReceive != null && tokenPay != null) {
      String? val = _lbpswapOutput!.caltokenPayAmount(_amountReceiveCtrl.text);
      if (val != null) {
        String max = val.isEmpty
            ? ''
            : Fmt.decimalFixed(
                (Decimal.fromInt(1) + Decimal.parse(_slippage.toString())) *
                    Decimal.parse(val),
                5);
        setState(() {
          _amountPayCtrl.text = val;
          _maxSent = max;
          _minReceived = "";
        });
      } else {
        setState(() {
          _amountPayCtrl.text = '';
          _insufficientLiquidity = true;
          _maxSent = "";
          _minReceived = "";
        });
      }
    }
  }

  _ontokenPayChange() {
    setState(() {
      _swapExactInMode = true;
      _insufficientLiquidity = false;
    });
    if (tokenPay != null && tokenReceive != null) {
      String? val = _lbpswapOutput!.caltokenReceiveAmount(_amountPayCtrl.text);

      if (val != null) {
        String min = val.isEmpty
            ? ''
            : Fmt.decimalFixed(
                (Decimal.parse(val) /
                    (Decimal.fromInt(1) + Decimal.parse(_slippage.toString()))),
                5);
        setState(() {
          _amountReceiveCtrl.text = val;
          _minReceived = min;
          _maxSent = "";
        });
      } else {
        setState(() {
          _amountReceiveCtrl.text = '';
          _insufficientLiquidity = true;
          _minReceived = "";
          _maxSent = "";
        });
      }
    }
  }

  void _updateSwapAmount() {
    if (_swapExactInMode) {
      _ontokenPayChange();
    } else {
      _ontokenReceiveChange();
    }
  }

  void _onSlippageChange(String v) {
    final S dic = S.of(context);
    if (v.trim().isEmpty) {
      _updateSlippage(0.005);
      return;
    }

    try {
      double value = double.parse(v.trim());
      if (value > 50 || value < 0.1) {
        setState(() {
          _slippageError = dic.error + " 0.1% ~ 50%";
        });
      } else {
        setState(() {
          _slippageError = null;
        });
        _updateSlippage(value / 100, custom: true);
      }
    } catch (err) {
      setState(() {
        _slippageError = dic.error;
      });
    }
  }

  Future<void> _updateSlippage(double input, {bool custom = false}) async {
    if (!custom) {
      _slippageFocusNode.unfocus();
      setState(() {
        _amountSlippageCtrl.text = '';
        _slippageError = null;
      });
    }
    setState(() {
      _slippage = input;
    });

    _updateSwapAmount();
  }

  /// show price updated tip
  _showPriceUpdated(LbpSwapOutputData? _lbpswapOutput) async {
    S dic = S.of(context);
    return await showModalBottomSheet(
        context: context,
        builder: (contex) {
          return Stack(
            children: [
              Container(
                height: 400,
                color: Colors.black54,
              ),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dic.priceUpdated,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Logo(
                                      size: 25,
                                      symbol: tokenPay!.symbol,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      _amountPayCtrl.text.trim(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: _swapExactInMode
                                                  ? Config.color333
                                                  : Theme.of(context)
                                                      .primaryColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                tokenPay!.symbol,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Logo(
                                      size: 25,
                                      symbol: tokenReceive!.symbol,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      _amountReceiveCtrl.text.trim(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: _swapExactInMode
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Config.color333),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                tokenReceive!.symbol,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          priceWidget(_lbpswapOutput, dic),
                          SizedBox(
                            height: 5,
                          ),
                          outDateWidget(_lbpswapOutput),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    RoundedButton(
                      text: dic.confirmExchange,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<void> _onSubmit(LbpSwapOutputData? _lbpswapOutput) async {
    if (_lbpswapOutput != null && _formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      /// Calcute again . if calcute amount is over maxSent or less then minRecived,notice user
      Decimal oldData =
          Decimal.parse(_swapExactInMode ? _minReceived : _maxSent);

      _updateSwapAmount();
      if (_slippageError != null || _insufficientLiquidity || !_enableBtn) {
        return;
      }
      bool needShowUpdate = _swapExactInMode
          ? (Decimal.parse(_minReceived) < oldData)
          : (Decimal.parse(_maxSent) > oldData);
      if (needShowUpdate) {
        bool? isContinue = await _showPriceUpdated(_lbpswapOutput);

        if (isContinue == null || !isContinue) return;
      }

      TxConfirmParams args = _swapExactInMode
          ? TxConfirmParams(
              title: S.of(context).lbpExchange,
              module: 'lbp',
              call: 'swapExactAmountSupply',
              detail: jsonEncode({
                "supplyAsset": tokenPayId,
                "supplyAmount": _amountPayCtrl.text.trim(),
                "targetAsset": tokenReceiveId,
                "minTargetAmount": _minReceived,
              }),
              params: [
                tokenPayId,
                Fmt.tokenInt(_amountPayCtrl.text.trim(), tokenPay!.decimals)
                    .toString(),
                tokenReceiveId,
                Fmt.tokenInt(_minReceived, tokenReceive!.decimals).toString(),
              ],
              onSuccess: (res) {
                _showResult(res["successRes"]);
              },
            )
          : TxConfirmParams(
              title: S.of(context).lbpExchange,
              module: 'lbp',
              call: 'swapExactAmountTarget',
              detail: jsonEncode({
                "supplyAsset": tokenPayId,
                "maxSupplyAmount": _maxSent,
                "targetAsset": tokenReceiveId,
                "targetAmount": _amountReceiveCtrl.text.trim(),
              }),
              params: [
                tokenPayId,
                Fmt.tokenInt(_maxSent, tokenPay!.decimals).toString(),
                tokenReceiveId,
                Fmt.tokenInt(
                        _amountReceiveCtrl.text.trim(), tokenReceive!.decimals)
                    .toString(),
              ],
              onSuccess: (res) {
                _showResult(res["successRes"]);
              },
            );

      Map? res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args) as Map?;
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  Widget priceWidget(LbpSwapOutputData? swapOutput, S dic) {
    return _lbpswapOutput != null &&
            _amountPayCtrl.text.isNotEmpty &&
            _amountReceiveCtrl.text.isNotEmpty &&
            Decimal.parse(_amountReceiveCtrl.text) != Decimal.zero
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dic.price),
              Text(
                _lbpswapOutput!
                        .quote(_amountPayCtrl.text, _amountReceiveCtrl.text) +
                    " ${tokenPay!.symbol} ${dic.per} ${tokenReceive!.symbol}",
                style: valStyle,
              ),
            ],
          )
        : Container();
  }

  Widget settings(S dic) {
    final primary = Theme.of(context).primaryColor;
    final grey = Theme.of(context).unselectedWidgetColor;
    return RoundedCard(
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 4),
            child: Text(
              dic.slippage,
              style: TextStyle(color: Theme.of(context).unselectedWidgetColor),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OutlinedButtonSmall(
                content: '0.1 %',
                active: _slippage == 0.001,
                onPressed: () => _updateSlippage(0.001),
              ),
              OutlinedButtonSmall(
                content: '0.5 %',
                active: _slippage == 0.005,
                onPressed: () => _updateSlippage(0.005),
              ),
              OutlinedButtonSmall(
                content: '1 %',
                active: _slippage == 0.01,
                onPressed: () => _updateSlippage(0.01),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    CupertinoTextField(
                      padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                      placeholder: dic.custom,
                      inputFormatters: [UI.decimalInputFormatter(4)],
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        border: Border.all(
                            width: 0.5,
                            color:
                                _slippageFocusNode.hasFocus ? primary : grey),
                      ),
                      controller: _amountSlippageCtrl,
                      focusNode: _slippageFocusNode,
                      onChanged: _onSlippageChange,
                      suffix: Container(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          '%',
                          style: TextStyle(
                              color:
                                  _slippageFocusNode.hasFocus ? primary : grey),
                        ),
                      ),
                    ),
                    _slippageError != null
                        ? Text(
                            _slippageError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget outDateWidget(LbpSwapOutputData? _lbpswapOutput) {
    S dic = S.of(context);

    return Column(
      children: [
        tokenReceive != null &&
                tokenPay != null &&
                // priceImpact != null &&
                (_maxSent.isNotEmpty || _minReceived.isNotEmpty)
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _swapExactInMode
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(dic.minReceived),
                              Text(
                                "$_minReceived ${tokenReceive!.symbol}",
                                style: valStyle,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(dic.maxSent),
                              Text(
                                "$_maxSent ${tokenPay!.symbol}",
                                style: valStyle,
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(dic.fee),
                        Text(
                          "${_getFee()} ${tokenPay!.symbol}",
                          style: valStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  void dispose() {
    _amountPayCtrl.dispose();
    _amountReceiveCtrl.dispose();
    _amountSlippageCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(_) {
    return Observer(
      builder: (BuildContext context) {
        final dic = S.of(context);
        LbpModel? lbp;

        if (lbpId != null && tokenPayId != null && tokenReceiveId != null) {
          int index = store.dico!.lbpPoolsInProgress!
              .indexWhere((e) => e.lbpId == lbpId);
          if (index == -1) {
            Navigator.of(context).pop();
            return Scaffold();
          }
          lbp = store.dico!.lbpPoolsInProgress![index];
          if (tokenPayId == lbp.afsAsset) {
            tokenPay = lbp.afsToken;
            tokenReceive = lbp.fundraisingToken;
          } else {
            tokenReceive = lbp.afsToken;
            tokenPay = lbp.fundraisingToken;
          }
        }

        if (tokenPay != null && tokenReceive != null) {
          _lbpswapOutput = LbpSwapOutputData(
            slippage: _slippage,
            lbp: store.dico!.lbpPoolsInProgress!
                .firstWhere((e) => e.lbpId == lbpId),
            tokenPay: tokenPay!,
            tokenRecieve: tokenReceive!,
          );
        }
        int blockTime = store.settings?.blockDuration ?? 0;
        int now = store.dico?.newHeads?.number ?? 0;
        bool isFinished = ((lbp?.endBlock ?? 0) - now) <= 0;

        return Scaffold(
          appBar: myAppBar(context, dic.lbpExchange),
          body: RefreshIndicator(
            key: globalLbpExchangeRefreshKey,
            onRefresh: () async {
              await webApi?.dico?.subLbpPoolsChange();
            },
            child: lbp == null
                ? LoadingWidget()
                : ListView(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    children: <Widget>[
                      store.dico?.newHeads?.number == null
                          ? Container()
                          : Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(15, 7, 10, 7),
                                    decoration: BoxDecoration(
                                        color: isFinished
                                            ? Theme.of(context).disabledColor
                                            : Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(50))),
                                    child: Text(
                                      isFinished
                                          ? dic.finished
                                          : Fmt.blockToTime(
                                              lbp.endBlock - now, blockTime),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(height: 200, child: LbpChart(lbp, store)),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isShowDetail = !_isShowDetail;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(dic.detail),
                                      Icon(
                                        _isShowDetail
                                            ? Icons.arrow_drop_down
                                            : Icons.arrow_right,
                                        size: 28,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _isShowDetail
                                ? Column(
                                    children: [
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: LbpDetailWidget(store, lbp),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      _showSettings ? settings(dic) : Container(),
                      RoundedCard(
                        radius: 15,
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: () => setState(() =>
                              _enableBtn = _formKey.currentState!.validate()),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dic.lbpExchange,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  IconButton(
                                      color: Colors.black45,
                                      onPressed: () {
                                        setState(() {
                                          _showSettings = !_showSettings;
                                        });
                                      },
                                      icon: Icon(Icons.settings))
                                ],
                              ),

                              Divider(),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 15, left: 10, right: 15, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Colors.transparent,
                                          filled: true,
                                          hintText: "0.0",
                                          helperText: tokenPay != null
                                              ? ("${dic.balance}: " +
                                                  Fmt.token(
                                                      tokenPay!
                                                          .tokenBalance.free,
                                                      tokenPay!.decimals))
                                              : "",
                                        ),
                                        style: boldStyle,
                                        controller: _amountPayCtrl,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          UI.decimalInputFormatter(
                                              tokenPay?.decimals ?? 4)
                                        ],
                                        onChanged: (v) => _ontokenPayChange(),
                                        validator: (v) {
                                          String val = v!.trim();
                                          if (val.length == 0 ||
                                              Decimal.parse(val) ==
                                                  Decimal.zero) {
                                            return dic.required;
                                          } else if (tokenPay == null) {
                                            return dic.selectToken;
                                          } else if (Fmt.bigIntToDecimal(
                                                  tokenPay!.tokenBalance.free,
                                                  tokenPay!.decimals) <
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
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                      onTap: () {
                                        if (tokenPay == null) return;
                                        String val = "";
                                        if (tokenPay!.currencyId == "0") {
                                          val = (Fmt.bigIntToDecimal(
                                                      tokenPay!
                                                          .tokenBalance.free,
                                                      tokenPay!.decimals) -
                                                  Decimal.parse('0.02'))
                                              .toString();
                                        } else {
                                          val = Fmt.bigIntToDecimalString(
                                              tokenPay!.tokenBalance.free,
                                              tokenPay!.decimals);
                                        }
                                        setState(() {
                                          _amountPayCtrl.text = val;
                                        });
                                        _ontokenPayChange();
                                      },
                                    ),
                                    Container(
                                      child: tokenPay != null
                                          ? ElevatedButton.icon(
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.all(5)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black12),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black87),
                                              ),
                                              onPressed: () {},
                                              icon: Logo(
                                                symbol: tokenPay!.symbol,
                                                size: 25,
                                              ),
                                              label: Text(
                                                tokenPay!.symbol,
                                                style: boldStyle,
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                color: Colors.grey,
                                icon: Icon(Icons.arrow_downward),
                                onPressed: _switchPair,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 15, left: 10, right: 15, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Colors.transparent,
                                          filled: true,
                                          hintText: "0.0",
                                          helperText: tokenReceive != null
                                              ? ("${dic.balance}: " +
                                                  Fmt.token(
                                                      tokenReceive!
                                                          .tokenBalance.free,
                                                      tokenReceive!.decimals))
                                              : "",
                                        ),
                                        style: boldStyle,
                                        controller: _amountReceiveCtrl,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          UI.decimalInputFormatter(
                                              tokenReceive?.decimals ?? 4)
                                        ],
                                        onChanged: (v) =>
                                            _ontokenReceiveChange(),
                                        validator: (v) {
                                          String val = v!.trim();
                                          if (val.length == 0 ||
                                              Decimal.parse(val) ==
                                                  Decimal.zero) {
                                            return dic.required;
                                          } else if (tokenReceive == null) {
                                            return dic.selectToken;
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
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                      onTap: () {
                                        if (tokenReceive == null) return;
                                        String val = "";
                                        if (tokenReceive!.currencyId == "0") {
                                          val = (Fmt.bigIntToDecimal(
                                                      tokenReceive!
                                                          .tokenBalance.free,
                                                      tokenReceive!.decimals) -
                                                  Decimal.parse('0.02'))
                                              .toString();
                                        } else {
                                          val = Fmt.bigIntToDecimalString(
                                              tokenReceive!.tokenBalance.free,
                                              tokenReceive!.decimals);
                                        }
                                        setState(() {
                                          _amountReceiveCtrl.text = val;
                                        });
                                        _ontokenReceiveChange();
                                      },
                                    ),
                                    Container(
                                      child: tokenReceive != null
                                          ? ElevatedButton.icon(
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.all(5)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black12),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black87),
                                              ),
                                              onPressed: () {},
                                              icon: Logo(
                                                symbol: tokenReceive!.symbol,
                                                size: 25,
                                              ),
                                              label: Text(
                                                tokenReceive!.symbol,
                                                style: boldStyle,
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ////////////// Price Price Price Price
                              Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: priceWidget(_lbpswapOutput, dic),
                              ),
                              ////////////// Price Price Price Price
                              SizedBox(
                                height: 10,
                              ),
                              RoundedButton(
                                foregroundColor: _lbpswapOutput != null &&
                                        _insufficientLiquidity
                                    ? Colors.red
                                    : Colors.white,
                                text: _lbpswapOutput != null &&
                                        _insufficientLiquidity
                                    ? dic.insufficientLiquidity
                                    : dic.exchange,
                                onPressed: !isFinished &&
                                        _slippageError == null &&
                                        !_insufficientLiquidity &&
                                        _enableBtn
                                    ? () => _onSubmit(_lbpswapOutput)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                        child: outDateWidget(_lbpswapOutput),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
