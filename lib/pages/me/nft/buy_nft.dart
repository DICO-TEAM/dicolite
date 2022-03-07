import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/nft_token_info_model.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/rounded_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/my_appbar.dart';

import 'nft.dart';

class BuyNft extends StatefulWidget {
  const BuyNft(this.store);

  static final String route = '/me/nft/BuyNft';
  final AppStore store;

  @override
  _BuyNftState createState() => _BuyNftState(store);
}

class _BuyNftState extends State<BuyNft> {
  _BuyNftState(this.store);

  final AppStore store;

  _handleSubmit() async {
    NftTokenInfoModel? nft =
        ModalRoute.of(context)?.settings.arguments as NftTokenInfoModel?;
    if (nft != null) {
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).buy + " NFT",
        module: 'nft',
        call: 'buyToken',
        detail: jsonEncode({
          "token": {
            "ClassId": nft.data.classId,
            "TokenId": nft.tokenId,
          },
        }),
        params: [
          [
            nft.data.classId,
            nft.tokenId,
          ],
        ],
        onSuccess: (res) {
          globalNftListRefreshKey.currentState?.show();
          webApi?.dico?.fetchMyNftTokenList();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Nft.route));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    NftTokenInfoModel nft =
        ModalRoute.of(context)?.settings.arguments as NftTokenInfoModel;
    return Observer(
      builder: (_) {
        String symbol = store.settings!.networkState.tokenSymbol;
        int decimals = store.settings!.networkState.tokenDecimals;
        BigInt available = store.assets!.balances[symbol]!.transferable!;

        return Scaffold(
          appBar: myAppBar(context, dic.buy + " NFT"),
          body: SafeArea(
              child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    RoundedCard(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => copy(context, nft.imageUrl),
                                child: Container(
                                  color: Config.bgColor,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: nft.imageUrl,
                                      width: Adapt.px(250),
                                      height: Adapt.px(250),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  height: Adapt.px(250),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "#${nft.data.classId}-${nft.tokenId ?? ''} " +
                                            nft.level,
                                        style: TextStyle(
                                            fontSize: Adapt.px(40),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              Fmt.token(nft.price, decimals),
                                              textAlign: TextAlign.end,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      color: Color(0xFFF4501E),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Adapt.px(45)),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              " $symbol",
                                              style: TextStyle(
                                                  fontSize: Adapt.px(23)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Meta Data",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: InkWell(
                                  onTap: () =>
                                      copy(context, nft.metadata.toString()),
                                  child: Text(
                                    nft.metadata.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Attribute",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => copy(
                                        context, nft.data.attribute.toString()),
                                    child: Text(
                                      nft.data.attribute.toString(),
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dic.owner,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () =>
                                        copy(context, nft.owner.toString()),
                                    child: Text(
                                      Fmt.address(nft.owner.toString()),
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        dic.balance +
                            ":  " +
                            Fmt.token(available, decimals) +
                            " $symbol",
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: Adapt.px(300)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Fmt.token(nft.price, decimals),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                      color: Color(0xFFF4501E),
                                      fontWeight: FontWeight.bold,
                                      fontSize: Adapt.px(38)),
                            ),
                            Text(
                              " $symbol",
                              style: TextStyle(fontSize: Adapt.px(23)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Adapt.px(50))),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(20))),
                        onPressed:
                            available > nft.price! ? _handleSubmit : null,
                        child: Text(
                          dic.buy,
                          style: TextStyle(fontSize: Adapt.px(35)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
        );
      },
    );
  }
}
