import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dicolite/pages/me/assets/transfer/tx_detail.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/assets/types/transferData.dart';
import 'package:dicolite/utils/format.dart';


class TransferDetailPage extends StatelessWidget {
  TransferDetailPage(this.store);

  static final String route = '/me/assets/tx';
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
  

    final TransferData tx = ModalRoute.of(context)!.settings.arguments as TransferData;

    final String txType = tx.from == store.account!.currentAddress
        ? dic.transfer
        : dic.receive;

    return TxDetail(
      success: true,
      action: txType,
      eventId: tx.extrinsicIndex,
      hash: tx.hash,
      blockTime: DateFormat('yyyy-MM-dd HH:mm:ss').format( DateTime.fromMillisecondsSinceEpoch(tx.blockTimestamp ))
          .toString(),
      blockNum: tx.blockNum,
      networkName: store.settings!.endpoint.info,
      info: <DetailInfoItem>[
        DetailInfoItem(
          label: dic.value,
          title: '${Fmt.token(tx.amount, tx.decimal,length:5)} ${tx.symbol}',
        ),
        // DetailInfoItem(
        //   label: dic.fee,
        //   title:
        //       '${Fmt.balance(tx.fee,decimals, length: decimals)} $symbol',
        // ),
        DetailInfoItem(
          label: dic.from,
          title: Fmt.address(tx.from),
          address: tx.from,
        ),
        DetailInfoItem(
          label: dic.to,
          title: Fmt.address(tx.to),
          address: tx.to,
        )
      ],
    );
  }
}
