import 'package:dicolite/model/currency_model.dart';

class LbpModel {
  String lbpId;

  int startBlock;
  int endBlock;
  int steps;
  String owner;
  String afsAsset;
  String fundraisingAsset;
  BigInt initialAfsBalance;
  BigInt initialFundraisingBalance;

  /// decimal is 10
  BigInt initialAfsStartWeight;

  /// decimal is 10
  BigInt initialAfsEndWeight;

  /// decimal is 10
  BigInt initialFundraisingStartWeight;

  /// decimal is 10
  BigInt initialFundraisingEndWeight;

  BigInt afsBalance;
  BigInt fundraisingBalance;

  /// decimal is 10
  BigInt afsWeight;

  /// decimal is 10
  BigInt fundraisingWeight;

  /// "Pending",
  /// "Cancelled",
  /// "InProgress",
  /// "Finished"
  String status;

  int _step;
  int nextBlock;

  CurrencyModel afsToken;
  CurrencyModel fundraisingToken;

  bool showDetail = false;

  int get currenStep {
    return _step > steps ? steps : _step;
  }

  bool get isFinished {
    return status == "Finished";
  }

  bool get isInProgress {
    return status == "InProgress";
  }

  bool get isPending {
    return status == "Pending";
  }

  bool get isCancelled {
    return status == "Cancelled";
  }

  LbpModel.fromJson(json, List<CurrencyModel> tokenList)
      : lbpId = json["lbpId"].toString(),
        startBlock = int.parse(json["startBlock"].toString()),
        endBlock = int.parse(json["endBlock"].toString()),
        steps = int.parse(json["steps"].toString()),
        owner = json["owner"],
        afsAsset = json["afsAsset"].toString(),
        fundraisingAsset = json["fundraisingAsset"].toString(),
        afsToken = tokenList
            .firstWhere((e) => e.currencyId == json["afsAsset"].toString()),
        fundraisingToken = tokenList.firstWhere(
            (e) => e.currencyId == json["fundraisingAsset"].toString()),
        initialAfsBalance = BigInt.parse(json["initialAfsBalance"].toString()),
        initialFundraisingBalance =
            BigInt.parse(json["initialFundraisingBalance"].toString()),
        initialAfsStartWeight =
            BigInt.parse(json["initialAfsStartWeight"].toString()),
        initialAfsEndWeight =
            BigInt.parse(json["initialAfsEndWeight"].toString()),
        initialFundraisingStartWeight =
            BigInt.parse(json["initialFundraisingStartWeight"].toString()),
        initialFundraisingEndWeight =
            BigInt.parse(json["initialFundraisingEndWeight"].toString()),
        afsBalance = BigInt.parse(json["afsBalance"].toString()),
        fundraisingBalance =
            BigInt.parse(json["fundraisingBalance"].toString()),
        afsWeight = BigInt.parse(json["afsWeight"].toString()),
        fundraisingWeight = BigInt.parse(json["fundraisingWeight"].toString()),
        status = json["status"],
        _step = int.parse(json["step"].toString()),
        nextBlock = int.parse(json["nextBlock"].toString());
}
