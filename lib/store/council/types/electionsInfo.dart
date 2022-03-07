class ElectionsInfo extends _ElectionsInfo {
  static ElectionsInfo fromJson(Map<String, dynamic> json) {
    ElectionsInfo data = ElectionsInfo()
      ..candidacyBond = json['candidacyBond']
      ..candidateCount = json['candidateCount']
      ..desiredSeats = json['desiredSeats']
      ..termDuration = json['termDuration'];
    return data;
  }

  Map toJson() {
    Map res = {};
    res['candidacyBond'] = this.candidacyBond;
    res['candidateCount'] = this.candidacyBond;
    res['desiredSeats'] = this.candidacyBond;
    res['termDuration'] = this.candidacyBond;
    return res;
  }
}

abstract class _ElectionsInfo {
  int candidacyBond = 0;
  int candidateCount = 0;
  int desiredSeats = 0;
  int termDuration = 0;
}
