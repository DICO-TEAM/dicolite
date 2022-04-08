import 'package:decimal/decimal.dart';
import 'package:dicolite/common/trade_graph.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/liquidity_model.dart';
import 'package:dicolite/utils/format.dart';

class FarmPoolModel {
  BigInt accDicoPerShare;
  int allocPoint;
  int lastRewardBlock;

  /// isLP int.parse(json["currencyId"].toString())>=Config.liquidityFirstId
  String currencyId;
  LiquidityModel? liquidity;

  CurrencyModel? token;
  int poolId;
  BigInt totalAmount;

  /// my amount
  BigInt myAmount;

  /// my reward debt
  BigInt myRewardDebt;

  bool get isLP {
    return BigInt.parse(currencyId) >= Config.liquidityFirstId;
  }

  String get symbol {
    return isLP ? liquidity!.symbol : token!.symbol;
  }

  bool get isStaked {
    return myAmount != BigInt.zero;
  }

  bool get isFinished {
    return allocPoint == 0;
  }

  int get poolDeciaml {
    return isLP ? Config.liquidityDecimals : token!.decimals;
  }

  String get multiplier {
    return Fmt.numFixed(allocPoint / 10000, 1) + "x";
  }

  Decimal? _computeRewardUsd(
    BigInt? totalRewardCurrentBlock,
    int? totalFarmAllocPoint,
    List<LiquidityModel> liquidityList,
  ) {
    if (totalRewardCurrentBlock == null ||
        totalFarmAllocPoint == null ||
        totalFarmAllocPoint == 0 ||
        liquidityList
                .indexWhere((e) => e.currencyIds.contains(Config.USDtokenId)) ==
            -1) {
      return null;
    }
    BigInt rewardCurrentBlock = BigInt.parse(
        (Decimal.fromBigInt(totalRewardCurrentBlock) *
                (Decimal.fromInt(allocPoint) /
                    Decimal.fromInt(totalFarmAllocPoint)))
            .toStringAsFixed(0));
    Decimal rewardAmountIn =
        Fmt.bigIntToDecimal(rewardCurrentBlock, Config.tokenDecimals);
    Decimal? rewardAmounUsd =
        calcuteTokenValOfUsd(liquidityList, rewardAmountIn, Config.tokenId);

    return rewardAmounUsd;
  }

  Decimal? computefarmPoolAmountUsd(
    List<LiquidityModel> liquidityList,
  ) {
    if (liquidityList
            .indexWhere((e) => e.currencyIds.contains(Config.USDtokenId)) ==
        -1) {
      return null;
    }

    Decimal? farmPoolAmountUsd;
    if (isLP) {
      if (liquidity!.totalIssuance == BigInt.zero) {
        return null;
      }
      Decimal percent = Decimal.fromBigInt(totalAmount) /
          Decimal.fromBigInt(liquidity!.totalIssuance);
      if (liquidity!.currencyIds.contains(Config.USDtokenId)) {
        BigInt amountUSD = liquidity!.currencyId1 == Config.USDtokenId
            ? liquidity!.token1Amount
            : liquidity!.token2Amount;
        farmPoolAmountUsd = Decimal.fromInt(2) *
            percent *
            Fmt.bigIntToDecimal(amountUSD, Config.USDtokenDecimals);
      } else {
        Decimal? token1AmountUsd = calcuteTokenValOfUsd(
            liquidityList,
            Fmt.bigIntToDecimal(liquidity!.token1Amount, liquidity!.decimals1),
            liquidity!.currencyId1);
        Decimal? token2AmountUsd = calcuteTokenValOfUsd(
            liquidityList,
            Fmt.bigIntToDecimal(liquidity!.token2Amount, liquidity!.decimals2),
            liquidity!.currencyId2);
        if ((token1AmountUsd == null || token1AmountUsd == Decimal.zero) &&
            token2AmountUsd != null &&
            token2AmountUsd != Decimal.zero) {
          farmPoolAmountUsd = Decimal.fromInt(2) * percent * token2AmountUsd;
        } else if ((token2AmountUsd == null ||
                token2AmountUsd == Decimal.zero) &&
            token1AmountUsd != null &&
            token1AmountUsd != Decimal.zero) {
          farmPoolAmountUsd = Decimal.fromInt(2) * percent * token1AmountUsd;
        } else if ((token2AmountUsd != null &&
                token2AmountUsd != Decimal.zero) &&
            token1AmountUsd != null &&
            token1AmountUsd != Decimal.zero) {
          farmPoolAmountUsd = token1AmountUsd + token2AmountUsd;
        }
      }
    } else {
      /// one token pool
      if (token!.currencyId == Config.USDtokenId) {
        farmPoolAmountUsd = Fmt.bigIntToDecimal(totalAmount, token!.decimals);
      } else {
        farmPoolAmountUsd = calcuteTokenValOfUsd(
            liquidityList,
            Fmt.bigIntToDecimal(totalAmount, token!.decimals),
            token!.currencyId);
      }
    }

    return farmPoolAmountUsd;
  }

