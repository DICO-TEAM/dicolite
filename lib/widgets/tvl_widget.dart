import 'package:decimal/decimal.dart';
import 'package:dicolite/model/farm_pool_model.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TvlWidget extends StatelessWidget {
  TvlWidget(this.store, this.farm, {Key? key}) : super(key: key);
  final AppStore store;
  final FarmPoolModel farm;
  final TextStyle valStyle =
      TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Decimal? usd =
          farm.computefarmPoolAmountUsd(store.dico!.liquidityList ?? []);
      String val = "0";
      if (farm.totalAmount == BigInt.zero) {
        val = "0";
      } else if (usd == null) {
        val = "~";
      } else {
        val ="\$ "+ Fmt.doubleFormat(usd.toDouble(), length: 0);
      }
      return Text(
        val,
        style: valStyle,
      );
    });
  }
}
