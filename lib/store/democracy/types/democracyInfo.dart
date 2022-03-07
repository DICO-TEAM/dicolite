class DemocracyInfo {
  int publicPropCount=0;
  int referendumCount=0;
  int launchPeriod=0;

  DemocracyInfo();

  DemocracyInfo.fromJson(Map data) {
    this.publicPropCount = data['publicPropCount'];
    this.referendumCount = data['referendumCount'];
    this.launchPeriod = data['launchPeriod'];
  }
}