class IcoRequestReleaseInfoModel {
  String who;
  String currencyId;
  int index;
  int requestTime;
  int percent;
  BigInt pledge;

  IcoRequestReleaseInfoModel.fromJson(json)
      : currencyId = json["currencyId"].toString(),
        who = json["who"],
        index = json["index"],
        requestTime = json["requestTime"],
        percent = json["percent"],
        pledge = BigInt.parse(json["pledge"].toString());
}
