import 'package:decimal/decimal.dart';
import 'package:dicolite/model/farm_pool_extend_model.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TvlPoolWidget extends StatelessWidget {
  TvlPoolWidget(this.store, this.pool, {Key? key}) : super(key: key);
  final AppStore store;
  final FarmPoolExtendModel pool;
  final TextStyle valStyle =
      TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Decimal? usd =
          pool.computefarmPoolExtendAmountUsd(store.dico!.liquidityList ?? []);
      String val = "0";
      if (pool.totalStakeAmount == BigInt.zero) {
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
