class TokenBalanceModel {
  BigInt free;
  BigInt reserved;
  BigInt frozen;
  BigInt total;

  TokenBalanceModel({ required this.free,required this.reserved,required this.frozen,required this.total});

  TokenBalanceModel.fromJson(json)
      : free = BigInt.parse(json["free"].toString()),
        reserved = BigInt.parse(json["reserved"].toString()),
        frozen = BigInt.parse(json["frozen"].toString()),
        total = BigInt.parse(json["free"].toString()) +
            BigInt.parse(json["reserved"].toString()) + 
            BigInt.parse(json["frozen"].toString());
            
  toJson() => {
        "free": free.toString(),
        "reserved": reserved.toString(),
        "frozen": frozen.toString(),
      };
}
