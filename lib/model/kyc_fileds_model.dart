enum KycFiledsModel { Name, Area, CurvePubicKey, Email }

// List<String> kycFiledsModelList =KycFiledsModel.values.map((e) => e.toString().split(".")[1]).toList();
List<String> kycFiledsModelList = [
  KycFiledsModel.Area.toString().split(".")[1]
];
