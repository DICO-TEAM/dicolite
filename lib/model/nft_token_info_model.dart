import 'package:dicolite/config/config.dart';

class NftTokenInfoModel {
  String metadata;
  String owner;
  _TokenData data;
  String? seller;
  String? tokenId;
  BigInt? price;
  int? startBlock;

  String get imageUrl {
    return Config.nftImageUrl + data.imageHash;
  }

  String get level {
    int index = Config.nftList.indexWhere((x) => x[3] == data.classId);
    if (index == -1) return "other";
    return Config.nftList[index][0];
  }

  NftTokenInfoModel.fromJson(json)
      : metadata = json["metadata"].toString(),
        owner = json["owner"].toString(),
        data = _TokenData.fromJson(json["data"]),
        seller = json["seller"] != null ? json["seller"].toString() : null,
        tokenId = json["tokenId"] != null ? json["tokenId"].toString() : null,
        price = json["price"] != null
            ? BigInt.parse(json["price"].toString())
            : null,
        startBlock = json["startBlock"] != null
            ? int.parse(json["startBlock"].toString())
            : null;

  Map<String, dynamic> toJson() => {
        "metadata": metadata,
        "owner": owner,
        "data": data.toJson(),
        "seller": seller,
        "tokenId": tokenId,
        "price": price != null ? price.toString() : null,
        "startBlock": startBlock,
      };
}

class _TokenData {
  String classId;
  String hash;
  BigInt powerThreshold;
  BigInt claimPayment;
  String attribute;
  String imageHash;

  /// "Vec<(AccountId, Balance)>",
  List sellRecords;
  _Status status;

  _TokenData.fromJson(json)
      : classId = json["classId"].toString(),
        hash = json["hash"].toString(),
        powerThreshold = BigInt.parse(json["powerThreshold"].toString()),
        claimPayment = BigInt.parse(json["claimPayment"].toString()),
        attribute = json["attribute"].toString(),
        imageHash = json["imageHash"].toString(),
        sellRecords = json["sellRecords"],
        status = _Status.fromJson(json["status"]);

  Map<String, dynamic> toJson() => {
        "classId": classId,
        "hash": hash,
        "powerThreshold": powerThreshold.toString(),
        "claimPayment": claimPayment.toString(),
        "attribute": attribute,
        "imageHash": imageHash,
        "sellRecords": sellRecords,
        "status": status.toJson(),
      };
}

class _Status {
  bool isInSale = false;
  bool isActiveImage = false;
  bool isClaimed = false;

  _Status.fromJson(json)
      : isInSale = json["isInSale"],
        isActiveImage = json["isActiveImage"],
        isClaimed = json["isClaimed"];

  Map<String, dynamic> toJson() => {
        "isInSale": isInSale,
        "isActiveImage": isActiveImage,
        "isClaimed": isClaimed,
      };
}
