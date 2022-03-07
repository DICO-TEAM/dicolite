
import 'package:dicolite/model/kyc_ias_or_sword_holder_model.dart';

class KycApplicationFormModel {
  int iasIndex;
  KycIasOrSwordHolderModel ias;

  int swordHolderIndex;
  KycIasOrSwordHolderModel swordHolder;

  String? sender;
  String? message;

  ///"Pending",
  /// "IasDoing",
  /// "IasDone",
  /// "SwordHolderDone",
  /// "Success",
  /// "Failure"
  String progress;

  KycApplicationFormModel.fromJson(json)
      : ias = KycIasOrSwordHolderModel.fromJson(json['ias'][1]),
      iasIndex=json['ias'][0],
        progress = json['progress'],
        sender = json['sender'],
        message = json['message'],
        swordHolder = KycIasOrSwordHolderModel.fromJson(json['swordHolder'][1]),
        swordHolderIndex=json['swordHolder'][0];
  
}

