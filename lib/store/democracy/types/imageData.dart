class ImageData {
  int at=0;
  int balance=0;
  Map proposal=Map();
  String proposer="";

  ImageData();

  ImageData.fromJson(Map data) {
    this.at = data['at'];
    this.balance = data['balance'];
    this.proposal = data['proposal'];
    this.proposer = data['proposer'];
  }
}