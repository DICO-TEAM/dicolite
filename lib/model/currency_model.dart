import 'package:dicolite/config/config.dart';
import 'package:dicolite/model/token_balance_model.dart';

class CurrencyModel {
  String currencyId;
  String owner;
  String symbol;
  String name;
  int decimals;
  BigInt? totalIssuance;
  TokenBalanceModel tokenBalance;

  /// only used in lbp minFundraisingAmount
  BigInt? minFundraisingAmount;

  bool hasAdded = false;

  bool get isLP {
    return BigInt.parse(currencyId) >= Config.liquidityFirstId;
  }

  CurrencyModel(
      {required this.owner,
      required this.currencyId,
      required this.totalIssuance,
      required this.symbol,
      required this.name,
      required this.tokenBalance,
      required this.decimals});

  CurrencyModel.fromJson(json)
      : owner = json['owner'],
        currencyId = json['currencyId'].toString(),
        minFundraisingAmount = json['minFundraisingAmount'] != null
            ? BigInt.parse(json['minFundraisingAmount'].toString())
            : null,
        totalIssuance = json["totalIssuance"] != null
            ? BigInt.parse(json["totalIssuance"].toString())
            : null,
        tokenBalance = TokenBalanceModel.fromJson(json["tokenBalance"]),
        name = json['metadata']['name'],
        decimals = json['metadata']['decimals'],
        symbol = json['metadata']['symbol'];

  Map<String, dynamic> toJson() => {
        "currencyId": currencyId,
        "owner": owner,
        "metadata": {
          "name": name,
          "decimals": decimals,
          "symbol": symbol,
        },
        "totalIssuance": totalIssuance.toString(),
        "tokenBalance": tokenBalance.toJson()
      };
}
