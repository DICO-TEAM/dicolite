import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/liquidity_model.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dijkstra/dijkstra.dart';

class FarmPoolExtendModel {
  /// isLP int.parse(json["currencyId"].toString())>=Config.liquidityFirstId
  String rewardCurrencyId;
  BigInt rewardCurrencyAmount;
  String owner;
  int startBlock;
  int endBlock;
  BigInt rewardPerBlock;

  BigInt accRewardPerShare;
  String stakeCurrencyId;
  BigInt totalStakeAmount;

  int lastRewardBlock;

  LiquidityModel? rewardLiquidity;
  LiquidityModel? stakeLiquidity;

  CurrencyModel? rewardToken;
  CurrencyModel? stakeToken;
  int poolId;

  /// my amount
  BigInt myAmount;

  /// my reward debt
  BigInt myRewardDebt;

  bool get isLP {
    return BigInt.parse(rewardCurrencyId) >= Config.liquidityFirstId;
  }

  bool get isRewardLP {
    return BigInt.parse(rewardCurrencyId) >= Config.liquidityFirstId;
  }

  bool get isStakeLP {
    return BigInt.parse(stakeCurrencyId) >= Config.liquidityFirstId;
  }

  String get rewardSymbol {
    return isLP ? rewardLiquidity!.symbol : rewardToken!.symbol;
  }

  int get rewardDecimals {
    return isLP ? Config.liquidityDecimals : rewardToken!.decimals;
  }

  int get stakeDecimals {
    return isStakeLP ? Config.liquidityDecimals : stakeToken!.decimals;
  }

  String get stakeSymbol {
    return isStakeLP ? stakeLiquidity!.symbol : stakeToken!.symbol;
  }

  bool get isStaked {
    return myAmount != BigInt.zero;
  }

  bool isFinished(int currentBlock) {
    return endBlock < currentBlock;
  }

  FarmPoolExtendModel.fromJson(
      json, List<LiquidityModel> liquidityList, List<CurrencyModel> tokenList)
      : rewardCurrencyId = json["currencyId"].toString(),
        stakeCurrencyId = json["stakeCurrencyId"].toString(),
        owner = json["owner"].toString(),
        accRewardPerShare = BigInt.parse(json["accRewardPerShare"].toString()),
        lastRewardBlock = int.parse(json["lastRewardBlock"].toString()),
        poolId = int.parse(json["poolId"].toString()),
        startBlock = int.parse(json["startBlock"].toString()),
        endBlock = int.parse(json["endBlock"].toString()),
        rewardToken = BigInt.parse(json["currencyId"].toString()) >=
                Config.liquidityFirstId
            ? null
            : tokenList.firstWhere(
                (e) => e.currencyId == json["currencyId"].toString()),
        stakeToken = BigInt.parse(json["stakeCurrencyId"].toString()) >=
                Config.liquidityFirstId
            ? null
            : tokenList.firstWhere(
                (e) => e.currencyId == json["stakeCurrencyId"].toString()),
        rewardLiquidity = BigInt.parse(json["currencyId"].toString()) >=
                Config.liquidityFirstId
            ? liquidityList.firstWhere(
                (e) => e.liquidityId == json["currencyId"].toString())
            : null,
        stakeLiquidity = BigInt.parse(json["stakeCurrencyId"].toString()) >=
                Config.liquidityFirstId
            ? liquidityList.firstWhere(
                (e) => e.liquidityId == json["stakeCurrencyId"].toString())
            : null,
        myAmount = json["myAmount"] == null
            ? BigInt.zero
            : BigInt.parse(json["myAmount"].toString()),
        rewardCurrencyAmount = BigInt.parse(json["currencyAmount"].toString()),
        rewardPerBlock = BigInt.parse(json["rewardPerBlock"].toString()),
        myRewardDebt = json["myRewardDebt"] == null
            ? BigInt.zero
            : BigInt.parse(json["myRewardDebt"].toString()),
        totalStakeAmount = BigInt.parse(json["totalStakeAmount"].toString());

  Decimal? computefarmPoolExtendAmountUsd(
    List<LiquidityModel> liquidityList,
  ) {
    Decimal? farmPoolAmountUsd;
    if (isStakeLP) {
      if (liquidityList
              .indexWhere((e) => e.currencyIds.contains(Config.USDtokenId)) ==
          -1) {
        return null;
      }

      if (stakeLiquidity!.totalIssuance == BigInt.zero) {
        return null;
      }
      Decimal percent = Decimal.fromBigInt(totalStakeAmount) /
          Decimal.fromBigInt(stakeLiquidity!.totalIssuance);
      if (stakeLiquidity!.currencyIds.contains(Config.USDtokenId)) {
        BigInt amountUSDT = stakeLiquidity!.currencyId1 == Config.USDtokenId
            ? stakeLiquidity!.token1Amount
            : stakeLiquidity!.token2Amount;
        farmPoolAmountUsd = Decimal.fromInt(2) *
            percent *
            Fmt.bigIntToDecimal(amountUSDT, Config.USDtokenDecimals);
      } else {
        Decimal? token1AmountUsd = calcuteTokenValOfUsd(
            liquidityList,
            Fmt.bigIntToDecimal(
                stakeLiquidity!.token1Amount, stakeLiquidity!.decimals1),
            stakeLiquidity!.currencyId1);
        Decimal? token2AmountUsd = calcuteTokenValOfUsd(
            liquidityList,
            Fmt.bigIntToDecimal(
                stakeLiquidity!.token2Amount, stakeLiquidity!.decimals2),
            stakeLiquidity!.currencyId2);
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
          farmPoolAmountUsd = (token1AmountUsd + token2AmountUsd) * percent;
        }
      }
    } else {
      /// one token pool
      if (stakeToken!.currencyId == Config.USDtokenId) {
        farmPoolAmountUsd =
            Fmt.bigIntToDecimal(totalStakeAmount, stakeToken!.decimals);
      } else {
        if (liquidityList
                .indexWhere((e) => e.currencyIds.contains(Config.USDtokenId)) ==
            -1) {
          return null;
        }

        farmPoolAmountUsd = calcuteTokenValOfUsd(
            liquidityList,
            Fmt.bigIntToDecimal(totalStakeAmount, stakeToken!.decimals),
            stakeToken!.currencyId);
      }
    }

