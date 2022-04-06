import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/pages/lbp/add_lbp.dart';
import 'package:dicolite/pages/lbp/lbp_exchange.dart';
import 'package:dicolite/pages/lbp/manage_lbp.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Lbp extends StatefulWidget {
  Lbp(this.store);
  final AppStore store;
  @override
  _LbpState createState() => _LbpState(store);
}

class _LbpState extends State<Lbp>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  _LbpState(this.store);
  final AppStore store;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  Future _onRefresh() async {
    await webApi?.dico?.subLbpPoolsChange();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    S dic = S.of(context);
    return Observer(builder: (_) {
      if (store.account!.currentAccountPubKey.isEmpty) {
        return Scaffold(
          body: Center(
            child: LoadingWidget(),
          ),
        );
      }
      return Scaffold(
        body: RefreshIndicator(
          key: globalLbpRefreshKey,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                leading: Text(""),
                systemOverlayStyle: SystemUiOverlayStyle.light,
                expandedHeight: 180,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      color: Config.bgColor,
                      image: DecorationImage(
                          image: AssetImage("assets/images/dico/lbp-bg.jpg"),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                actions: [
                  store.dico?.lbpPoolsMy != null &&
                          store.dico!.lbpPoolsMy!.isNotEmpty
                      ? IconButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(ManageLbp.route),
                          icon: Icon(
                            Icons.manage_accounts,
                            color: Colors.white,
                          ))
                      : Container(),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AddLbp.route),
                    icon: Image.asset(
                      "assets/images/dico/add.png",
                      width: 21,
                    ),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      child: store.dico?.lbpPoolList == null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 125),
                              child: LoadingWidget(),
                            )
                          : store.dico!.lbpPoolsInProgress!.isEmpty
                              ? Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: 125),
                                          child: NoData()),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: store.dico!.lbpPoolsInProgress!
                                      .map((e) => GestureDetector(
                                            key: Key(e.lbpId),
                                            onTap: () => Navigator.of(context)
                                                .pushNamed(LbpExchange.route,
                                                    arguments: e.lbpId),
                                            child: RoundedCard(
                                              margin: EdgeInsets.fromLTRB(
                                                  15, 15, 15, 0),
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("# " + e.lbpId),
                                                      Text(e.status),
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
                                                              dic.afsAsset)),
                                                      Text(e.afsToken.symbol),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Logo(
                                                          currencyId:
                                                              e.afsToken.currencyId,
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
                                                          child: Text(dic
                                                              .fundraisingAsset)),
                                                      Text(e.fundraisingToken
                                                          .symbol),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Logo(
                                                          currencyId: e
                                                              .fundraisingToken
                                                              .currencyId,
                                                          size: 25)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
