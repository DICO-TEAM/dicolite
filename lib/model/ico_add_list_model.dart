class IcoAddListModel {
  String desc;
  String currencyId;
  int index;
  String tokenSymbol;
  int decimals;

  /// "Checking",
  /// "Failed",
  /// "Passed"
  String status;
  BigInt amount;

  bool hasRequestRelease=false;

  IcoAddListModel.fromJson(json)
      : desc = json["desc"],
        currencyId = json["currencyId"].toString(),
        index = json["index"],
        status = json["status"],
        tokenSymbol = json["tokenSymbol"],
        decimals = json["decimals"],
        amount = BigInt.parse(json["amount"].toString());
}
