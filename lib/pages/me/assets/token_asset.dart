import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/common/colors.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/pages/me/address_qr.dart';
import 'package:dicolite/pages/me/assets/transfer/transfer.dart';
import 'package:dicolite/pages/me/assets/transfer/transfer_detail.dart';
import 'package:dicolite/service/request_service.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/assets/types/transferData.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/result_data.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/no_data.dart';

import 'package:intl/intl.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class TokenAsset extends StatefulWidget {
  TokenAsset(this.store);

  static final String route = '/me/Tokenassets/detail';

  final AppStore store;

  @override
  _TokenAssetState createState() => _TokenAssetState(store);
}

class _TokenAssetState extends State<TokenAsset>
    with SingleTickerProviderStateMixin {
  _TokenAssetState(this.store);

  final AppStore store;

  bool _isLastPage = false;

  final List<String> _tabTxt = ['all', 'in1', 'out'];
  List<List?> _transList = [null, null, null];
  bool _isRequesting = false;
  int _page = 1;
  int _size = 25;
  List allData = [];
  CurrencyModel? _token;

  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabTxt.length);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final CurrencyModel token =
          ModalRoute.of(context)!.settings.arguments as CurrencyModel;
      setState(() {
        _token = token;
      });
      _getData();
    });
  }

  /// get transaction data
  Future<void> _getData() async {
    if (_isRequesting || _isLastPage) {
      return;
    }
    String networkName = store.settings!.networkName.toLowerCase();

    if (Config.supportNetworkList.contains(networkName) == false) {
      setState(() {
        _transList = [[], [], []];
      });
      return;
    }

    _isRequesting = true;
    bool isLast = false;
    List inData = [];
    List outData = [];

    ResultData res = await RequestService.getTokenTransactionTxs(
      store.account!.currentAddress,
      _token!.currencyId,
      networkName,
      _page,
    );
    if (res.code != 500 && mounted && res.data["data"] != null) {
      isLast = _isLastPage = res.data["data"].length < _size;

      List list =
          res.data["data"].map((json) => TransferData.fromJson(json)).toList();
      if (_page == 1) {
        allData = list;
      } else {
        allData.addAll(list);
      }
      _page = _page + 1;
    }

    allData.forEach((element) {
      if (element.to == store.account!.currentAddress) {
        inData.add(element);
      } else {
        outData.add(element);
      }
    });
    List<List> transList = [allData, inData, outData];

    if (mounted) {
      setState(() {
        _transList = transList;
        _isLastPage = isLast;
      });
    }
    _isRequesting = false;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _page = 1;
      _isLastPage = false;
    });
    await _getData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget mainList(BuildContext context, List? list, CurrencyModel token) {
    if (list == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: LoadingWidget(),
      );
    } else if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: NoData(),
      );
    } else {
      return Column(
        children: list
            .map(
              (f) => Container(
                padding: EdgeInsets.symmetric(
                    vertical: Adapt.px(12), horizontal: Adapt.px(30.0)),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: Adapt.px(1), color: Color(0xFFEFEFEF)))),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    TransferDetailPage.route,
                    arguments: f,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, right: 20),
                              child: Text(
                                Fmt.address(
                                    f.to == store.account!.currentAddress
                                        ? f.from
                                        : f.to),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Config.color333,
                                  fontSize: Adapt.px(32),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "${f.to == store.account!.currentAddress ? "+" : "-"}${Fmt.token(f.amount, f.decimal, length: 5)} ${f.symbol}",
                              style: TextStyle(
                                color: f.to == store.account!.currentAddress
                                    ? Theme.of(context).primaryColor
                                    : Color(0xffFF8429),
                                fontSize: Adapt.px(32),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        f.blockTimestamp)),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Config.color999),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final CurrencyModel token =
        ModalRoute.of(context)!.settings.arguments as CurrencyModel;

    final S dic = S.of(context);

    return Scaffold(
      body: Observer(builder: (_) {
        int decimals = token.decimals;
        String symbol = token.symbol;
        // BalancesInfo balancesInfo =
        //     store.assets!.balances[symbol] ?? BalancesInfo();
        // String lockedInfo = '\n';
        // if (balancesInfo == null) {
        //   return Scaffold(
        //     appBar: myAppBar(context, ''),
        //     body: Center(child: LoadingWidget()),
        //   );
        // }
        // if (balancesInfo.lockedBreakdown != null) {
        //   balancesInfo.lockedBreakdown?.forEach((i) {
        //     if (i.amount! > BigInt.zero) {
        //       String use = '${i.use}';
        //       lockedInfo += "${Fmt.token(i.amount, decimals)} $symbol $use\n";
        //     }
        //   });
        // }
        return Scaffold(
          appBar: myAppBar(context, "$symbol(ID: ${token.currencyId})"),
          // title: symbol,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(35, 174, 132, 0.12),
                        offset: Offset(0, Adapt.px(4)),
                        blurRadius: Adapt.px(12)),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                child: Column(
                  children: <Widget>[
                    Text(
                      dic.totalAssets,
                      style: TextStyle(
                        color: Config.color333,
                        fontSize: Adapt.px(30),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        Fmt.token(token.tokenBalance.total, decimals,
                            length: 3),
                        style: TextStyle(
                          color: Config.color333,
                          fontSize: Adapt.px(60),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (_) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        dic.locked,
                                        style: TextStyle(
                                          color: Config.color999,
                                          fontSize: Adapt.px(32),
                                        ),
                                      ),
                                      // lockedInfo.length > 2
                                      //     ? Tooltip(
                                      //         message: lockedInfo,
                                      //         child: Padding(
                                      //           padding:
                                      //               EdgeInsets.only(right: 6),
                                      //           child: Image.asset(
                                      //               'assets/images/main/assets-tips.png'),
                                      //         ),
                                      //         // waitDuration:
                                      //         //     Duration(seconds: 0),
                                      //       )
                                      //     : Container(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    Fmt.token(
                                        token.tokenBalance.frozen, decimals),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Adapt.px(32),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  dic.available,
                                  style: TextStyle(
                                    color: Config.color999,
                                    fontSize: Adapt.px(32),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Fmt.token(token.tokenBalance.free, decimals),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Adapt.px(32),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  dic.reserved,
                                  style: TextStyle(
                                    color: Config.color999,
                                    fontSize: Adapt.px(32),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Fmt.token(
                                      token.tokenBalance.reserved, decimals),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Adapt.px(32),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: Adapt.px(40)),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: ElevatedButton(
                              style: token.tokenBalance.free != BigInt.zero
                                  ? ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.blue,
                                      ),
                                    )
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Image.asset(
                                        'assets/images/main/assets-send.png'),
                                  ),
                                  Text(
                                    dic.transfer,
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              onPressed: token.tokenBalance.free == BigInt.zero
                                  ? null
                                  : () {
                                      Navigator.pushNamed(
                                        context,
                                        TransferPage.route,
                                        arguments: TransferPageParams(
                                          redirect: TokenAsset.route,
                                          currency: token,
                                          symbol: symbol,
                                        ),
                                      );
                                    },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Image.asset(
                                        'assets/images/main/assets-receive-qr.png'),
                                  ),
                                  Text(
                                    dic.receive,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, AddressQR.route);
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //  Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: TabBar(
                            tabs: [
                              Text(
                                S.of(context).all,
                                style: TextStyle(fontSize: Adapt.px(30)),
                              ),
                              Text(
                                S.of(context).in1,
                                style: TextStyle(fontSize: Adapt.px(30)),
                              ),
                              Text(
                                S.of(context).out,
                                style: TextStyle(fontSize: Adapt.px(30)),
                              ),
                            ],
                            isScrollable: false,
                            labelPadding: EdgeInsets.all(0),
                            controller: _tabController,
                            indicatorColor: MyColors.text,
                            labelColor: MyColors.text,
                            labelStyle: TextStyle(
                                fontSize: Adapt.px(44),
                                color: MyColors.text,
                                fontWeight: FontWeight.bold),
                            // indicator: const BoxDecoration(),
                            unselectedLabelColor: MyColors.text_gray,
                            unselectedLabelStyle: TextStyle(
                                fontSize: Adapt.px(36), color: MyColors.text),
                            indicatorSize: TabBarIndicatorSize.label,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  dragStartBehavior: DragStartBehavior.start,
                  controller: _tabController,
                  children: _tabTxt
                      .asMap()
                      .keys
                      .map(
                        (i) => Container(
                          key: ObjectKey(i),
                          child: RefreshLoadmore(
                            onRefresh: _onRefresh,
                            onLoadmore: _getData,
                            noMoreWidget: Text(dic.noMore),
                            isLastPage:
                                _transList[i] == null || _transList[i]!.isEmpty
                                    ? false
                                    : _isLastPage,
                            child: mainList(context, _transList[i], token),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
