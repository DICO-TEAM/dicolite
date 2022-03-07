
class ReferendumInfo extends _ReferendumInfo {
  static ReferendumInfo fromJson(Map<String, dynamic> json, String address) {
    ReferendumInfo info = ReferendumInfo();
    info.index = BigInt.parse(json['index'].toString());
    info.imageHash = json['imageHash'];
    info.status = json['status'];
    info.image = json['image'];
    info.detail = json['detail'];

    info.isPassing = json['isPassing'];
    info.voteCountAye = json['voteCountAye'];
    info.voteCountNay = json['voteCountNay'];
    info.votedAye = json['votedAye'].toString();
    info.votedNay = json['votedNay'].toString();
    info.votedTotal = json['votedTotal'].toString();
    info.changeAye = info.detail['changes']['changeAye'].toString();
    info.changeNay = info.detail['changes']['changeNay'].toString();

    info.userVoted = info.detail['userVoted'];
    return info;
  }
}

abstract class _ReferendumInfo {
  BigInt index=BigInt.zero;
  String imageHash="";

  bool isPassing=false;
  int voteCountAye=0;
  int voteCountNay=0;
  String votedAye="";
  String votedNay="";
  String votedTotal="";
  String changeAye="";
  String changeNay="";

  Map<String, dynamic> status=Map();
  Map<String, dynamic>? image;
  Map<String, dynamic> detail=Map();

  Map<String, dynamic>? userVoted;
}
