import 'package:dicolite/store/democracy/types/imageData.dart';
import 'package:dicolite/store/democracy/types/voteData.dart';

class ReferendumData {
  ImageData image=ImageData();
  String imageHash="";
  int index=0;
  Map status=Map();
  List<VoteData> allAye=[];
  List<VoteData> allNay=[];
  int voteCount=0;
  int voteCountAye=0;
  int voteCountNay=0;
  String votedAye="";
  String votedNay="";
  String votedTotal="";
  bool isPassing=false;
  List<VoteData> votes=[];
  Map detail=Map();

  ReferendumData();

  ReferendumData.fromJson(Map data) {
    this.image = ImageData.fromJson(data['image']);
    this.imageHash = data['imageHash'];
    this.index = data['index'];
    this.status = data['status'];

    List<VoteData> newAyes = [];
    try {
      for (Map item in data['allAye']) {
        VoteData v = VoteData.fromJson(item);
        newAyes.add(v);
      }
    } catch (e) { print('allAye' + e.toString()); }
    this.allAye = newAyes;

    List<VoteData> newNays = [];
    try {
      for (Map item in data['allNay']) {
        VoteData v = VoteData.fromJson(item);
        newNays.add(v);
      }
    } catch (e) { print('allNay' + e.toString()); }
    this.allNay = newNays;

    this.voteCount = data['voteCount'] ?? 0;
    this.voteCountAye = data['voteCountAye'] ?? 0;
    this.voteCountNay = data['voteCountNay'] ?? 0;
    this.votedAye = data['votedAye'].toString();
    this.votedNay = data['votedNay'].toString();
    this.votedTotal = data['votedTotal'].toString();
    this.isPassing = data['isPassing'];

    List<VoteData> newVotes = [];
    try {
      for (Map item in data['votes']) {
        VoteData v = VoteData.fromJson(item);
        newVotes.add(v);
      }
    } catch (e) { print('VoteData'+e.toString()); }
    this.votes = newVotes;
    this.detail = data['detail'];
  }

}