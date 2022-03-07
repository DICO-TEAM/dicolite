class ExternalData {
  String imageHash="";
  String threshold="";

  ExternalData();
  ExternalData.fromJson(Map data) {
    this.imageHash = data['imageHash'];
    this.threshold = data['threshold'];
  }
}