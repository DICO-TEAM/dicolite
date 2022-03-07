class IcoLockModel {
  int startBlock;
  int index;
  int unlockDuration;
  BigInt totalAmount;
  BigInt unlockAmount;
  BigInt perDurationUnlockAmount;

  IcoLockModel.fromJson(json):
  startBlock=json["startBlock"],
  index=json["index"],
  unlockDuration=json["unlockDuration"],
  totalAmount=BigInt.parse(json["totalAmount"].toString()),
  unlockAmount=BigInt.parse(json["unlockAmount"].toString()),
  perDurationUnlockAmount=BigInt.parse(json["perDurationUnlockAmount"].toString());
}
