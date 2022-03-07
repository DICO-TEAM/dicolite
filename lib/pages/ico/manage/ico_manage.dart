import 'dart:convert';

import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/ico_add_list_model.dart';
import 'package:dicolite/model/ico_model.dart';
import 'package:dicolite/pages/ico/manage/ico_pending.dart';
import 'package:dicolite/pages/ico/manage/ico_request_release.dart';
import 'package:dicolite/pages/ico/manage/ico_set_min_max_amount.dart';
import 'package:dicolite/pages/ico/manage/ico_set_usermax_times.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class IcoManage extends StatefulWidget {
  IcoManage(this.store);
  static final String route = '/ico/IcoManage';
  final AppStore store;

  @override
  _IcoManage createState() => _IcoManage(store);
}

class _IcoManage extends State<IcoManage> {
  _IcoManage(this.store);

  final AppStore store;
  List<IcoModel>? pendingList;

  @override
  void initState() {
    super.initState();
    _getPendingIcoData();
  }

  Future _getData() async {
    await webApi?.dico?.fetchAddedIcoList();
    await _getPendingIcoData();
  }

  Future _getPendingIcoData() async {
    List<IcoModel>? list = await webApi?.dico?.fetchPendingIco();
    if (list != null && mounted) {
      setState(() {
        pendingList = list;
      });
    }
  }

  Future _cancelIcoRequestRelease(IcoAddListModel data) async {
    TxConfirmParams args = TxConfirmParams(
        title: S.of(context).cancelRequestRelease,
        module: 'ico',
        call: 'cancelRequest',
        detail: jsonEncode({
          "currencyId": data.currencyId,
          "index": data.index,
        }),
        params: [
          data.currencyId,
          data.index,
        ],
        onSuccess: (res) {
          webApi?.dico?.fetchReleaseList();
        });

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(IcoManage.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Observer(builder: (_) {
      List<IcoAddListModel>? list = store.dico!.addedIcoList;
      if (list != null &&
          store.dico?.requestReleaseList != null &&
          store.dico!.requestReleaseList.isNotEmpty) {
        list = list.map((e) {
          if (store.dico!.requestReleaseList.indexWhere(
                  (x) => e.currencyId == x.currencyId && e.index == x.index) !=
              -1) {
            e.hasRequestRelease = true;
          } else {
            e.hasRequestRelease = false;
          }
          return e;
        }).toList();
      }
      return Scaffold(
        appBar: myAppBar(context, dic.manage),
        body: RefreshLoadmore(
          onRefresh: _getData,
          isLastPage: true,
          noMoreWidget: Text(''),
          child: Container(
            child: list == null
                ? Padding(
                    padding: const EdgeInsets.only(top: 148.0),
                    child: LoadingWidget(),
                  )
                : list.isEmpty
                    ? NoData()
                    : Column(
                        children: list
                            .map((e) => RoundedCard(
                                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "#${e.index} " + e.tokenSymbol),
                                            e.status == "Passed"
                                                ? DropdownButton(
                                                    underline: Container(),
                                                    icon: Icon(Icons.more_vert,
                                                        color: Colors.black54),
                                                    onChanged: (v) {
                                                      if (v == "userMaxTimes") {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                IcoSetUsermaxTimes
                                                                    .route,
                                                                arguments: e);
                                                      } else if (v ==
                                                          "userMinMaxAmount") {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                IcoSetMinMaxAmount
                                                                    .route,
                                                                arguments: e);
                                                      } else if (v ==
                                                              "icoRequestRelease" &&
                                                          e.status ==
                                                              "Passed") {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                IcoRequestRelease
                                                                    .route,
                                                                arguments: e);
                                                      } else if (v ==
                                                              "cancelIcoRequestRelease" &&
                                                          e.hasRequestRelease) {
                                                        _cancelIcoRequestRelease(
                                                            e);
                                                      }
                                                    },
                                                    items: [
                                                      DropdownMenuItem(
                                                        child: Text(
                                                          dic.changeUserIcoMaxTimes,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        ),
                                                        value: "userMaxTimes",
                                                      ),
                                                      DropdownMenuItem(
                                                        child: Text(
                                                          dic.changeUerMinMaxAmount,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        ),
                                                        value:
                                                            "userMinMaxAmount",
                                                      ),
                                                      DropdownMenuItem(
                                                        child: Text(
                                                          dic.requestRelease,
                                                          style: e.status ==
                                                                  "Passed"
                                                              ? Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2,
                                                        ),
                                                        value:
                                                            "icoRequestRelease",
                                                      ),
                                                      DropdownMenuItem(
                                                        child: Text(
                                                          dic.cancelRequestRelease,
                                                          style: e.hasRequestRelease
                                                              ? Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2,
                                                        ),
                                                        value:
                                                            "cancelIcoRequestRelease",
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Divider(),
                                        Wrap(
                                          children: [
                                            Text(e.desc),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    Fmt.token(
                                                        e.amount, e.decimals),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5!
                                                        .copyWith(
                                                            color: Color(
                                                                0xFFF5673A),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(
                                                    dic.totalIcoAmount,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                e.status,
                                                style: TextStyle(
                                                    fontSize: Adapt.px(40),
                                                    color: e.status == "Passed"
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : e.status == "Failed"
                                                            ? Config.errorColor
                                                            : Config.color333),
                                              ),
                                            ],
                                          ),
                                        ),
                                        detailWidget(dic, e),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
          ),
        ),
      );
    });
  }

  detailWidget(S dic, IcoAddListModel data) {
    if (pendingList == null || data.status == "Passed") {
      return Container();
    }
    int index = pendingList!.indexWhere(
        (e) => e.currencyId == data.currencyId && e.index == data.index);
    if (index == -1) {
      return Container();
    }
    IcoModel ico = pendingList![index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(
            IcoPending.route,
            arguments: ico,
          ),
          child: Text(dic.detail),
        ),
      ],
    );
  }
}
