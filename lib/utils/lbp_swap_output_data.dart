import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/model/lbp_model.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/utils/format.dart';

class LbpSwapOutputData {
  String? input;
  String? output;
  double slippage;

  LbpModel lbp;

  CurrencyModel tokenPay;
  CurrencyModel tokenRecieve;

  LbpSwapOutputData({
    required this.slippage,
    required this.tokenPay,
    required this.tokenRecieve,
    required this.lbp,
  });

//********************************************************************************************//
// calc_out_given_in                                                                          //
// aO = asset_amount_out                                                                      //
// bO = asset_balance_out                                                                     //
// bI = asset_balance_in               /      /            bI             \    (wI / wO) \    //
// aI = asset_amount_in     aO = bO * |  1 - | --------------------------  | ^            |   //
// wI = asset_weight_in                \      \ ( bI + ( aI * ( 1 - sF )) /              /    //
// wO = asset_weight_out                                                                       //
// sF = swap_fee                                                                              //
//********************************************************************************************//
  String? caltokenReceiveAmount(String tokenPayAmount) {
    tokenPayAmount = tokenPayAmount.trim();
    if (tokenPayAmount.isEmpty) {
      return "";
    }
    Decimal val = Decimal.zero;

    bool isTokenAfsEqualTokenPay = lbp.afsAsset == tokenPay.currencyId;
    Decimal balanceIn = Fmt.bigIntToDecimal(
        isTokenAfsEqualTokenPay ? lbp.afsBalance : lbp.fundraisingBalance,
        tokenPay.decimals);

    Decimal balanceOut = Fmt.bigIntToDecimal(
        isTokenAfsEqualTokenPay ? lbp.fundraisingBalance : lbp.afsBalance,
        tokenRecieve.decimals);
    Decimal amountIn = Decimal.parse(tokenPayAmount);

    if (amountIn >= balanceIn) {
      return null;
    }
    Decimal weightIn = Fmt.bigIntToDecimal(
        isTokenAfsEqualTokenPay ? lbp.afsWeight : lbp.fundraisingWeight,
        Config.lbpWeightDecimals);
    Decimal weightOut = Fmt.bigIntToDecimal(
        isTokenAfsEqualTokenPay ? lbp.fundraisingWeight : lbp.afsWeight,
        Config.lbpWeightDecimals);

    Decimal weightRatio = weightIn / weightOut;
    Decimal x = balanceIn /
        (balanceIn +
            (amountIn *
                (Decimal.fromInt(1) -
                    Decimal.parse(Config.lbpSwapfee.toString()))));
    Decimal y =
        Decimal.parse((pow(x.toDouble(), weightRatio.toDouble())).toString());
    val = balanceOut * (Decimal.fromInt(1) - y);

    if (val >= balanceOut) {
      return null;
    }
    return Fmt.decimalFixed(val, tokenRecieve.decimals);
  }

//********************************************************************************************//
// calc_in_given_out                                                                          //
// aI = asset_amount_in                                                                       //
// bO = asset_balance_out                  /  /     bO      \    (wO / wI)      \             //
// bI = asset_balance_in             bI * |  | ------------  | ^            - 1  |            //
// aO = asset_amount_out       aI =        \  \ ( bO - aO ) /                   /             //
// wI = asset_weight_in              --------------------------------------------             //
// wO = asset_weight_out                             ( 1 - sF )                               //
// sF = swap_fee                                                                              //
//********************************************************************************************//
  String? caltokenPayAmount(String tokenRecieveAmount) {
    tokenRecieveAmount = tokenRecieveAmount.trim();
    if (tokenRecieveAmount.isEmpty) {
      return "";
    }
    Decimal val = Decimal.zero;

    bool isTokenAfsEqualTokenPay = lbp.afsAsset == tokenPay.currencyId;
    Decimal balanceIn = Fmt.bigIntToDecimal(
        isTokenAfsEqualTokenPay ? lbp.afsBalance : lbp.fundraisingBalance,
        tokenPay.decimals);

    Decimal balanceOut = Fmt.bigIntToDecimal(
        isTokenAfsEqualTokenPay ? lbp.fundraisingBalance : lbp.afsBalance,
        tokenRecieve.decimals);
    Decimal amountOut = Decimal.parse(tokenRecieveAmount);

    Decimal weightIn = Fmt.bigIntToDecimal(
        isTokenAfsEqualTokenPay ? lbp.afsWeight : lbp.fundraisingWeight,
        Config.lbpWeightDecimals);
    Decimal weightOut = Fmt.bigIntToDecimal(
        isTokenAfsEqualTokenPay ? lbp.fundraisingWeight : lbp.afsWeight,
        Config.lbpWeightDecimals);

    if (amountOut >= balanceOut) {
      return null;
    }

    Decimal weightRatio = weightOut / weightIn;
    Decimal x = (balanceOut / (balanceOut - amountOut));
    Decimal y =
        Decimal.parse((pow(x.toDouble(), weightRatio.toDouble())).toString()) -
            Decimal.fromInt(1);
    val = balanceIn *
        y /
        (Decimal.fromInt(1) - Decimal.parse(Config.lbpSwapfee.toString()));

    if (val >= balanceIn) {
      return null;
    }
    return Fmt.decimalFixed(val, tokenPay.decimals);
  }

  String quote(String amountPay, String amountReceive) {
    bool isPayLessThanReceive =
        Decimal.parse(amountPay) < Decimal.parse(amountReceive);
    return Fmt.decimalFixed(
        Decimal.parse(amountPay) / Decimal.parse(amountReceive),
        isPayLessThanReceive ? 5 : 1);
  }

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
//   Decimal? computePriceImpact(String amountPay, String amountReceive) {
//     if (amountPay.trim().isEmpty ||
//         amountReceive.trim().isEmpty ||
//         Decimal.parse(amountPay.trim()) == Decimal.zero ||
//         Decimal.parse(amountReceive.trim()) == Decimal.zero) return null;
//     Decimal midPrice = Decimal.zero;

//     bool isTokenAfsEqualTokenPay = lbp.afsAsset == tokenPay.currencyId;
//     Decimal afsWeight=Fmt.bigIntToDecimal(lbp.afsWeight, Config.lbpWeightDecimals);
//     Decimal fundraisingWeight=Fmt.bigIntToDecimal(lbp.fundraisingWeight, Config.lbpWeightDecimals);
//     Decimal afsVal=Fmt.bigIntToDecimal(lbp.afsBalance, lbp.afsToken.decimals)/afsWeight;
//     Decimal fundraisingVal=Fmt.bigIntToDecimal(lbp.fundraisingBalance, lbp.fundraisingToken.decimals)/fundraisingWeight;
//     if (isTokenAfsEqualTokenPay) {
//       midPrice = afsVal/fundraisingVal;
//     } else {
//       midPrice =fundraisingVal/afsVal;
//     }

//     Decimal quotedOutput =Decimal.zero;
       
//  if (isTokenAfsEqualTokenPay) {
//       quotedOutput = ( Decimal.parse(amountPay)/afsWeight) /( Decimal.parse(amountReceive)/fundraisingWeight);
//     } else {
//       quotedOutput = ( Decimal.parse(amountPay)/fundraisingWeight) /( Decimal.parse(amountReceive)/afsWeight);
//     }
   
//     var priceImpact =
//         (quotedOutput - midPrice) * Decimal.fromInt(100) / quotedOutput;
//     return priceImpact;
//   }
}
