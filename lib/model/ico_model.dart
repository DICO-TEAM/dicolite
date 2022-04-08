class IcoModel {
  String desc;
  int? startTime;
  bool isAlreadyKyc;
  String initiator;

  /// decimals is USD
  BigInt totalUsdt;
  bool isTerminated;
  String projectName;
  String tokenSymbol;
  int decimals;
  int index;
  int alreadyreleaseProgress;
  String currencyId;
  String officialWebsite;
  int userIcoMaxTimes;
  bool isMustKyc;

  /// decimals is ico token
  BigInt totalIssuance;

  /// decimals is ico token
  BigInt totalCirculation;
  int icoDuration;

  /// decimals is ico token
  BigInt totalIcoAmount;

  /// decimals is exchange token
  BigInt totalUnrealeaseAmount;

  /// decimals is USD
  BigInt userMinAmount;

  /// decimals is USD
  BigInt userMaxAmount;

  ///exchangeToken id
  String exchangeToken;

  /// decimals is exchange token
  BigInt exchangeTokenTotalAmount;
  List<String> excludeArea;
  int lockProportion;
  int unlockDuration;

  /// decimals is ico token
  BigInt perDurationUnlockAmount;

  /// totalIcoAmount/exchangeTokenTotalAmount
  double rate;

  IcoModel.fromJson(json)
      : desc = json["desc"],
        startTime = json["startTime"],
        isAlreadyKyc = json["isAlreadyKyc"],
        initiator = json["initiator"],
        totalUsdt = BigInt.parse(json["totalUsdt"].toString()),
        isTerminated = json["isTerminated"],
        projectName = json["projectName"],
        tokenSymbol = json["tokenSymbol"],
        decimals = json["decimals"],
        index = json["index"],
        alreadyreleaseProgress = json["alreadyReleasedProportion"],
        currencyId = json["currencyId"].toString(),
        officialWebsite = json["officialWebsite"],
        userIcoMaxTimes = json["userIcoMaxTimes"],
        isMustKyc = json["isMustKyc"],
        totalIssuance = BigInt.parse(json["totalIssuance"].toString()),
        totalCirculation = BigInt.parse(json["totalCirculation"].toString()),
        icoDuration = json["icoDuration"],
        totalIcoAmount = BigInt.parse(json["totalIcoAmount"].toString()),
        totalUnrealeaseAmount =
            BigInt.parse(json["totalUnrealeaseAmount"]?.toString() ?? '0'),
        userMinAmount = BigInt.parse(json["userMinAmount"].toString()),
        userMaxAmount = BigInt.parse(json["userMaxAmount"].toString()),
        exchangeToken = json["exchangeToken"].toString(),
        exchangeTokenTotalAmount =
            BigInt.parse(json["exchangeTokenTotalAmount"].toString()),
        excludeArea = List<String>.from(json["excludeArea"]),
        lockProportion = json["lockProportion"],
        unlockDuration = json["unlockDuration"],
        rate = BigInt.parse(json["totalIcoAmount"].toString()) /
            BigInt.parse(json["exchangeTokenTotalAmount"].toString()),
        perDurationUnlockAmount =
            BigInt.parse(json["perDurationUnlockAmount"].toString());
}
