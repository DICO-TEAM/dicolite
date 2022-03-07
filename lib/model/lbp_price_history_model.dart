import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/model/lbp_model.dart';
import 'package:dicolite/utils/format.dart';

class LbpPriceHistoryModel {
  int block;
  Decimal afsAmount;
  Decimal fundraisingAmount;
  Decimal afsWeight;
  Decimal fundraisingWeight;

  int blockDuration;
  int nowBlock;
  DateTime nowTime;


  ///( quotedOutput-midPrice)/quotedOutput
  // *******************************************************************************************//
  //  calc_spot_price                                                                           //
  //  sP = spot_price                                                                           //
  //  bI = asset_balance_in              ( bI / wI )         1                                  //
  //  bO = asset_balance_out       sP =  -----------  *  ----------                             //
  //  wI = asset_weight_in               ( bO / wO )     ( 1 - sF )                             //
  //  wO = asset_weight_out                                                                     //
  //  sF = swap_fee = 0                                                                         //
  // *******************************************************************************************//
  double get price {
    return double.parse(Fmt.decimalFixed( (fundraisingAmount/fundraisingWeight)/ (afsAmount/afsWeight) , 6));
  }

  DateTime get time {
    int mins = Fmt.blockToMin(nowBlock - block, blockDuration);
    return nowTime.subtract(Duration(minutes: mins)).toLocal();
  }

  LbpPriceHistoryModel.fromList(List list, LbpModel lbp, int blockDuration,
      int nowBlock, DateTime nowTime)
      : block = list[0],
        afsAmount = Fmt.bigIntToDecimal(
            BigInt.parse(list[1].toString()), lbp.afsToken.decimals),
        fundraisingAmount = Fmt.bigIntToDecimal(
            BigInt.parse(list[2].toString()), lbp.fundraisingToken.decimals),
        afsWeight = Fmt.bigIntToDecimal(BigInt.parse(list[3].toString()),Config.lbpWeightDecimals),
        fundraisingWeight = Fmt.bigIntToDecimal(BigInt.parse(list[4].toString()),Config.lbpWeightDecimals),
        blockDuration = blockDuration,
        nowBlock = nowBlock,
        nowTime = nowTime;
}
