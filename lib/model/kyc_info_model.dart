class KycInfoModel {
  BigInt deposit;

  _InfoModel info;
  List judgements;

  String get iasJudgement {
    if(judgements.isEmpty) return "";
    String val=(judgements[0]?[2] as Map).keys.toList()[0].toString();
    return val[0].toUpperCase() +val.substring(1);
  }

  String get swordHolderAuth {
    if(judgements.isEmpty) return "";
    String val=(judgements[0]?[3] as String);
    return val;
  }

  KycInfoModel.fromJson(json)
      : info = _InfoModel.fromJson(json['info']),
        deposit = BigInt.parse(json['deposit'].toString()),
        judgements = json['judgements'];
}

class _InfoModel {
  String name;
  String area;
  String curvePublicKey;
  String email;

  _InfoModel.fromJson(json)
      : name = json['name'],
        area = json['area'],
        curvePublicKey = json['curvePublicKey'],
        email = json['email'];
}
