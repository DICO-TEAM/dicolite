import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/pages/me/assets/token_asset.dart';
import 'package:dicolite/pages/me/find_token.dart';
import 'package:dicolite/pages/me/kyc/kyc.dart';
import 'package:dicolite/pages/me/nft/nft.dart';
import 'package:dicolite/pages/me/select_account.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/utils/loading.dart';
import 'package:dicolite/utils/local_storage.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/no_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/pages/me/address_qr.dart';
import 'package:dicolite/pages/me/assets/asset.dart';
import 'package:dicolite/pages/me/council/councilPage.dart';
import 'package:dicolite/pages/me/democracy/democracyPage.dart';
import 'package:dicolite/pages/me/setting/set_node/set_node.dart';
import 'package:dicolite/pages/me/setting/setting.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/loading_widget.dart';

class Me extends StatefulWidget {
  Me(this.store);
  final AppStore store;

  @override
  _MeState createState() => _MeState(store);
}

class _MeState extends State<Me>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  _MeState(this.store);
  final AppStore store;

  Future _delCurrency(CurrencyModel item) async {
    Loading.showLoading(context);
    await LocalStorage.removeTokenFromList(
        store.settings?.endpoint.info.toUpperCase() ?? "DICO", item.toJson());
    await store.dico?.getTokens();
    webApi!.dico!.subTokensBalanceChange();
    Loading.hideLoading(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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

      return Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: Text(""),
              systemOverlayStyle: SystemUiOverlayStyle.light,
              expandedHeight: Adapt.px(420),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/dico/bg-account.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: Adapt.px(6),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Logo(
                                        logoUrl: store
                                            .dico?.activeNftToken?.imageUrl,
                                        size: Adapt.px(70),
                                      ),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () => Navigator.of(context)
                                              .pushNamed(SelectAccount.route),
                                          child: Row(
                                            children: [
                                              Text(
                                                store.account?.currentAccount
                                                        .name ??
                                                    "",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Adapt.px(29),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colors.white,
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Image.asset(
                                    'assets/images/dico/qrcode.png',
                                    height: Adapt.px(30),
                                  ),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(AddressQR.route),
                                ),
                                IconButton(
                                  icon: Image.asset(
                                    'assets/images/dico/node.png',
                                    height: Adapt.px(30),
                                  ),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(SetNode.route),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(Setting.route),
                                  icon: Image.asset(
                                    'assets/images/dico/menu.png',
                                    height: Adapt.px(30),
                                  ),
                                )
                              ],
                            ),
                          ),
                          store.settings!.loading
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 28.0),
                                  child: InkWell(
                                    onTap: () => Navigator.of(context)
                                        .pushNamed(SetNode.route),
                                    child: Text(
                                      S.of(context).nodeConnecting,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Adapt.px(40),
                                      ),
                                    ),
                                  ),
                                )
                              : store.settings!.versionName.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 28.0),
                                      child: InkWell(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(SetNode.route),
                                        child: Text(
                                          S.of(context).nodeConnectFailed,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Adapt.px(40),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dic.version,
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: Adapt.px(24),
                                                    ),
                                                  ),
                                                  Text(
                                                    store.settings!.versionName,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: Adapt.px(24),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: Adapt.px(5),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    dic.blockHeight,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontSize: Adapt.px(24),
                                                    ),
                                                  ),
                                                  Text(
                                                    store.dico?.newHeads
                                                                ?.number ==
                                                            null
                                                        ? "~"
                                                        : Fmt.ratio(
                                                            store.dico?.newHeads
                                                                ?.number,
                                                            needSymbol: false),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: Adapt.px(24),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: Adapt.px(20),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Adapt.px(15)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () =>
                                                      Navigator.of(context)
                                                          .pushNamed(Kyc.route),
                                                  child: Container(
                                                    width: Adapt.px(157),
                                                    height: Adapt.px(150),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                          'assets/images/dico/KYC.png',
                                                          height: Adapt.px(50),
                                                        ),
                                                        SizedBox(
                                                          height: Adapt.px(12),
                                                        ),
                                                        Text(
                                                          "KYC",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xCCFAFAFA),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                Adapt.px(30),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () =>
                                                      Navigator.of(context)
                                                          .pushNamed(Nft.route),
                                                  child: Container(
                                                    width: Adapt.px(157),
                                                    height: Adapt.px(150),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                          'assets/images/dico/NFT.png',
                                                          height: Adapt.px(50),
                                                        ),
                                                        SizedBox(
                                                          height: Adapt.px(12),
                                                        ),
                                                        Text(
                                                          "NFT",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xCCFAFAFA),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                Adapt.px(30),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => Navigator.of(
                                                          context)
                                                      .pushNamed(
                                                          CouncilPage.route),
                                                  child: Container(
                                                    width: Adapt.px(157),
                                                    height: Adapt.px(150),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                          'assets/images/dico/council.png',
                                                          height: Adapt.px(50),
                                                        ),
                                                        SizedBox(
                                                          height: Adapt.px(12),
                                                        ),
                                                        Text(
                                                          S.of(context).council,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xCCFAFAFA),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                Adapt.px(28),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => Navigator.of(
                                                          context)
                                                      .pushNamed(
                                                          DemocracyPage.route),
                                                  child: Container(
                                                    width: Adapt.px(157),
                                                    height: Adapt.px(150),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                          'assets/images/dico/democracy.png',
                                                          height: Adapt.px(50),
                                                        ),
                                                        SizedBox(
                                                          height: Adapt.px(12),
                                                        ),
                                                        Text(
                                                          S
                                                              .of(context)
                                                              .democracy,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xCCFAFAFA),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                Adapt.px(28),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: Adapt.px(30),
                                          ),
                                        ],
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 60,
                  color: Theme.of(context).primaryColor,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Config.bgColor,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25))),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Text(
                              dic.assets,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: Adapt.px(36)),
                            ),

                            ///TODO
                            // Text(
                            //   " (1 DICO≈ \$0.01)",
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .bodyText1!
                            //       .copyWith(fontSize: Adapt.px(20)),
                            // ),
                            Expanded(child: Container()),
                            store.settings!.networkName.isNotEmpty
                                ? IconButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed(FindToken.route),
                                    icon: Image.asset(
                                      "assets/images/dico/add000.png",
                                      width: 21,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Adapt.px(15),
                ),
                store.dico?.tokensSort == null
                    ? Container()
                    : store.dico!.tokensSort.isEmpty
                        ? NoData()
                        : Container(
                            color: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              children: ListTile.divideTiles(
                                context: context,
                                tiles: store.dico!.tokensSort
                                    .map((e) => ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 3),
                                          onLongPress: e.currencyId == "0"
                                              ? null
                                              : () => showConfrim(
                                                  context,
                                                  Text(dic.deleteIt +
                                                      "Symbol: ${e.symbol};\n Id: ${e.currencyId}; Decimals: ${e.decimals}"),
                                                  () => _delCurrency(e),
                                                  okText: dic.delete),
                                          onTap: e.symbol.isEmpty
                                              ? null
                                              : () => e.currencyId == "0"
                                                  ? Navigator.of(context)
                                                      .pushNamed(Asset.route)
                                                  : Navigator.of(context)
                                                      .pushNamed(
                                                          TokenAsset.route,
                                                          arguments: e),
                                          leading:
                                              Logo(currencyId: e.currencyId),
                                          title: Text(
                                            e.symbol,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          trailing: Text(
                                            Fmt.token(e.tokenBalance.total,
                                                e.decimals),
                                            style: TextStyle(
                                                color: Config.color333,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                    .toList(),
                              ).toList(),
                            ),
                          )
              ]),
            ),
          ],
        ),
      );
    });
  }
}
