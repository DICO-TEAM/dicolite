
import 'package:dicolite/config/config.dart';
import 'package:dicolite/config/country_code_english.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/model/ico_model.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/jump_to_browser_link.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/rounded_card.dart';

import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class IcoPending extends StatefulWidget {
  IcoPending(this.store);
  static final String route = '/ico/IcoPending';
  final AppStore store;

  @override
  _IcoPending createState() => _IcoPending(store);
}

class _IcoPending extends State<IcoPending> {
  _IcoPending(this.store);

  final AppStore store;
  CurrencyModel? exchangeToken;
  bool _isShowDetail = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var args = ModalRoute.of(context)!.settings.arguments as IcoModel;
      _getTokenInfo(args.exchangeToken);
    });
  }

  /// get token info by currencyId
  Future _getTokenInfo(String id) async {
    if (id == Config.tokenId) {
      setState(() {
        exchangeToken = store.dico!.tokensSort[0];
      });
      return;
    }
    var res = await webApi?.dico?.fetchTokenInfo(id);

    if (mounted) {
      setState(() {
        exchangeToken = res != null && res["metadata"] != null
            ? CurrencyModel.fromJson(res)
            : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    IcoModel ico = ModalRoute.of(context)!.settings.arguments as IcoModel;
    String excluedAreaString = "";

    List<String> list = [];
    countryCodeEnglish.forEach((e) {
      if (ico.excludeArea.contains(e["code"])) {
        list.add(e["name"] as String);
      }
    });
    excluedAreaString = list.join(", ");
    return Observer(builder: (_) {
      return Scaffold(
        appBar: myAppBar(context, dic.detail),
        body: exchangeToken == null
            ? LoadingWidget()
            : ListView(
                children: [
                  RoundedCard(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Logo(
                              symbol: ico.tokenSymbol,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ico.projectName,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    Fmt.token(ico.totalIcoAmount, ico.decimals),
                                    style: TextStyle(
                                        fontSize: Adapt.px(36),
                                        color: Color(0xFFF5673A),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    dic.totalIcoAmount,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    Fmt.token(ico.exchangeTokenTotalAmount,
                                        exchangeToken!.decimals),
                                    style: TextStyle(
                                        fontSize: Adapt.px(36),
                                        color: Color(0xFFF5673A),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    dic.exchangeTokenTotalAmount,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  ((ico.totalUnrealeaseAmount /
                                                  ico.exchangeTokenTotalAmount) *
                                              100)
                                          .toStringAsFixed(1) +
                                      "%",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.black),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  dic.progressRate,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  exchangeToken?.symbol ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.black),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  dic.exchangeToken,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  ico.isMustKyc ? dic.yes : dic.no,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.black),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  dic.isMustKyc,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(),
                        Wrap(
                          children: [
                            Text(ico.desc),
                          ],
                        ),
                      ],
                    ),
                  ),
                  RoundedCard(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        ico.isMustKyc
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dic.excludeArea,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    excluedAreaString,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.black),
                                  ),
                                  Divider(),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isShowDetail = !_isShowDetail;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(dic.detail),
                                  Icon(
                                    _isShowDetail
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_right,
                                    size: 28,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        AnimatedContainer(
                          height: _isShowDetail ? 260 : 0,
                          duration: Duration(microseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          child: detailWidget(dic, store.settings?.blockDuration??0,ico),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      );
    });
  }


  Widget detailWidget(S dic, int blockTime,IcoModel ico) {
    TextStyle style =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: Adapt.px(24));
    TextStyle style2 =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: Adapt.px(24));

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Config.bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.totalIssuance,
                style: style,
              ),
              Text(
                Fmt.token(ico.totalIssuance, ico.decimals) +
                    " " +
                    ico.tokenSymbol,
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.totalCirculation,
                style: style,
              ),
              Text(
                Fmt.token(ico.totalCirculation, ico.decimals) +
                    " " +
                    ico.tokenSymbol,
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.icoDuration,
                style: style,
              ),
              Text(
                Fmt.blockToTime(ico.icoDuration, blockTime),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.index,
                style: style,
              ),
              Text(
                ico.index.toString(),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.lockProportion,
                style: style,
              ),
              Text(
                "${ico.lockProportion}%",
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.perDurationUnlockAmount,
                style: style,
              ),
              Text(
                Fmt.token(ico.perDurationUnlockAmount, ico.decimals) +
                    " " +
                    ico.tokenSymbol,
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.unlockDuration,
                style: style,
              ),
              Text(
                Fmt.blockToTime(ico.unlockDuration, blockTime),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.userIcoMaxTimes,
                style: style,
              ),
              Text(
                ico.userIcoMaxTimes.toString(),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.currencyId,
                style: style,
              ),
              Text(
                ico.currencyId.toString(),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.exchangeTokenId,
                style: style,
              ),
              Text(
                ico.exchangeToken.toString(),
                style: style2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  dic.initiator,
                  style: style,
                ),
              ),
              Row(
                children: [
                  AddressIcon(
                    ico.initiator,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Fmt.address(ico.initiator),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dic.officialWebsite,
                style: style,
              ),
              JumpToBrowserLink(
                ico.officialWebsite,
                text: Fmt.address(ico.officialWebsite),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
