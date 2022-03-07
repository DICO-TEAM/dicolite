
import 'package:decimal/decimal.dart';

class TransferData {

  int blockNum = 0;

  int blockTimestamp = 0;

  String extrinsicIndex = "";

  String fee = "";

  String from = "";
  String to = "";
  BigInt amount ;
  String hash = "";
  String module = "balances";
  bool success = true;

  String symbol;
  int decimal;
  String tokenId;

  TransferData.fromJson(json):
  blockNum=json['attributes']["block_id"],
  blockTimestamp=DateTime.parse(json['attributes']["datetime"]).millisecondsSinceEpoch,
  extrinsicIndex=json['id'],
  from=json['attributes']["sender"]["attributes"]["address"],
  to=json['attributes']["destination"]["attributes"]["address"],
  amount=BigInt.parse(Decimal.parse(json['attributes']["value"].toString().replaceAll(RegExp(r"\.0+$"), "")).toStringAsFixed(0)),
  hash=json['attributes']['hash'],
  symbol=json['attributes']['asset_info']['symbol'],
  decimal=json['attributes']['asset_info']['decimal'],
  tokenId=json['attributes']['asset_info']['id'].toString();
}
