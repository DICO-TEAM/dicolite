import 'package:dicolite/model/farm_pool_extend_model.dart';
import 'package:dicolite/pages/swap/farms/roi_calculator.dart';
import 'package:dicolite/store/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AprPoolWidget extends StatelessWidget {
  AprPoolWidget(this.store, this.pool, {Key? key}) : super(key: key);
  final AppStore store;
  final FarmPoolExtendModel pool;
  final TextStyle valStyle =
      TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      int blockDuration = store.settings?.blockDuration ?? 0;
      String val = pool.apr(store.dico!.liquidityList ?? [], blockDuration);

      return Row(
        children: [
          Text(
            val,
            style: valStyle,
          ),
          val != "~" &&
                  pool.totalStakeAmount != BigInt.zero &&
                  !pool.isFinished(
                      store.dico!.newHeads?.number ?? 10000000000000)
              ? Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ROICalculator(
                              store,
                              pool: pool,
                            ))),
                    child: Icon(
                      Icons.calculate_outlined,
                    ),
                  ),
                )
              : Container(),
        ],
      );
    });
  }
}
