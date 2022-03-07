import 'package:dicolite/store/democracy/types/imageData.dart';

class ProposalData {
  int balance=0;
  List<dynamic> seconds=[];
  ImageData image=ImageData();
  String imageHash="";
  int index=0;
  String proposer="";
  Map detail=Map();

  ProposalData();

  ProposalData.fromJson(Map data) {
    this.balance = data['balance'];
    this.seconds = data['seconds'];

    ImageData img = ImageData.fromJson(data['image']);
    this.image = img;
    
    this.imageHash = data['imageHash'];
    this.index = data['index'];
    this.proposer = data['proposer'];
    this.detail = data['detail'];
  }

}