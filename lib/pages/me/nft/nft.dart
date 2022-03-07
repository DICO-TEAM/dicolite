import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/nft_token_info_model.dart';
import 'package:dicolite/pages/me/nft/buy_nft.dart';
import 'package:dicolite/pages/me/nft/claim_nft.dart';
import 'package:dicolite/pages/me/nft/my_nft.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:dicolite/widgets/rounded_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

List sortList = ["newest", "ascend", "descend"];

class Nft extends StatefulWidget {
  Nft(this.store);
  static final String route = '/me/Nft';
  final AppStore store;
  @override
  _NftState createState() => _NftState(store);
}

class _NftState extends State<Nft> {
  _NftState(this.store);
  final AppStore store;
  List<NftTokenInfoModel> nftTokenList = [];

  bool isLoading = true;

  String _selectClass = Config.nftNameList[0];
  String _sort = sortList[0];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    List? list = await webApi?.dico?.fetchNftOnSaleList();

    if (list != null && mounted) {
      setState(() {
        isLoading = false;

        nftTokenList = list.map((e) => NftTokenInfoModel.fromJson(e)).toList();
      });
    } else if (list == null && mounted) {
      setState(() {
        isLoading = false;

        nftTokenList = [];
      });
    }
  }

  Widget selectWidget(S dic) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField(
              value: _selectClass,
              items: Config.nftNameList
                  .map((f) => DropdownMenuItem(
                        child: Container(
                          child: Text(
                            f,
                            style: TextStyle(fontSize: Adapt.px(30)),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        value: f,
                      ))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectClass = v as String;
                });
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.white),
                ),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(15, 10, 0, 15),
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: DropdownButtonFormField(
              value: _sort,
              items: sortList
                  .map((f) => DropdownMenuItem(
                        child: Container(
                          child: Text(
                            f == sortList[0]
                                ? dic.newest
                                : f == sortList[1]
                                    ? dic.ascend
                                    : dic.descend,
                            style: TextStyle(fontSize: Adapt.px(30)),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        value: f,
                      ))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _sort = v as String;
                });
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.white),
                ),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(15, 10, 0, 15),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    return Observer(builder: (_) {
      String symbol = store.settings!.networkState.tokenSymbol;
      int decimals = store.settings!.networkState.tokenDecimals;

      List<NftTokenInfoModel> list = nftTokenList;
      if (_selectClass == "Other") {
        list = nftTokenList
            .where((e) => Decimal.parse(e.data.classId) > Decimal.fromInt(5))
            .toList();
      } else if (_selectClass != "All") {
        String type = (Config.nftNameList.indexOf(_selectClass) - 1).toString();
        list = nftTokenList.where((e) => e.data.classId == type).toList();
      }
      if (_sort == sortList[0]) {
        list = list.reversed.toList();
      } else if (_sort == sortList[1]) {
        list.sort((a, b) => a.price!.compareTo(b.price!));
      } else {
        list.sort((a, b) => b.price!.compareTo(a.price!));
      }
      return Scaffold(
        appBar: myAppBar(
          context,
          "NFT",
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(MyNft.route),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text(
                        dic.my_nft,
                        style: TextStyle(
                            fontSize: Adapt.px(24),
                            color: Theme.of(context).primaryColor),
                      )),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            )
          ],
        ),
        body: isLoading
            ? LoadingWidget()
            : RefreshIndicator(
                onRefresh: _getData,
                key: globalNftListRefreshKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                Navigator.of(context).pushNamed(ClaimNft.route),
                            child: Container(
                              height: Adapt.px(162),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/dico/claim-bg.png'),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dic.mint_nft,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Adapt.px(34),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.arrow_right,
                                      size: Adapt.px(70),
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(
                            dic.on_sale,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Config.color333,
                                    fontSize: Adapt.px(36),
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    selectWidget(dic),
                    list.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: NoData(),
                          )
                        : Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: Adapt.px(22),
                                childAspectRatio: 0.68,
                                padding: EdgeInsets.all(Adapt.px(20)),
                                children: list
                                    .map(
                                      (NftTokenInfoModel e) => Container(
                                        child: Column(
                                          children: [
                                            RoundedCard(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 15, 10, 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: Adapt.px(10),
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15,
                                                    ),
                                                    child: Container(
                                                      color: Config.bgColor,
                                                      child: CachedNetworkImage(
                                                        imageUrl: e.imageUrl,
                                                        width: Adapt.px(250),
                                                        height: Adapt.px(250),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Adapt.px(30),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                e.level,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Adapt.px(26)),
                                                              ),
                                                            ),
                                                            Text(
                                                                "#${e.data.classId}-${e.tokenId ?? ''}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Adapt.px(
                                                                            20))),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: Adapt.px(30),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                Fmt.token(
                                                                        e.price,
                                                                        decimals) +
                                                                    " $symbol",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      Adapt.px(
                                                                          25),
                                                                  color: Color(
                                                                      0xFFF4501E),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                6, 3, 6, 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: InkWell(
                                                          onTap: () => Navigator
                                                                  .of(context)
                                                              .pushNamed(
                                                                  BuyNft.route,
                                                                  arguments: e),
                                                          child: Text(
                                                            dic.buy,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()),
                          ),
                  ],
                ),
              ),
      );
    });
  }
}
