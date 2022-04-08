import 'package:decimal/decimal.dart';
import 'package:dicolite/common/trade_graph.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/model/route_model.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/liquidity_model.dart';
import 'package:dicolite/utils/format.dart';

class SwapOutputData {
  String? input;
  String? output;
  double slippage;

  CurrencyModel tokenPay;
  CurrencyModel tokenRecieve;

  List<LiquidityModel> liquidityList;

  SwapOutputData({
    required this.slippage,
    required this.tokenPay,
    required this.tokenRecieve,
    required this.liquidityList,
  });

  List<LiquidityModel> _pathToLiquidityList(List path) {
    List<List<String>> pathList = [];
    for (var i = 1; i < path.length; i++) {
      pathList.add([path[i - 1], path[i]]);
    }
    List<LiquidityModel> list = pathList
        .map((e) =>
            liquidityList.firstWhere((x) => x.isContainsCurrencyIds(e)))
        .toList();
    return list;
  }

  List<List<LiquidityModel>> get swapPaths {
    if (liquidityList.isNotEmpty) {
      TradeGraph tradeGraph = TradeGraph(liquidityList);
      List<List<String>> paths =
          tradeGraph.getPaths(tokenPay.currencyId, tokenRecieve.currencyId);

      return paths.map((e) => _pathToLiquidityList(e)).toList();
    }
    return [];
  }

  RouteModel getRoute(List<LiquidityModel> liquidityPath) {
    if (liquidityPath.isEmpty) {
      return RouteModel(liquidityPath, [], []);
    }
    if (liquidityPath.length == 1) {
      return RouteModel(
          liquidityPath,
          [tokenPay.currencyId, tokenRecieve.currencyId],
          [tokenPay.symbol, tokenRecieve.symbol]);
    }
    String lastId = tokenPay.currencyId;
    List<String> idList = [tokenPay.currencyId];
    List<String> symbolList = [tokenPay.symbol];
    for (var i = 0; i < liquidityPath.length; i++) {
      lastId = liquidityPath[i]
          .currencyIds
          .firstWhere((element) => element != lastId);

      idList.add(lastId);
      symbolList.add(liquidityPath[i].currencyId1 == lastId
          ? liquidityPath[i].symbol1
          : liquidityPath[i].symbol2);
    }

    return RouteModel(liquidityPath, idList, symbolList);
  }

  CalcuResult calcuReceiveAmountBestResult(String tokenPayAmount) {
    List<CalcuResult> result = swapPaths
        .map((path) => CalcuResult(
            route: getRoute(path),
            amount: _caltokenReceiveAmount(path, tokenPayAmount)))
        .toList();
    result.sort((a, b) => double.parse(
            (b.amount ?? "0").isEmpty ? "0" : (b.amount ?? "0"))
        .compareTo(
            double.parse((a.amount ?? "0").isEmpty ? "0" : (a.amount ?? "0"))));
    if (result.isNotEmpty) {
      return result[0];
    }
    return CalcuResult(
      route: null,
      amount: null,
    );
  }

  /// Given the input amount of the asset and the transaction pair reserve,
  /// return the maximum output amount of the other assets.
  /// Calculation formula: amountIn * 997/1000 / amountOut = reserveIn / (reserveOut-amountOut)
  /// ******************************************************************************************//
  ///  get_amount_out                                                                           //
  ///  aI = amount_in                      aI * 997 * rO                                        //
  ///  rI = reserve_in          aO = --------------------------                                 //
  ///  rO = reserve_out                 rI * 1000 + aI * 997                                    //
  ///  aO = amount_out                                                                          //
  /// ******************************************************************************************//
  String? _caltokenReceiveAmount(
      List<LiquidityModel> liquidityPath, String tokenPayAmount) {
    tokenPayAmount = tokenPayAmount.trim();
    if (liquidityPath.isEmpty || tokenPayAmount.isEmpty) {
      return "";
    }
    Decimal val = Decimal.zero;
    if (liquidityPath.length == 1) {
      bool isToken1EqualTokenPay =
          liquidityPath[0].currencyId1 == tokenPay.currencyId;
      Decimal reserveIn = Fmt.bigIntToDecimal(
          isToken1EqualTokenPay
              ? liquidityPath[0].token1Amount
              : liquidityPath[0].token2Amount,
          tokenPay.decimals);

      Decimal reserveOut = Fmt.bigIntToDecimal(
          isToken1EqualTokenPay
              ? liquidityPath[0].token2Amount
              : liquidityPath[0].token1Amount,
          tokenRecieve.decimals);
      Decimal amountIn = Decimal.parse(tokenPayAmount);

      if (reserveIn == Decimal.zero ||
          reserveOut == Decimal.zero ||
          amountIn >= reserveIn) {
        return null;
      }
      val = (amountIn * reserveOut * Decimal.fromInt(997)) /
          ((reserveIn * Decimal.fromInt(1000)) +
              (amountIn * Decimal.fromInt(997)));

      if (val >= reserveOut) {
        return null;
      }
      return Fmt.decimalFixed(val, tokenRecieve.decimals + 5);
    } else {
      return _caltokenReceiveAmountForMulti(
          liquidityPath, 0, tokenPayAmount, tokenPay.currencyId);
    }
  }

