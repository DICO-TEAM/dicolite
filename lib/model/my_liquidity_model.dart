import 'package:dicolite/model/liquidity_model.dart';
import 'package:dicolite/model/token_balance_model.dart';
import 'package:dicolite/utils/format.dart';

class MyLiquidityModel {
  LiquidityModel liquidity;
  TokenBalanceModel balance;
  bool showDetail = false;

  BigInt get myToken1Amount {
    return BigInt.from(
        liquidity.token1Amount * balance.free / liquidity.totalIssuance);
  }

  BigInt get myToken2Amount {
    return BigInt.from(
        liquidity.token2Amount * balance.free / liquidity.totalIssuance);
  }

  String get shareRate {
   
    return Fmt.numFixed((balance.free / liquidity.totalIssuance)*100,4);
  }

  MyLiquidityModel(this.liquidity, this.balance);
}
