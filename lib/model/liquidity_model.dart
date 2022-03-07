class LiquidityModel {
  List<String> currencyIds;
  String liquidityId;
  String currencyId1;
  String symbol1;
  int decimals1;

  String currencyId2;
  String symbol2;
  int decimals2;
  BigInt token1Amount;
  BigInt token2Amount;
  BigInt totalIssuance;

  bool showDetail=false;

 String get symbol{
    return symbol1+"-"+symbol2;
  }

  LiquidityModel.fromList(list)
      : currencyIds = [list[0]["currencyId"].toString(), list[1]["currencyId"].toString()],
        currencyId1 = list[0]["currencyId"].toString(),
        symbol1 = list[0]['metadata']['symbol'].toString(),
        decimals1 = list[0]['metadata']['decimals'],
        currencyId2 = list[1]["currencyId"].toString(),
        symbol2 = list[1]['metadata']['symbol'].toString(),
        decimals2 = list[1]['metadata']['decimals'],
        token1Amount = BigInt.parse(list[2].toString()),
        token2Amount = BigInt.parse(list[3].toString()),
        liquidityId = list[4].toString(),
        totalIssuance = BigInt.parse(list[5].toString());
}
