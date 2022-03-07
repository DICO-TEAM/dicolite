import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/lbp_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/widgets/lbp_chart.dart';
import 'package:dicolite/widgets/lbp_detail_widget.dart';
import 'package:dicolite/widgets/loading_widget.dart';

import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LbpDetail extends StatefulWidget {
  LbpDetail(this.store);
  static final String route = '/blp/LbpDetail';
  final AppStore store;

  @override
  _LbpDetail createState() => _LbpDetail(store);
}

class _LbpDetail extends State<LbpDetail> {
  _LbpDetail(this.store);

  final AppStore store;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _cancelLbp(LbpModel data) async {
    TxConfirmParams args = TxConfirmParams(
      title: S.of(context).cancel,
      module: 'lbp',
      call: 'exitLbp',
      detail: jsonEncode({
        "lbpId": data.lbpId,
      }),
      params: [
        data.lbpId,
      ],
    );

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(Home.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    LbpModel? lbp;
    String lbpId = ModalRoute.of(context)!.settings.arguments as String;

    return Observer(builder: (_) {
      int index =
          store.dico?.lbpPoolList?.indexWhere((e) => e.lbpId == lbpId) ?? -1;
      if (index != -1) {
        lbp = store.dico!.lbpPoolList![index];
      }

      return Scaffold(
        appBar: myAppBar(context, dic.detail, actions: [
          lbp == null ||
                  lbp!.isCancelled ||
                  lbp!.owner != store.account!.currentAddress
              ? Container()
              : TextButton(
                  onPressed: () => _cancelLbp(lbp!),
                  child: Text(
                    dic.exit,
                  ),
                ),
        ]),
        body: lbp == null
            ? LoadingWidget()
            : ListView(
                children: [
                  Container(height: 300, child: LbpChart(lbp!, store)),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: LbpDetailWidget(store, lbp!),
                  ),
                ],
              ),
      );
    });
  }
}
