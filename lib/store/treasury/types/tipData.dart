class TipData {
  String? reason;
  String? reasonText;
  String? who;
  List? finder;
  int? closes;
  List? tips;

  TipData();

  TipData.fromJson(Map data) {
    this.reason = data['reason'];
    this.reasonText = data['reasonText'];
    this.who = data['who'];
    this.finder = data['finder'];
    this.closes = data['closes'];
    this.tips = data['tips'];
  }
}