  String? _caltokenReceiveAmountForMulti(List<LiquidityModel> liquidityPath,
      int index, String tokenInAmount, String tokenInCurrencyId) {
    tokenInAmount = tokenInAmount.trim();
    LiquidityModel liquidity = liquidityPath[index];
    Decimal val = Decimal.zero;
    bool isToken1EqualTokenIn = liquidity.currencyId1 == tokenInCurrencyId;
    String tokenOutCurrencyId =
        isToken1EqualTokenIn ? liquidity.currencyId2 : liquidity.currencyId1;
    int tokenInDecimals =
        isToken1EqualTokenIn ? liquidity.decimals1 : liquidity.decimals2;
    int tokenOutDecimals =
        isToken1EqualTokenIn ? liquidity.decimals2 : liquidity.decimals1;

    Decimal reserveIn = Fmt.bigIntToDecimal(
        isToken1EqualTokenIn ? liquidity.token1Amount : liquidity.token2Amount,
        tokenInDecimals);

    Decimal reserveOut = Fmt.bigIntToDecimal(
        isToken1EqualTokenIn ? liquidity.token2Amount : liquidity.token1Amount,
        tokenOutDecimals);
    Decimal amountIn = Decimal.parse(tokenInAmount);

    if (amountIn >= reserveIn) {
      return null;
    }
    val = (amountIn * reserveOut * Decimal.fromInt(997)) /
        ((reserveIn * Decimal.fromInt(1000)) +
            (amountIn * Decimal.fromInt(997)));

    if (val >= reserveOut) {
      return null;
    }
    index++;
    String out = Fmt.decimalFixed(val, tokenOutDecimals + 5);
    if (index == liquidityPath.length) {
      return out;
    } else {
      return _caltokenReceiveAmountForMulti(
          liquidityPath, index, out, tokenOutCurrencyId);
    }
  }

  CalcuResult calcuPayAmountBestResult(String tokenRecieveAmount) {
    List<CalcuResult> result = swapPaths
        .map((path) => CalcuResult(
            route: getRoute(path),
            amount: _caltokenPayAmount(path, tokenRecieveAmount)))
        .toList();

    result.sort((a, b) => double.parse(
            (a.amount ?? "0").isEmpty ? "0" : (a.amount ?? "0"))
        .compareTo(
            double.parse((b.amount ?? "0").isEmpty ? "0" : (b.amount ?? "0"))));
    if (result.isNotEmpty) {
      return result[0];
    }
    return CalcuResult(
      route: null,
      amount: null,
    );
  }

  /// Given the output amount of the asset and the transaction pair reserve,
  /// return the required input amount for the other assets.
  /// Calculation formula: amountIn * 997/1000 / amountOut = reserveIn / (reserveOut-amountOut)
  /// ******************************************************************************************//
  ///  get_amount_in                                                                            //
  ///  aI = amount_in                   rI * 1000 * aO                                          //
  ///  rI = reserve_in          aI = ------------------- + 1                                    //
  ///  rO = reserve_out                (rO - aO) * 997                                          //
  ///  aO = amount_out                                                                          //
  /// ******************************************************************************************//
  String? _caltokenPayAmount(
      List<LiquidityModel> liquidityPath, String tokenRecieveAmount) {
    tokenRecieveAmount = tokenRecieveAmount.trim();
    if (liquidityPath.isEmpty || tokenRecieveAmount.isEmpty) {
      return "";
    }
    Decimal val = Decimal.zero;
    if (liquidityPath.length == 1) {
      bool isToken1EqualTokenPay =
          liquidityPath[0].currencyId1 == tokenPay.currencyId;
      Decimal reserveIn = Fmt.bigIntToDecimal(
          isToken1EqualTokenPay
              ? liquidityPath[0].token1Amount
              : liquidityPath[0].token2Amount,
          tokenPay.decimals);

      Decimal reserveOut = Fmt.bigIntToDecimal(
          isToken1EqualTokenPay
              ? liquidityPath[0].token2Amount
              : liquidityPath[0].token1Amount,
          tokenRecieve.decimals);
      Decimal amountOut = Decimal.parse(tokenRecieveAmount);

      if (reserveIn == Decimal.zero ||
          reserveOut == Decimal.zero ||
          amountOut >= reserveOut) {
        return null;
      }
      val = ((reserveIn * amountOut * Decimal.fromInt(1000)) /
          ((reserveOut - amountOut) * Decimal.fromInt(997)));

      if (val >= reserveIn) {
        return null;
      }
      return Fmt.decimalFixed(val, tokenPay.decimals + 5);
    } else {
      return _caltokenPayAmountForMulti(liquidityPath, liquidityPath.length - 1,
          tokenRecieveAmount, tokenRecieve.currencyId);
    }
  }

