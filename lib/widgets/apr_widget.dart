import 'package:dicolite/model/farm_pool_model.dart';
import 'package:dicolite/pages/swap/farms/roi_calculator.dart';
import 'package:dicolite/store/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AprWidget extends StatelessWidget {
  AprWidget(this.store, this.farm, {Key? key}) : super(key: key);
  final AppStore store;
  final FarmPoolModel farm;
  final TextStyle valStyle =
      TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
      
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      int blockDuration = store.settings?.blockDuration??0;
      String val = farm.apr(
          store.dico!.totalFarmRewardCurrentBlock,
          store.dico!.totalFarmAllocPoint,
          store.dico!.liquidityList ?? [],
          blockDuration);

      return Row(
        children: [
          Text(
            val,
            style: valStyle,
          ),
          val != "~" && farm.totalAmount != BigInt.zero && !farm.isFinished
              ? Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ROICalculator( store,farm:farm))),
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
