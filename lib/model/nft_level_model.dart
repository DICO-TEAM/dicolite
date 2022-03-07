enum NftLevelModel {
  Rookie,
  Angle,
  WallStreetElite,
  UnicornHunter,
  Mafia,
  GrandMaster,
  Other
}

List<String> nftLevelModelList =NftLevelModel.values.map((e) => e.toString().split(".")[1]).toList();
// List<String> NftLevelModelList = [NftLevelModel.Rookie.toString().split(".")[1]];
