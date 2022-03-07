
class NewHeadsModel {
  String parentHash;
  String hash;
  int number;
  NewHeadsModel({required this.parentHash,required this.hash,required this.number});
  NewHeadsModel.fromJson(json):
  parentHash=json['parentHash'],
  hash=json['hash'],
  number=json['number'];

}