    return farmPoolAmountUsd;
  }

  ///Calcute value of usd
  Decimal? calcuteTokenValOfUsd(List<LiquidityModel> liquidityList,
      Decimal amountIn, String tokenInCurrencyId) {
    List<List> liquidityIdsList =
        liquidityList.map((e) => e.currencyIds).toList();
    List path = Dijkstra.findPathFromPairsList(
        liquidityIdsList, tokenInCurrencyId, Config.USDtokenId);
    if (BigInt.parse(tokenInCurrencyId) > Config.liquidityFirstId) {
      return null;
    }
    if (path.isEmpty) {
      return null;
    }
    List<Set> pathList = [];
    for (var i = 1; i < path.length; i++) {
      pathList.add(Set.from([path[i - 1], path[i]]));
    }
    Decimal? midPrice;
    try {
      List<LiquidityModel> findLiquidityList = pathList
          .map((Set e) => liquidityList
              .firstWhere((x) => x.currencyIds.toSet().containsAll(e)))
          .toList();
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

  Decimal? _computeRewardUsd(
    List<LiquidityModel> liquidityList,
  ) {
    if (isRewardLP &&
        liquidityList
                .indexWhere((e) => e.currencyIds.contains(Config.USDtokenId)) ==
            -1) {
      return null;
    }

    if (isRewardLP) {
      Decimal percent = Decimal.fromBigInt(rewardPerBlock) /
          Decimal.fromBigInt(rewardLiquidity!.totalIssuance);
      if (rewardLiquidity!.currencyIds.contains(Config.USDtokenId)) {
        BigInt amountUSDT = rewardLiquidity!.currencyId1 == Config.USDtokenId
            ? rewardLiquidity!.token1Amount
            : rewardLiquidity!.token2Amount;
        return Decimal.fromInt(2) *
            percent *
            Fmt.bigIntToDecimal(amountUSDT, Config.USDtokenDecimals);
      } else {
        Decimal? token1AmountUsd = calcuteTokenValOfUsd(
            liquidityList,
            Fmt.bigIntToDecimal(
                rewardLiquidity!.token1Amount, rewardLiquidity!.decimals1),
            rewardLiquidity!.currencyId1);
        Decimal? token2AmountUsd = calcuteTokenValOfUsd(
            liquidityList,
            Fmt.bigIntToDecimal(
                rewardLiquidity!.token2Amount, rewardLiquidity!.decimals2),
            rewardLiquidity!.currencyId2);
        Decimal? amountUsd;
        if ((token1AmountUsd == null || token1AmountUsd == Decimal.zero) &&
            token2AmountUsd != null &&
            token2AmountUsd != Decimal.zero) {
          amountUsd = Decimal.fromInt(2) * percent * token2AmountUsd;
        } else if ((token2AmountUsd == null ||
                token2AmountUsd == Decimal.zero) &&
            token1AmountUsd != null &&
            token1AmountUsd != Decimal.zero) {
          amountUsd = Decimal.fromInt(2) * percent * token1AmountUsd;
        } else if ((token2AmountUsd != null &&
                token2AmountUsd != Decimal.zero) &&
            token1AmountUsd != null &&
            token1AmountUsd != Decimal.zero) {
          amountUsd = (token1AmountUsd + token2AmountUsd) * percent;
        }
        return amountUsd;
      }
    } else {
      if (rewardCurrencyId == Config.USDtokenId) {
        return Fmt.bigIntToDecimal(rewardPerBlock, rewardDecimals);
      } else {
        if (liquidityList
                .indexWhere((e) => e.currencyIds.contains(Config.USDtokenId)) ==
            -1) {
          return null;
        }
        Decimal rewardAmountIn =
            Fmt.bigIntToDecimal(rewardPerBlock, rewardDecimals);
        Decimal? rewardAmounUsd = calcuteTokenValOfUsd(
            liquidityList, rewardAmountIn, rewardCurrencyId);

        return rewardAmounUsd;
      }
    }
  }

  String apr(List<LiquidityModel> liquidityList, int blockDuration) {
    Decimal? rewardAmounUsd = _computeRewardUsd(liquidityList);
    Decimal? farmPoolAmountUsd = computefarmPoolExtendAmountUsd(liquidityList);
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

  String roiOneDay(List<LiquidityModel> liquidityList, int blockDuration) {
    Decimal? rewardAmounUsd = _computeRewardUsd(liquidityList);
    Decimal? farmPoolAmountUsd = computefarmPoolExtendAmountUsd(liquidityList);
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
}
