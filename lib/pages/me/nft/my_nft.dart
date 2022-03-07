import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/nft_token_info_model.dart';
import 'package:dicolite/pages/me/nft/sell_nft.dart';
import 'package:dicolite/pages/me/nft/transfer_nft.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/nft_item.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:dicolite/widgets/rounded_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MyNft extends StatefulWidget {
  MyNft(this.store);
  final AppStore store;
  static final String route = '/me/MyNft';
  @override
  _MyNftState createState() => _MyNftState(store);
}

class _MyNftState extends State<MyNft> {
  _MyNftState(this.store);
  final AppStore store;

  @override
  void initState() {
    super.initState();
    // _getData();
  }

  Future _getData() async {
    await webApi?.dico?.fetchMyNftTokenList();
  }

  Future<void> _setAsAvatar(NftTokenInfoModel nft) async {
    TxConfirmParams args = TxConfirmParams(
      title: S.of(context).setAsAvatar,
      module: 'nft',
      call: 'active',
      detail: jsonEncode({
        "token": [
          nft.data.classId,
          nft.tokenId,
        ]
      }),
      params: [
        [
          nft.data.classId,
          nft.tokenId,
        ]
      ],
      onSuccess: (res) {
        globalMyNFTRefreshKey.currentState?.show();
      },
    );

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(MyNft.route));
    }
  }

  Future<void> _removeAvatar(NftTokenInfoModel nft) async {
    TxConfirmParams args = TxConfirmParams(
      title: S.of(context).removeAvatar,
      module: 'nft',
      call: 'inactive',
      detail: jsonEncode({
        "token": [
          nft.data.classId,
          nft.tokenId,
        ]
      }),
      params: [
        [
          nft.data.classId,
          nft.tokenId,
        ]
      ],
      onSuccess: (res) {
        globalMyNFTRefreshKey.currentState?.show();
      },
    );

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(MyNft.route));
    }
  }

  Future<void> _burn(NftTokenInfoModel nft) async {
    TxConfirmParams args = TxConfirmParams(
      title: S.of(context).burn,
      module: 'nft',
      call: 'burn',
      detail: jsonEncode({
        "token": [
          nft.data.classId,
          nft.tokenId,
        ]
      }),
      params: [
        [
          nft.data.classId,
          nft.tokenId,
        ]
      ],
      onSuccess: (res) {
        globalMyNFTRefreshKey.currentState?.show();
      },
    );
    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(MyNft.route));
    }
  }

  Future<void> _cancelSale(NftTokenInfoModel nft) async {
    TxConfirmParams args = TxConfirmParams(
      title: S.of(context).cancelSale,
      module: 'nft',
      call: 'withdrawSale',
      detail: jsonEncode({
        "token": [
          nft.data.classId,
          nft.tokenId,
        ]
      }),
      params: [
        [
          nft.data.classId,
          nft.tokenId,
        ]
      ],
      onSuccess: (res) {
        globalMyNFTRefreshKey.currentState?.show();
      },
    );

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(MyNft.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    return Observer(builder: (_) {
      return Scaffold(
        appBar: myAppBar(
          context,
          dic.my + " NFT",
        ),
        body: store.dico?.myNftTokenList == null
            ? LoadingWidget()
            : RefreshIndicator(
                onRefresh: _getData,
                key: globalMyNFTRefreshKey,
                child: ListView(
                  children: [
                    store.dico!.myNftTokenList!.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: NoData(),
                          )
                        : Column(
                            children: store.dico!.myNftTokenList!
                                .map((NftTokenInfoModel e) => InkWell(
                                      onTap: () => _showBottom(context, e, dic),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 15, 15, 0),
                                        child: NftItem(e),
                                      ),
                                    ))
                                .toList()),
                  ],
                ),
              ),
      );
    });
  }

  _showBottom(BuildContext contextOut, NftTokenInfoModel nft, S dic) {
    showModalBottomSheet(
        context: context,
        builder: (contex) {
          return Stack(
            children: [
              Container(
                height: 700,
                color: Colors.black54,
              ),
              Container(
                height: 700,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      nft.level + "#${nft.data.classId}-${nft.tokenId ?? ''} ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: Adapt.px(30)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15, bottom: 8),
                          child: InkWell(
                            onTap: () => copy(context, nft.imageUrl),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                color: Config.bgColor,
                                child: CachedNetworkImage(
                                  imageUrl: nft.imageUrl,
                                  width: Adapt.px(140),
                                  height: Adapt.px(140),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 80,
                                      child: Text(
                                        "Meta Data",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: InkWell(
                                      onTap: () => copy(
                                          context, nft.metadata.toString()),
                                      child: Text(
                                        nft.metadata.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 80,
                                      child: Text(
                                        "Attribute",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => copy(context,
                                            nft.data.attribute.toString()),
                                        child: Text(
                                          nft.data.attribute.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: [
                          nft.data.status.isInSale
                              ? RoundedButton(
                                  round: true,
                                  outlined: true,
                                  text: nft.data.status.isActiveImage
                                      ? dic.removeAvatar
                                      : dic.setAsAvatar,
                                  // foregroundColor: Colors.grey,
                                  onPressed: null,
                                )
                              : RoundedButton(
                                  round: true,
                                  outlined: true,
                                  text: nft.data.status.isActiveImage
                                      ? dic.removeAvatar
                                      : dic.setAsAvatar,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    if (nft.data.status.isActiveImage) {
                                      _removeAvatar(nft);
                                    } else {
                                      _setAsAvatar(nft);
                                    }
                                  },
                                ),
                          SizedBox(
                            height: 8,
                          ),
                          nft.data.status.isActiveImage ||
                                  nft.data.status.isInSale
                              ? RoundedButton(
                                  round: true,
                                  outlined: true,
                                  text: dic.send,
                                  // foregroundColor: Colors.grey,
                                  onPressed: null,
                                )
                              : RoundedButton(
                                  round: true,
                                  outlined: true,
                                  text: dic.send,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(contextOut).pushNamed(
                                        TransferNft.route,
                                        arguments: nft);
                                  },
                                ),
                          SizedBox(
                            height: 8,
                          ),
                          nft.data.status.isActiveImage ||
                                  nft.data.status.isInSale
                              ? RoundedButton(
                                  round: true,
                                  outlined: true,
                                  text: dic.burn,
                                  // foregroundColor: Colors.grey,
                                  onPressed: null,
                                )
                              : RoundedButton(
                                  round: true,
                                  outlined: true,
                                  text: dic.burn,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showConfrim(contextOut,
                                        Text(dic.burnNftTip), () => _burn(nft));
                                  },
                                ),
                          SizedBox(
                            height: 8,
                          ),
                          nft.data.status.isInSale
                              ? RoundedButton(
                                  round: true,
                                  outlined: true,
                                  text: dic.cancelSale,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _cancelSale(nft);
                                  },
                                )
                              : nft.data.status.isActiveImage
                                  ? RoundedButton(
                                      round: true,
                                      outlined: true,
                                      text: dic.sale,
                                      // foregroundColor: Colors.grey,
                                      onPressed: null,
                                    )
                                  : RoundedButton(
                                      round: true,
                                      outlined: true,
                                      text: dic.sale,
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        Navigator.of(contextOut).pushNamed(
                                            SellNft.route,
                                            arguments: nft);
                                      },
                                    ),
                          SizedBox(
                            height: 8,
                          ),
                          RoundedButton(
                            round: true,
                            text: dic.cancel,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
