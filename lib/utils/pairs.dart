import 'package:decimal/decimal.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/liquidity_model.dart';
import 'package:dicolite/utils/format.dart';

class Pairs {
  CurrencyModel tokenA;
  CurrencyModel tokenB;

  List<LiquidityModel> liquidityList;

  Pairs({
    required this.tokenA,
    required this.tokenB,
    required this.liquidityList,
  });

  bool get noLiquidity {
    int index = liquidityList.indexWhere((e) =>
        (e.currencyId1 == tokenA.currencyId &&
            e.currencyId2 == tokenB.currencyId) ||
        (e.currencyId1 == tokenB.currencyId &&
            e.currencyId2 == tokenA.currencyId));
    if (index != -1) {
      LiquidityModel item = liquidityList[index];
      if (item.token2Amount == BigInt.zero ||
          item.token1Amount == BigInt.zero) {
        return true;
      }
    }
    return index == -1;
  }

  LiquidityModel? get liquidity {
    if (!noLiquidity) {
      return liquidityList.firstWhere((e) =>
          (e.currencyId1 == tokenA.currencyId &&
              e.currencyId2 == tokenB.currencyId) ||
          (e.currencyId1 == tokenB.currencyId &&
              e.currencyId2 == tokenA.currencyId));
    }
    return null;
  }

  bool get isTokenAEqualToken1 {
    return liquidity!.currencyId1 == tokenA.currencyId;
  }

  CurrencyModel get token1 {
    return isTokenAEqualToken1 ? tokenA : tokenB;
  }

  CurrencyModel get token2 {
    return isTokenAEqualToken1 ? tokenB : tokenA;
  }

  String priceOf(bool isTokenA) {
    if (noLiquidity) return "~";
    isTokenA = isTokenA ? isTokenAEqualToken1 : !isTokenAEqualToken1;
    if (isTokenA) {
      /// token2 per token1
      return Fmt.decimalFixed(Fmt.bigIntToDecimal(liquidity!.token2Amount, token2.decimals) /
              Fmt.bigIntToDecimal(liquidity!.token1Amount, token1.decimals),5);
    } else {
      /// tokenA per tokenB
      return Fmt.decimalFixed(Fmt.bigIntToDecimal(liquidity!.token1Amount, token1.decimals) /
              Fmt.bigIntToDecimal(liquidity!.token2Amount, token2.decimals),5);
    }
  }

  String? calToken2Amount(String tokenAAmount) {
    tokenAAmount = tokenAAmount.trim();
    if (noLiquidity || tokenAAmount.isEmpty) {
      return null;
    }
    Decimal val = Decimal.zero;
    if (isTokenAEqualToken1) {
      val = Decimal.parse(tokenAAmount) *
          (Fmt.bigIntToDecimal(liquidity!.token2Amount, token2.decimals) /
              Fmt.bigIntToDecimal(liquidity!.token1Amount, token1.decimals));
    } else {
      val = Decimal.parse(tokenAAmount) *
          (Fmt.bigIntToDecimal(liquidity!.token1Amount, token1.decimals) /
              Fmt.bigIntToDecimal(liquidity!.token2Amount, token2.decimals));
    }

    return Fmt.decimalFixed(val,token2.decimals);
  }

  String? calToken1Amount(String tokenBAmount) {
    tokenBAmount = tokenBAmount.trim();
    if (noLiquidity || tokenBAmount.isEmpty) {
      return null;
    }
    Decimal val = Decimal.zero;
    if (isTokenAEqualToken1) {
      val = Decimal.parse(tokenBAmount) *
          (Fmt.bigIntToDecimal(liquidity!.token1Amount, token1.decimals) /
              Fmt.bigIntToDecimal(liquidity!.token2Amount, token2.decimals));
    } else {
      val = Decimal.parse(tokenBAmount) *
          (Fmt.bigIntToDecimal(liquidity!.token2Amount, token2.decimals) /
              Fmt.bigIntToDecimal(liquidity!.token1Amount, token1.decimals));
    }
    return Fmt.decimalFixed(val,token1.decimals);
  }

  String shareOfRate(String tokenAAmount) {
    if (noLiquidity) {
      return "100%";
    }
    tokenAAmount = tokenAAmount.trim();

    if (tokenAAmount.isEmpty) {
      return "<0.01%";
    }
    double val = 0;
    if (isTokenAEqualToken1) {
      BigInt inAmount = Fmt.tokenInt(tokenAAmount, token1.decimals);
      val = BigInt.from(100) * inAmount / (inAmount + liquidity!.token1Amount);
    } else {
      BigInt inAmount = Fmt.tokenInt(tokenAAmount, token2.decimals);
      val = BigInt.from(100) * inAmount / (inAmount + liquidity!.token2Amount);
    }

    if (val < 0.01) {
      return "<0.01%";
    }
    return Fmt.numFixed(val,2) + "%";
  }
}
