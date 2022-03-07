import 'package:dicolite/model/ico_model.dart';
import 'package:dicolite/model/ico_request_release_info_model.dart';

class DaoProposalModel {
  String? reason;
  String currencyId;
  String hash;

  /// ico index
  int icoIndex;

  /// bock time
  int end;

  /// percent to pass
  int threshold;

  BigInt ayesTotal;

  BigInt naysTotal;

  /// [addr,amount] decimal is ico token
  List<List> ayes;

  /// [addr,amount] decimal is ico token
  List<List> nays;

  /// Proposal index;
  int proposalIndex;

  ///  "permitRelease"
  String method;

  ///  "ico"
  String section;

  ///  ico data
  IcoModel? ico;

  ///  Ico request release info data
  IcoRequestReleaseInfoModel? icoRequestReleaseInfo;

  DaoProposalModel.fromJson(json)
      : currencyId = json["args"]["currency_id"].toString(),
        hash = json["hash"],
        reason = json["reason"],
        icoIndex = int.parse(json["args"]["index"].toString()),
        proposalIndex = json["index"],
        end = json["end"],
        threshold = json["threshold"],
        method = json["method"],
        section = json["section"],
        ayes = List<List>.from(json["ayes"]),
        nays = List<List>.from(json["nays"]),
        ayesTotal = (json["ayes"] as List).isNotEmpty
            ? (json["ayes"] as List)
                .map((e) => BigInt.parse(e[1].toString()))
                .toList()
                .reduce((a, b) => a + b)
            : BigInt.zero,
        naysTotal = (json["nays"] as List).isNotEmpty
            ? (json["nays"] as List)
                .map((e) => BigInt.parse(e[1].toString()))
                .toList()
                .reduce((a, b) => a + b)
            : BigInt.zero;
}