  String? _caltokenPayAmountForMulti(List<LiquidityModel> liquidityPath,
      int index, String tokenOutAmount, String tokenOutCurrencyId) {
    tokenOutAmount = tokenOutAmount.trim();
    LiquidityModel liquidity = liquidityPath[index];
    Decimal val = Decimal.zero;
    bool isToken1EqualTokenIn = liquidity.currencyId2 == tokenOutCurrencyId;
    String tokenInCurrencyId =
        isToken1EqualTokenIn ? liquidity.currencyId1 : liquidity.currencyId2;
    int tokenInDecimals =
        isToken1EqualTokenIn ? liquidity.decimals1 : liquidity.decimals2;
    int tokenOutDecimals =
        isToken1EqualTokenIn ? liquidity.decimals2 : liquidity.decimals1;

    Decimal reserveIn = Fmt.bigIntToDecimal(
        isToken1EqualTokenIn ? liquidity.token1Amount : liquidity.token2Amount,
        tokenInDecimals);

    Decimal reserveOut = Fmt.bigIntToDecimal(
        isToken1EqualTokenIn ? liquidity.token2Amount : liquidity.token1Amount,
        tokenOutDecimals);
    Decimal amountOut = Decimal.parse(tokenOutAmount);

    if (amountOut >= reserveOut) {
      return null;
    }
    val = ((reserveIn * amountOut * Decimal.fromInt(1000)) /
        ((reserveOut - amountOut) * Decimal.fromInt(997)));

    if (val >= reserveIn) {
      return null;
    }

    index--;
    String? inData = Fmt.decimalFixed(val, tokenInDecimals + 5);
    if (index == -1) {
      return inData;
    } else {
      return _caltokenPayAmountForMulti(
          liquidityPath, index, inData, tokenInCurrencyId);
    }
  }

  String quote(String amountPay, String amountReceive) {
    bool isPayLessThanReceive =
        Decimal.parse(amountPay) < Decimal.parse(amountReceive);
    return Fmt.decimalFixed(
        Decimal.parse(amountPay) / Decimal.parse(amountReceive),
        isPayLessThanReceive ? 5 : 1);
  }

  /// calculate price impact := (exactQuote - outputAmount) / exactQuote
  Decimal? computePriceImpact(List<LiquidityModel>? liquidityPath,
      String amountPay, String amountReceive) {
    if (liquidityPath == null ||
        liquidityPath.isEmpty ||
        amountPay.trim().isEmpty ||
        amountReceive.trim().isEmpty ||
        Decimal.parse(amountPay.trim()) == Decimal.zero ||
        Decimal.parse(amountReceive.trim()) == Decimal.zero) return null;
    Decimal midPrice = Decimal.zero;
    if (liquidityPath.length == 1) {
      LiquidityModel liquidity = liquidityPath[0];
      if (liquidity.token1Amount == BigInt.zero ||
          liquidity.token2Amount == BigInt.zero) return null;
      bool isToken1EqualTokenPay = liquidity.currencyId1 == tokenPay.currencyId;
      if (isToken1EqualTokenPay) {
        midPrice = Fmt.bigIntToDecimal(
                liquidity.token1Amount, liquidity.decimals1) /
            Fmt.bigIntToDecimal(liquidity.token2Amount, liquidity.decimals2);
      } else {
        midPrice = Fmt.bigIntToDecimal(
                liquidity.token2Amount, liquidity.decimals2) /
            Fmt.bigIntToDecimal(liquidity.token1Amount, liquidity.decimals1);
      }
    } else {
      /// [1,10][100,1000]
      midPrice = _calMidPriceForMulti(
          liquidityPath, 0, Decimal.fromInt(1), tokenPay.currencyId);
    }

    Decimal quotedOutput = Decimal.parse(amountPay) / midPrice;

    var priceImpact = (quotedOutput - Decimal.parse(amountReceive)) *
        Decimal.fromInt(100) /
        quotedOutput;
    return priceImpact -
        (Decimal.parse(Config.swapfee.toString()) *
            Decimal.fromInt(100 * liquidityPath.length));
  }

  Decimal _calMidPriceForMulti(List<LiquidityModel> liquidityPath, int index,
      Decimal midPrice, String tokenInCurrencyId) {
    LiquidityModel liquidity = liquidityPath[index];

    bool isToken1EqualTokenIn = liquidity.currencyId1 == tokenInCurrencyId;
    if (isToken1EqualTokenIn) {
      midPrice *=
          Fmt.bigIntToDecimal(liquidity.token1Amount, liquidity.decimals1) /
              Fmt.bigIntToDecimal(liquidity.token2Amount, liquidity.decimals2);
    } else {
      midPrice *=
          Fmt.bigIntToDecimal(liquidity.token2Amount, liquidity.decimals2) /
              Fmt.bigIntToDecimal(liquidity.token1Amount, liquidity.decimals1);
    }

    index++;
    if (index == liquidityPath.length) {
      return midPrice;
    } else {
      return _calMidPriceForMulti(liquidityPath, index, midPrice,
          isToken1EqualTokenIn ? liquidity.currencyId2 : liquidity.currencyId1);
    }
  }
}

class CalcuResult {
  RouteModel? route;
  String? amount;
  CalcuResult({required this.route, required this.amount});
}
