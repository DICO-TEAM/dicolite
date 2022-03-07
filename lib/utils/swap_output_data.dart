import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dijkstra/dijkstra.dart';
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


  List<LiquidityModel> get findLiquidityList {
    int index = liquidityList.indexWhere((e) =>
        (e.currencyId1 == tokenPay.currencyId &&
            e.currencyId2 == tokenRecieve.currencyId) ||
        (e.currencyId1 == tokenRecieve.currencyId &&
            e.currencyId2 == tokenPay.currencyId));
    if (index != -1) {
      return [liquidityList[index]];
    }
    List<List> liquidityIdsList =
        liquidityList.map((e) => e.currencyIds).toList();
    List path = Dijkstra.findPathFromPairsList(
        liquidityIdsList, tokenPay.currencyId, tokenRecieve.currencyId);

    List<Set> pathList = [];
    for (var i = 1; i < path.length; i++) {
      pathList.add(Set.from([path[i - 1], path[i]]));
    }

    List<LiquidityModel> list = pathList
        .map((Set e) => liquidityList
            .firstWhere((x) => x.currencyIds.toSet().containsAll(e)))
        .toList();

    return list;
  }

  Route get route {
    if (findLiquidityList.isEmpty) {
      return Route([], []);
    }
    if (findLiquidityList.length == 1) {
      return Route([tokenPay.currencyId, tokenRecieve.currencyId],
          [tokenPay.symbol, tokenRecieve.symbol]);
    }
    String lastId = tokenPay.currencyId;
    List<String> idList = [tokenPay.currencyId];
    List<String> symbolList = [tokenPay.symbol];
    for (var i = 0; i < findLiquidityList.length; i++) {
      lastId = findLiquidityList[i]
          .currencyIds
          .firstWhere((element) => element != lastId);

      idList.add(lastId);
      symbolList.add(findLiquidityList[i].currencyId1 == lastId
          ? findLiquidityList[i].symbol1
          : findLiquidityList[i].symbol2);
    }
 
    return Route(idList, symbolList);
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
  String? caltokenReceiveAmount(String tokenPayAmount) {
    tokenPayAmount = tokenPayAmount.trim();
    if (findLiquidityList.isEmpty || tokenPayAmount.isEmpty) {
      return "";
    }
    Decimal val = Decimal.zero;
    if (findLiquidityList.length == 1) {
      bool isToken1EqualTokenPay =
          findLiquidityList[0].currencyId1 == tokenPay.currencyId;
      Decimal reserveIn = Fmt.bigIntToDecimal(
          isToken1EqualTokenPay
              ? findLiquidityList[0].token1Amount
              : findLiquidityList[0].token2Amount,
          tokenPay.decimals);

      Decimal reserveOut = Fmt.bigIntToDecimal(
          isToken1EqualTokenPay
              ? findLiquidityList[0].token2Amount
              : findLiquidityList[0].token1Amount,
          tokenRecieve.decimals);
      Decimal amountIn = Decimal.parse(tokenPayAmount);

      if (reserveIn==Decimal.zero||reserveOut==Decimal.zero||amountIn >= reserveIn) {
        return null;
      }
      val = (amountIn * reserveOut * Decimal.fromInt(997)) /
          ((reserveIn * Decimal.fromInt(1000)) +
              (amountIn * Decimal.fromInt(997)));

      if (val >= reserveOut) {
        return null;
      }
      return Fmt.decimalFixed(val, tokenRecieve.decimals+5);
    } else {
      return _caltokenReceiveAmountForMulti(
          0, tokenPayAmount, tokenPay.currencyId);
    }
  }

  String? _caltokenReceiveAmountForMulti(
      int index, String tokenInAmount, String tokenInCurrencyId) {
    tokenInAmount = tokenInAmount.trim();
    LiquidityModel liquidity = findLiquidityList[index];
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
    String out = Fmt.decimalFixed(val, tokenOutDecimals+5);
    if (index == findLiquidityList.length) {
      return out;
    } else {
      return _caltokenReceiveAmountForMulti(index, out, tokenOutCurrencyId);
    }
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
  String? caltokenPayAmount(String tokenRecieveAmount) {
    tokenRecieveAmount = tokenRecieveAmount.trim();
    if (findLiquidityList.isEmpty || tokenRecieveAmount.isEmpty) {
      return "";
    }
    Decimal val = Decimal.zero;
    if (findLiquidityList.length == 1) {
      bool isToken1EqualTokenPay =
          findLiquidityList[0].currencyId1 == tokenPay.currencyId;
      Decimal reserveIn = Fmt.bigIntToDecimal(
          isToken1EqualTokenPay
              ? findLiquidityList[0].token1Amount
              : findLiquidityList[0].token2Amount,
          tokenPay.decimals);

      Decimal reserveOut = Fmt.bigIntToDecimal(
          isToken1EqualTokenPay
              ? findLiquidityList[0].token2Amount
              : findLiquidityList[0].token1Amount,
          tokenRecieve.decimals);
      Decimal amountOut = Decimal.parse(tokenRecieveAmount);

      if (reserveIn==Decimal.zero||reserveOut==Decimal.zero||amountOut >= reserveOut) {
        return null;
      }
      val = ((reserveIn * amountOut * Decimal.fromInt(1000)) /
          ((reserveOut - amountOut) * Decimal.fromInt(997)));

      if (val >= reserveIn) {
        return null;
      }
      return Fmt.decimalFixed(val, tokenPay.decimals+5);
    } else {
      return _caltokenPayAmountForMulti(
          findLiquidityList.length-1, tokenRecieveAmount, tokenRecieve.currencyId);
    }
  }

  String? _caltokenPayAmountForMulti(
      int index, String tokenOutAmount, String tokenOutCurrencyId) {
    tokenOutAmount = tokenOutAmount.trim();
    LiquidityModel liquidity = findLiquidityList[index];
    Decimal val = Decimal.zero;
    bool isToken1EqualTokenIn = liquidity.currencyId2 == tokenOutCurrencyId;
    String tokenInCurrencyId =
        isToken1EqualTokenIn ? liquidity.currencyId1 : liquidity.currencyId2;
    int tokenInDecimals =
        isToken1EqualTokenIn ? liquidity.decimals1 : liquidity.decimals2;
    int tokenOutDecimals =
        isToken1EqualTokenIn ? liquidity.decimals2 : liquidity.decimals1;

    Decimal reserveIn = Fmt.bigIntToDecimal(
        isToken1EqualTokenIn
            ? liquidity.token1Amount
            : liquidity.token2Amount,
        tokenInDecimals);

    Decimal reserveOut = Fmt.bigIntToDecimal(
        isToken1EqualTokenIn
            ? liquidity.token2Amount
            : liquidity.token1Amount,
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
    String? inData = Fmt.decimalFixed(val, tokenInDecimals+5);
    if (index == -1) {
      return inData;
    } else {
      return _caltokenPayAmountForMulti(index, inData, tokenInCurrencyId);
    }
  }

String  quote(String amountPay, String amountReceive) {
    bool isPayLessThanReceive =
        Decimal.parse(amountPay) < Decimal.parse(amountReceive);
    return Fmt.decimalFixed(
        Decimal.parse(amountPay) / Decimal.parse(amountReceive),
        isPayLessThanReceive ? 5 : 1);
  }

  /// calculate price impact := (exactQuote - outputAmount) / exactQuote
  Decimal? computePriceImpact(String amountPay, String amountReceive) {
    if (findLiquidityList.isEmpty ||
        amountPay.trim().isEmpty ||
        amountReceive.trim().isEmpty ||
        Decimal.parse(amountPay.trim()) == Decimal.zero||Decimal.parse(amountReceive.trim()) == Decimal.zero) return null;
    Decimal midPrice = Decimal.zero;
    if (findLiquidityList.length == 1) {
      LiquidityModel liquidity = findLiquidityList[0];
      if(liquidity.token1Amount==BigInt.zero||liquidity.token2Amount==BigInt.zero)return null;
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
      midPrice =
          _calMidPriceForMulti(0, Decimal.fromInt(1), tokenPay.currencyId);
    }

    Decimal quotedOutput =
        Decimal.parse(amountPay) / midPrice;

    var priceImpact =
        (quotedOutput - Decimal.parse(amountReceive)) * Decimal.fromInt(100) / quotedOutput;
    return priceImpact-(Decimal.parse(Config.swapfee.toString())* Decimal.fromInt(100*findLiquidityList.length));
  }

  Decimal _calMidPriceForMulti(
      int index, Decimal midPrice, String tokenInCurrencyId) {
    LiquidityModel liquidity = findLiquidityList[index];

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
    if (index == findLiquidityList.length) {
      return midPrice;
    } else {
      return _calMidPriceForMulti(index, midPrice, isToken1EqualTokenIn?liquidity.currencyId2:liquidity.currencyId1);
    }
  }
}

class Route {
  List<String> path;
  List<String> symbolList;
  Route(this.path, this.symbolList);
}
