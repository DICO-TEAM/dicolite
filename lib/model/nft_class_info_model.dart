class NftClassInfoModel {
  String metadata;
  BigInt totalIssuance;
  String issuer;

  _ClassData data;

  NftClassInfoModel.fromJson(json)
      : metadata = json["metadata"].toString(),
        totalIssuance = BigInt.parse(json["totalIssuance"].toString()),
        issuer = json["issuer"].toString(),
        data = _ClassData.fromJson(json["data"]);
}

class _ClassData {
  String level;
  BigInt powerThreshold;
  BigInt claimPayment;
  String imagesHash;
  int maximumQuantity;
  _ClassData.fromJson(json)
      : level = json["level"].toString(),
        powerThreshold = BigInt.parse(json["powerThreshold"].toString()),
        claimPayment = BigInt.parse(json["claimPayment"].toString()),
        imagesHash = json["imagesHash"].toString(),
        maximumQuantity = int.parse(json["maximumQuantity"].toString());
}
