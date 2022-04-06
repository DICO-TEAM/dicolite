import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/dao_proposal_model.dart';
import 'package:dicolite/pages/dao/application_motion.dart';
import 'package:dicolite/pages/dao/dao_vote.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:dicolite/widgets/vote_rate_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Dao extends StatefulWidget {
  Dao(this.store);
  final AppStore store;
  @override
  _DaoState createState() => _DaoState(store);
}

class _DaoState extends State<Dao> with AutomaticKeepAliveClientMixin {
  _DaoState(this.store);
  AppStore store;
  Future _onRefresh() async {
    await webApi?.dico?.fetchReleaseList();
    await webApi?.dico?.fetchDaoProposeList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  _computeReleaseAmount(DaoProposalModel e) {
    if (e.icoRequestReleaseInfo == null) return BigInt.zero;
    return BigInt.from(
        (BigInt.parse(e.icoRequestReleaseInfo!.percent.toString()) *
                e.ico!.totalUnrealeaseAmount *
                e.ico!.totalIcoAmount /
                e.ico!.exchangeTokenTotalAmount) /
            100);
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
          key: globalDaoRefreshKey,
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
                          image: AssetImage("assets/images/dico/dao-bg.jpg"),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                actions: [
                  store.dico?.requestReleaseList != null &&
                          store.dico!.requestReleaseList.isNotEmpty
                      ? IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(ApplicationMotion.route),
                          icon: Image.asset(
                            "assets/images/dico/add.png",
                            width: 21,
                          ),
                        )
                      : Container()
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      child: store.dico?.daoProposalList == null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 125),
                              child: LoadingWidget(),
                            )
                          : store.dico!.daoProposalList!.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 125),
                                  child: NoData(),
                                )
                              : Column(
                                  children: store.dico!.daoProposalList!
                                      .map(
                                        (e) => GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(DaoVote.route,
                                                  arguments: e),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 15, 15, 0),
                                            child: RoundedCard(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 15, 15, 15),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Logo(
                                                        currencyId:
                                                            e.ico!.currencyId,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(e.ico!.projectName),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Divider(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        Fmt.token(
                                                            _computeReleaseAmount(
                                                                e),
                                                            e.ico!.decimals),
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
                                                        dic.requestRelease +
                                                            "(${e.ico!.tokenSymbol})",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2,
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 15.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              e.section +
                                                                  "." +
                                                                  e.method,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            Text(
                                                              dic.proposalType,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2,
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              e.icoRequestReleaseInfo!
                                                                      .percent
                                                                      .toString() +
                                                                  "%",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            Text(
                                                              dic.releaseProgress,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  VoteRateLine(e),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
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