  String apr(BigInt? totalRewardCurrentBlock, int? totalFarmAllocPoint,
      List<LiquidityModel> liquidityList, int blockDuration) {
    Decimal? rewardAmounUsd = _computeRewardUsd(
        totalRewardCurrentBlock, totalFarmAllocPoint, liquidityList);
    Decimal? farmPoolAmountUsd = computefarmPoolAmountUsd(liquidityList);
    if (rewardAmounUsd == null || farmPoolAmountUsd == null) {
      return "~";
    }
    if (farmPoolAmountUsd == Decimal.zero) {
      return "999999%";
    }
    return Fmt.decimalFixed(
            Decimal.fromInt(100 * 365) *
                Decimal.parse((3600 * 24 / (blockDuration / 1000)).toString()) *
                rewardAmounUsd /
                farmPoolAmountUsd,
            1) +
        "%";
  }

  String roiOneDay(BigInt? totalRewardCurrentBlock, int? totalFarmAllocPoint,
      List<LiquidityModel> liquidityList, int blockDuration) {
    Decimal? rewardAmounUsd = _computeRewardUsd(
        totalRewardCurrentBlock, totalFarmAllocPoint, liquidityList);
    Decimal? farmPoolAmountUsd = computefarmPoolAmountUsd(liquidityList);
    if (rewardAmounUsd == null || farmPoolAmountUsd == null) {
      return "~";
    }
    if (farmPoolAmountUsd == Decimal.zero) {
      return "9999";
    }

    return Fmt.decimalFixed(
        Decimal.parse((3600 * 24 / (blockDuration / 1000)).toString()) *
            rewardAmounUsd /
            farmPoolAmountUsd,
        8);
  }

  List<LiquidityModel> _pathToLiquidityList(
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
  Decimal? calcuteTokenValOfUsd(List<LiquidityModel> liquidityList,
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

  Decimal? _calMidPriceForMulti(List<LiquidityModel> findLiquidityList,
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

  FarmPoolModel.fromJson(
      json, List<LiquidityModel> liquidityList, List<CurrencyModel> tokenList)
      : currencyId = json["currencyId"].toString(),
        accDicoPerShare = BigInt.parse(json["accDicoPerShare"].toString()),
        allocPoint = int.parse(json["allocPoint"].toString()),
        lastRewardBlock = int.parse(json["lastRewardBlock"].toString()),
        poolId = int.parse(json["poolId"].toString()),
        token = BigInt.parse(json["currencyId"].toString()) >=
                Config.liquidityFirstId
            ? null
            : tokenList.firstWhere(
                (e) => e.currencyId == json["currencyId"].toString()),
        liquidity = BigInt.parse(json["currencyId"].toString()) >=
                Config.liquidityFirstId
            ? liquidityList.firstWhere(
                (e) => e.liquidityId == json["currencyId"].toString())
            : null,
        myAmount = json["myAmount"] == null
            ? BigInt.zero
            : BigInt.parse(json["myAmount"].toString()),
        myRewardDebt = json["myRewardDebt"] == null
            ? BigInt.zero
            : BigInt.parse(json["myRewardDebt"].toString()),
        totalAmount = BigInt.parse(json["totalAmount"].toString());
}
