
class IcoUnreleaseAssetsModel {
  String currencyId;
  String? inviter;
  int index;
  String unreleasedCurrencyId;
  
  BigInt totalUsdt;

  /// for ico inviter decimals is exchange token;
  /// 
  /// for user decimals is ico token
  BigInt total;


  /// for ico inviter decimals is exchange token;
  /// 
  /// for user decimals is ico token
  BigInt released;

  List<BigInt> tags;

  /// decimals is ico token
  BigInt refund; 

  /// has get reward amount, decimals is DICO
  BigInt reward;

  IcoUnreleaseAssetsModel.fromJson(json)
      : currencyId = json["currencyId"].toString(),
        inviter = json["inviter"],
        index = json["index"],
        unreleasedCurrencyId = json["unreleasedCurrencyId"].toString(),
        totalUsdt = BigInt.parse(json["totalUsdt"].toString()),
        total = BigInt.parse(json["total"].toString()),
        released = BigInt.parse(json["released"].toString()),
        tags = (json["tags"] as List).map((e) => BigInt.parse(e[2].toString())).toList(),
        refund =BigInt.parse( (json["refund"]??"0").toString()),
        reward = BigInt.parse( (json["reward"]??"0").toString());
}
