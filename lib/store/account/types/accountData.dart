import 'package:json_annotation/json_annotation.dart';

part 'accountData.g.dart';

@JsonSerializable()
class AccountData extends _AccountData {
  static AccountData fromJson(Map<String, dynamic> json) =>
      AccountData()
    ..name = json['name'] as String?
    ..address = json['address'] as String
    ..encoded = json['encoded'] as String?
    ..pubKey = json['pubKey'] as String
    ..encoding = json['encoding'] as Map<String, dynamic>?
    ..meta = json['meta'] as Map<String, dynamic>?
    ..memo = json['memo'] as String?
    ..observation = json['observation'] as bool? ?? false;

  static Map<String, dynamic> toJson(AccountData acc) =>
      _$AccountDataToJson(acc);
}

abstract class _AccountData {
  String? name = '';
  String address = '';
  String? encoded = '';
  String pubKey = '';

  Map<String, dynamic>? encoding = Map<String, dynamic>();
  Map<String, dynamic>? meta = Map<String, dynamic>();

  String? memo = '';
  bool observation = false;
}
