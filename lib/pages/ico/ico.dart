import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/ico_model.dart';
import 'package:dicolite/pages/ico/add_ico.dart';
import 'package:dicolite/pages/ico/ico_participate.dart';
import 'package:dicolite/pages/ico/manage/ico_manage.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class Ico extends StatefulWidget {
  Ico(this.store);
  final AppStore store;
  @override
  _IcoState createState() => _IcoState(store);
}

class _IcoState extends State<Ico>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  _IcoState(this.store);
  AppStore store;

  TabController? controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);
  }

  Future<bool> _getData() async {
    await webApi?.dico?.fetchpassedIcoes();
    return true;
  }

  Widget mainWidget(int type) {
    S dic = S.of(context);
    List<IcoModel>? listData;
    switch (type) {
      case 0:
        listData = store.dico?.icoOngoingList;
        break;
      case 1:
        listData = store.dico?.icoComingUpList;
        break;
      case 2:
        listData = store.dico?.icoFinishedList;
        break;
      case 3:
        listData = store.dico?.participatedIcoList;
        break;
      default:
    }

    return Container(
      child: listData == null
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: LoadingWidget(),
            )
          : listData.isEmpty
              ? NoData()
              : ListView(
                  padding: EdgeInsets.all(0),
                  children: listData
                      .map(
                        (e) => GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(IcoParticipate.route, arguments: e),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                            child: RoundedCard(
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Logo(
                                            symbol: e.tokenSymbol,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            e.projectName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Wrap(
                                        children: [
                                          Text(e.desc),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Fmt.token(
                                                  e.totalIcoAmount, e.decimals),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    fontSize: Adapt.px(36),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(dic.totalIcoAmount,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            ((e.totalUnrealeaseAmount /
                                                            e.exchangeTokenTotalAmount) *
                                                        100)
                                                    .toStringAsFixed(1) +
                                                "%",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  fontSize: Adapt.px(36),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            dic.progressRate,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    S dic = S.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight =
        //statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight;
    return Observer(builder: (_) {
      if (store.account!.currentAccountPubKey.isEmpty) {
        return Scaffold(
          body: Center(
            child: LoadingWidget(),
          ),
        );
      }
      return Scaffold(
        body: PullToRefreshNotification(
          key: globalIcoRefreshKey,
          onRefresh: _getData,
          child: ExtendedNestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
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
                              image:
                                  AssetImage("assets/images/dico/ico-bg.jpg"),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      store.dico?.addedIcoList != null &&
                              store.dico!.addedIcoList!.isNotEmpty
                          ? IconButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(IcoManage.route),
                              icon: Icon(
                                Icons.manage_accounts,
                                color: Colors.white,
                              ))
                          : Container(),
                      IconButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed(AddIco.route),
                        icon: Image.asset(
                          "assets/images/dico/add.png",
                          width: 21,
                        ),
                      )
                    ],
                  ),
                  PullToRefreshContainer((info) {
                    Widget child = Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: info?.refreshWidget,
                    );

                    return SliverToBoxAdapter(
                      child: child,
                    );
                  }),
                  SliverList(
                    delegate: SliverChildListDelegate([]),
                  )
                ];
              },
              pinnedHeaderSliverHeightBuilder: () {
                return pinnedHeaderHeight;
              },
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 15, 8, 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      controller: controller,
                      indicator: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.white,
                      labelStyle: TextStyle(
                          fontSize: Adapt.px(26), fontWeight: FontWeight.w500),
                      isScrollable: true,
                      tabs: [
                        Tab(
                          text: dic.ongoing,
                        ),
                        Tab(
                          text: dic.coming,
                        ),
                        Tab(
                          text: dic.finished,
                        ),
                        Tab(
                          text: dic.participated,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      children: [
                        mainWidget(0),
                        mainWidget(1),
                        mainWidget(2),
                        mainWidget(3),
                      ],
                    ),
                  ),
                  // Expanded(child: mainWidget(_listType)),
                ],
              )),
        ),
      );
    });
  }
}
