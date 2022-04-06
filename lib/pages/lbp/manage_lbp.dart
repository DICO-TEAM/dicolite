
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/lbp_model.dart';
import 'package:dicolite/pages/lbp/lbp_detail.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/no_data.dart';

import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ManageLbp extends StatefulWidget {
  ManageLbp(this.store);
  static final String route = '/blp/ManageLbp';
  final AppStore store;

  @override
  _ManageLbp createState() => _ManageLbp(store);
}

class _ManageLbp extends State<ManageLbp> {
  _ManageLbp(this.store);

  final AppStore store;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Observer(builder: (_) {
      List<LbpModel>? list = store.dico!.lbpPoolsMy;
      int blockTime = widget.store.settings?.blockDuration??0;
      return Scaffold(
        appBar: myAppBar(context, dic.manage),
        body: Container(
          child: list == null
              ? Padding(
                  padding: const EdgeInsets.only(top: 148.0),
                  child: LoadingWidget(),
                )
              : list.isEmpty
                  ? NoData()
                  : ListView(
                      children: list
                          .map((e) => Card(
                                margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text("# ${e.lbpId}"),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  e.status,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        e.status == "InProgress"
                                                            ? Theme.of(context).primaryColor
                                                            : Config.color333,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          !e.isCancelled
                                              ? Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 7, 10, 7),
                                                  decoration: BoxDecoration(
                                                    color: e.isFinished
                                                        ? Theme.of(context)
                                                            .disabledColor
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.horizontal(
                                                      left: Radius.circular(50),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    e.isFinished
                                                        ? dic.finished
                                                        : e.isInProgress
                                                            ? Fmt.blockToTime(
                                                                e.endBlock -
                                                                    store
                                                                        .dico!
                                                                        .newHeads!
                                                                        .number,
                                                                blockTime)
                                                            : Fmt.blockToTime(
                                                                e.startBlock -
                                                                    store
                                                                        .dico!
                                                                        .newHeads!
                                                                        .number,
                                                                blockTime),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text(dic.afsAsset)),
                                                Text(e.afsToken.symbol),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Logo(
                                                    currencyId: e.afsToken.currencyId,
                                                    size: 25)
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        dic.fundraisingAsset)),
                                                Text(e.fundraisingToken.symbol),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Logo(
                                                    currencyId: e.fundraisingToken
                                                        .currencyId,
                                                    size: 25)
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                LbpDetail.route,
                                                                arguments:
                                                                    e.lbpId),
                                                  child: Text(dic.detail),
                                                ),
                                              ],
                                            ),
                                            
                                            
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
        ),
      );
    });
  }
}
