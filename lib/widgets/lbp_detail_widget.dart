import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/lbp_model.dart';
import 'package:dicolite/store/app.dart';
import 'package:flutter/material.dart';

import 'package:dicolite/config/config.dart';
import 'package:dicolite/utils/format.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

class LbpDetailWidget extends StatelessWidget {
  LbpDetailWidget(this.store, this.lbpPool, {Key? key}) : super(key: key);
  final AppStore store;
  final LbpModel lbpPool;

  final TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("# ${lbpPool.lbpId}"),
            SizedBox(
              width: 4,
            ),
            Text(
              lbpPool.status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: lbpPool.status == "InProgress"
                    ? Theme.of(context).primaryColor
                    : Config.color333,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Observer(builder: (_) {
          int blockTime = store.settings?.blockDuration ?? 0;
          if (store.dico?.newHeads?.number == null) {
            return Container();
          }
          int now = store.dico?.newHeads?.number ?? 0;
          return lbpPool.endBlock - now <= 0
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dic.timeLeft,
                    ),
                    Text(
                      Fmt.blockToTime(lbpPool.endBlock - now, blockTime),
                      style: boldStyle.copyWith(color: Colors.deepOrange),
                    )
                  ],
                );
        }),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dic.steps,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              "${lbpPool.currenStep}/${lbpPool.steps}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dic.initial,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Fmt.token(lbpPool.initialAfsBalance, lbpPool.afsToken.decimals) +
                  " " +
                  lbpPool.afsToken.symbol,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
            Text(
              Fmt.token(lbpPool.initialFundraisingBalance,
                      lbpPool.fundraisingToken.decimals) +
                  " " +
                  lbpPool.fundraisingToken.symbol,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${dic.weights}: ${Fmt.token(lbpPool.initialAfsStartWeight, Config.lbpWeightDecimals)} ${dic.to} ${Fmt.token(lbpPool.initialAfsEndWeight, Config.lbpWeightDecimals)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
            Text(
              "${dic.weights}: ${Fmt.token(lbpPool.initialFundraisingStartWeight, Config.lbpWeightDecimals)} ${dic.to} ${Fmt.token(lbpPool.initialFundraisingEndWeight, Config.lbpWeightDecimals)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dic.now,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Fmt.token(lbpPool.afsBalance, lbpPool.afsToken.decimals) +
                  " " +
                  lbpPool.afsToken.symbol,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
            Text(
              Fmt.token(lbpPool.fundraisingBalance,
                      lbpPool.fundraisingToken.decimals) +
                  " " +
                  lbpPool.fundraisingToken.symbol,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dic.weights +
                  ": " +
                  Fmt.token(lbpPool.afsWeight, Config.lbpWeightDecimals),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
            Text(
              dic.weights +
                  ": " +
                  Fmt.token(
                      lbpPool.fundraisingWeight, Config.lbpWeightDecimals),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
