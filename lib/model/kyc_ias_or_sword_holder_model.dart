

class KycIasOrSwordHolderModel {
  String account;
  BigInt fee;
  String curvePublicKey;
  String fields;

  KycIasOrSwordHolderModel.fromJson(json)
      : account = json["account"],
        fee = BigInt.parse(json["fee"].toString()),
        curvePublicKey = json["curvePublicKey"],
        fields = json["fields"];
}
