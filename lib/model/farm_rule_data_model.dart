class FarmRuleDataModel {
  int startBlock;
  int halvingPeriod;
  BigInt dicoPerBlock;

  FarmRuleDataModel.fromList(list)
      : startBlock = int.parse(list[0].toString()),
        halvingPeriod = int.parse(list[1].toString()),
        dicoPerBlock = BigInt.parse(list[2].toString());
}
