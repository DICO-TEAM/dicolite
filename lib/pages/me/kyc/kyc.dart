import 'dart:convert';

import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/kyc_info_model.dart';
import 'package:dicolite/model/kyc_application_form_model.dart';
import 'package:dicolite/model/kyc_authentication_model.dart';
import 'package:dicolite/model/kyc_judgement_model.dart';
import 'package:dicolite/pages/me/kyc/add_kyc.dart';
import 'package:dicolite/pages/me/kyc/audit/kyc_ias_audit_list.dart';
import 'package:dicolite/pages/me/kyc/audit/kyc_sword_holder_audit_list.dart';
import 'package:dicolite/pages/me/kyc/certification.dart';
import 'package:dicolite/pages/me/kyc/request_judgement.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/kyc_info_widget.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Kyc extends StatefulWidget {
  Kyc(this.store);
  static final String route = '/me/kyc';
  final AppStore store;
  @override
  _KycState createState() => _KycState(store);
}

class _KycState extends State<Kyc> {
  _KycState(this.store);
  final AppStore store;
  List<KycApplicationFormModel> applicationformList = [];
  KycInfoModel? kycInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    var list = await webApi?.dico?.fetchKYCInfo();

    if (list != null && mounted) {
      setState(() {
        isLoading = false;
        kycInfo = KycInfoModel.fromJson(list[0]);
        applicationformList = (list[1] as List)
            .map((e) => KycApplicationFormModel.fromJson(e))
            .toList();
      });
    } else if (list == null && mounted) {
      setState(() {
        isLoading = false;
        kycInfo = null;
        applicationformList = [];
      });
    }
  }

  Future<void> _delete() async {
    TxConfirmParams args = TxConfirmParams(
      title: S.of(context).clear,
      module: 'kyc',
      call: 'clearKyc',
      detail: jsonEncode({}),
      params: [],
      onSuccess: (res) {
        globalKycInfoRefreshKey.currentState?.show();
      },
    );

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(Kyc.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    return Observer(builder: (_) {
      int decimals = store.settings!.networkState.tokenDecimals;
      String symbol = store.settings!.networkState.tokenSymbol;
      bool isIas = store.dico?.ias != null ? true : false;
      bool isSwordHolder = store.dico?.swordHolder != null ? true : false;

      return Scaffold(
        appBar: myAppBar(
          context,
          "KYC",
          actions: [
            isLoading || kycInfo != null
                ? Container()
                : IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AddKyc.route),
                    icon: Icon(Icons.add)),
            isIas
                ? IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(KycIasAuditList.route),
                    icon: Icon(Icons.manage_accounts))
                : Container(),
            isSwordHolder
                ? IconButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(KycSwordHolderAuditList.route),
                    icon: Icon(Icons.manage_accounts))
                : Container(),
          ],
        ),
        body: isLoading
            ? LoadingWidget()
            : RefreshIndicator(
                onRefresh: _getData,
                key: globalKycInfoRefreshKey,
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            dic.set_kyc,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Image.asset(
                            "assets/images/dico/arrow-forward.png",
                            height: Adapt.px(20),
                          ),
                          Text(
                            dic.applyCertification,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Image.asset(
                            "assets/images/dico/arrow-forward.png",
                            height: Adapt.px(20),
                          ),
                          Text(
                            dic.requestJudgement,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    kycInfo == null
                        ? NoData()
                        : Card(
                            margin: EdgeInsets.all(15),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dic.KYC_info,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      DropdownButton(
                                        underline: Container(),
                                        icon: Icon(Icons.more_vert,
                                            color: Colors.black54),
                                        onChanged: (v) {
                                          if (v == "delete") {
                                            showConfrim(
                                              context,
                                              Text(dic.clear_kyc),
                                              _delete,
                                              okText: dic.clear,
                                            );
                                          }
                                        },
                                        items: [
                                          DropdownMenuItem(
                                            child: Text(
                                              dic.clear,
                                              style:
                                                  TextStyle(color: Colors.pink),
                                            ),
                                            value: "delete",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  KycInfoWidget(kycInfo!),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pushNamed(
                                                    Certification.route),
                                            child: Text(dic.applyCertification,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    kycInfo == null
                        ? Container()
                        : Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: 4,
                                  height: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                dic.certificationList,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: Config.color333),
                              )
                            ],
                          ),
                    Column(
                        children: applicationformList
                            .map((KycApplicationFormModel e) => Row(
                                  key: Key(e.ias.fields),
                                  children: [
                                    Expanded(
                                      child: Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${dic.certification}: ${e.ias.fields}",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${e.progress}",
                                                    style: TextStyle(
                                                      color: e.progress ==
                                                              "Success"
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : e.progress ==
                                                                  "Failure"
                                                              ? Theme.of(
                                                                      context)
                                                                  .errorColor
                                                              : Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 35,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "IAS",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                      "${dic.fee}: ${Fmt.token(e.ias.fee, decimals)} $symbol"),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  AddressIcon(e.ias.account),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "${Fmt.address(e.ias.account)}",
                                                    style: TextStyle(
                                                        color: Colors.black26),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      kycInfo!.iasJudgement,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: kycInfo!
                                                                    .iasJudgement ==
                                                                judgementList[0]
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : judgementList
                                                                    .contains(
                                                                        kycInfo!
                                                                            .iasJudgement)
                                                                ? Theme.of(
                                                                        context)
                                                                    .errorColor
                                                                : Colors
                                                                    .black26,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dic.swordHolder,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                      "${dic.fee}: ${Fmt.token(e.swordHolder.fee, decimals)} $symbol"),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  AddressIcon(
                                                      e.swordHolder.account),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "${Fmt.address(e.swordHolder.account)}",
                                                    style: TextStyle(
                                                        color: Colors.black26),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      kycInfo!.swordHolderAuth,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: kycInfo!
                                                                    .swordHolderAuth ==
                                                                authenticationList[
                                                                    0]
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : authenticationList
                                                                    .contains(
                                                                        kycInfo!
                                                                            .swordHolderAuth)
                                                                ? Theme.of(
                                                                        context)
                                                                    .errorColor
                                                                : Colors
                                                                    .black26,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  e.progress == "Pending"
                                                      ? ElevatedButton(
                                                          style: ButtonStyle(
                                                              padding: MaterialStateProperty
                                                                  .all(EdgeInsets
                                                                      .all(5))),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                            RequestJudgement
                                                                .route,
                                                            arguments: e,
                                                          ),
                                                          child: Text(
                                                            dic.requestJudgement,
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList()),
                  ],
                ),
              ),
      );
    });
  }
}
