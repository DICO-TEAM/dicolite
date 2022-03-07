import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/pages/home.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/council/motionDetailPage.dart';
import 'package:dicolite/pages/me/democracy/referendumPanel.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/service/substrate_api/types/genExternalLinksParams.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/gov/types/referendumInfoData.dart';
import 'package:dicolite/utils/UI.dart';

import 'package:dicolite/widgets/list_tail.dart';

class Democracy extends StatefulWidget {
  Democracy(this.store);

  final AppStore store;
  @override
  _DemocracyState createState() => _DemocracyState(store);
}

class _DemocracyState extends State<Democracy> {
  _DemocracyState(this.store);

  final AppStore store;

  final Map<BigInt, List> _links = {};

  String? _subscribeBestNumberChannel;

  Future<List?> _getExternalLinks(BigInt id) async {
    if (_links[id] != null) return _links[id];

    final List? res = await webApi!.getExternalLinks(
      GenExternalLinksParams.fromJson(
          {'data': id.toString(), 'type': 'referendum'}),
    );
    if (res != null && mounted) {
      setState(() {
        _links[id] = res;
      });
    }
    return res;
  }

  Future<void> _fetchReferendums() async {
    if (store.settings!.loading) {
      return;
    }
    webApi!.gov!.getReferendumVoteConvictions();
    await webApi!.gov!.fetchReferendums();
  }

  Future<void> _submitCancelVote(int id) async {
    var dic = S.of(context);
    TxConfirmParams args = TxConfirmParams(
      title: dic.vote_remove,
      module: 'democracy',
      call: 'removeVote',
      detail: jsonEncode({"id": id}),
      params: [id],
      onSuccess: (res) {
        globalDemocracyRefreshKey.currentState?.show();
      },
    );
    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(Home.route));
    }
  }

  @override
  void initState() {
    super.initState();
    if (!store.settings!.loading) {
      webApi!.subscribeBestNumber((data) {
        store.gov!.setBestNumber(int.parse(data.toString()));
      }).then((channel) {
        if (mounted) {
          setState(() {
            _subscribeBestNumberChannel = channel;
          });
        }
      });
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      globalDemocracyRefreshKey.currentState?.show();
    });
  }

  @override
  void dispose() {
    if (_subscribeBestNumberChannel != null) {
      webApi!.unsubscribeMessage(_subscribeBestNumberChannel!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final int decimals = store.settings!.networkState.tokenDecimals;
        final String symbol = store.settings!.networkState.tokenSymbol;
        List<ReferendumInfo>? list = store.gov!.referendums;
        int bestNumber = store.gov!.bestNumber;
        return RefreshIndicator(
          key: globalDemocracyRefreshKey,
          onRefresh: _fetchReferendums,
          child: list == null || list.length == 0
              ? Center(child: ListTail(isEmpty: true, isLoading: false))
              : ListView.builder(
                  itemCount: list.length + 1,
                  itemBuilder: (BuildContext context, int i) {
                    return i == list.length
                        ? Center(
                            child: ListTail(
                            isEmpty: false,
                            isLoading: false,
                          ))
                        : ReferendumPanel(
                            data: list[i],
                            bestNumber: bestNumber,
                            symbol: symbol,
                            decimals: decimals,
                            onCancelVote: _submitCancelVote,
                            blockDuration:
                                widget.store.settings?.blockDuration ?? 0,
                            links: FutureBuilder(
                              future: _getExternalLinks(list[i].index),
                              builder: (_, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ExternalLinks(snapshot.data);
                                }
                                return Container();
                              },
                            ));
                  },
                ),
        );
      },
    );
  }
}
