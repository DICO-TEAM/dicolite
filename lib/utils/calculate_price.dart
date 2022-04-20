import 'package:decimal/decimal.dart';
import 'package:dicolite/common/trade_graph.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/utils/format.dart';

import '../model/liquidity_model.dart';

class CalculatePrice {
  ///Calcute token best price
  static calcuteTokenBestPrice(List<LiquidityModel> liquidityList,
      Decimal amountIn, String tokenInCurrencyId) {
    if (liquidityList.isNotEmpty) {
      TradeGraph tradeGraph = TradeGraph(liquidityList);
      List<List<String>> paths =
          tradeGraph.getPaths(tokenInCurrencyId, Config.USDtokenId);
      if (paths.isNotEmpty) {
        List<Decimal?> result = paths
            .map((e) => _pathToLiquidityList(e, liquidityList))
            .map((path) =>
                calcuteTokenValOfUsd(path, amountIn, tokenInCurrencyId))
            .toList();
        result.sort((a, b) => double.parse(
                (b?.toString() ?? "0").isEmpty ? "0" : (b?.toString() ?? "0"))
            .compareTo(double.parse((a?.toString() ?? "0").isEmpty
                ? "0"
                : (a?.toString() ?? "0"))));
        if (result.isNotEmpty) {
          return result[0];
        }
      }
    } else {
      return null;
    }
  }

  static List<LiquidityModel> _pathToLiquidityList(
      List path, List<LiquidityModel> liquidityList) {
    List<List<String>> pathList = [];
    for (var i = 1; i < path.length; i++) {
      pathList.add([path[i - 1], path[i]]);
    }
    List<LiquidityModel> list = pathList
        .map((e) => liquidityList.firstWhere((x) => x.isContainsCurrencyIds(e)))
        .toList();
    return list;
  }

  ///Calcute value of usd
  static Decimal? calcuteTokenValOfUsd(List<LiquidityModel> liquidityList,
      Decimal amountIn, String tokenInCurrencyId) {
    List<String> path = [];
    if (liquidityList.isNotEmpty) {
      TradeGraph tradeGraph = TradeGraph(liquidityList);
      List<List<String>> paths =
          tradeGraph.getPaths(tokenInCurrencyId, Config.USDtokenId);
      if (paths.isNotEmpty) {
        path = paths[0];
      }
    } else {
      return null;
    }

    if (BigInt.parse(tokenInCurrencyId) > Config.liquidityFirstId) {
      return null;
    }
    if (path.isEmpty) {
      return null;
    }

    Decimal? midPrice;
    try {
      List<LiquidityModel> findLiquidityList =
          _pathToLiquidityList(path, liquidityList);

      midPrice = _calMidPriceForMulti(
          findLiquidityList, 0, Decimal.fromInt(1), tokenInCurrencyId);
    } catch (e) {
      print("Error:$e");
    }

    if (midPrice == null) {
      return null;
    }
    return amountIn / midPrice;
  }

  static Decimal? _calMidPriceForMulti(List<LiquidityModel> findLiquidityList,
      int index, Decimal midPrice, String tokenInCurrencyId) {
    LiquidityModel liquidity = findLiquidityList[index];

    if (liquidity.token1Amount == BigInt.zero ||
        liquidity.token2Amount == BigInt.zero) {
      return null;
    }

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
      return _calMidPriceForMulti(findLiquidityList, index, midPrice,
          isToken1EqualTokenIn ? liquidity.currencyId2 : liquidity.currencyId1);
    }
  }
}
