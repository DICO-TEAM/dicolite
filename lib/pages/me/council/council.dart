import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/council/candidateDetailPage.dart';
import 'package:dicolite/pages/me/council/councilPage.dart';
import 'package:dicolite/pages/me/council/councilVotePage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/bordered_title.dart';
import 'package:dicolite/widgets/info_item.dart';
import 'package:dicolite/widgets/outlined_button_small.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class Council extends StatefulWidget {
  Council(this.store);
  final AppStore store;

  @override
  State<StatefulWidget> createState() => _CouncilState(store);
}

class _CouncilState extends State<Council> {
  _CouncilState(this.store);

  final AppStore store;

  bool _votesExpanded = false;

  Future<void> _fetchCouncilInfo() async {
    if (store.settings!.loading) {
      return;
    }
    await webApi?.gov?.fetchCouncilVotes();
    webApi?.gov?.fetchUserCouncilVote();
  }

  Future<void> _submitCancelVotes() async {
    var div = S.of(context);
    TxConfirmParams args = TxConfirmParams(
        title: div.vote_remove,
        module: 'elections',
        call: 'removeVoter',
        detail: '{}',
        params: [],
        onSuccess: (res) {
          globalCouncilRefreshKey.currentState?.show();
        });

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(CouncilPage.route));
    }
  }

  Future<void> _onCancelVotes() async {
    S dic = S.of(context);
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Container(),
          content: Text(dic.vote_remove_confirm),
          actions: [
            CupertinoButton(
              child: Text(
                dic.cancel,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(dic.ok),
              onPressed: () {
                Navigator.of(context).pop();
                _submitCancelVotes();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      globalCouncilRefreshKey.currentState?.show();
    });
  }

  Widget _buildTopCard(String tokenView) {
    final int decimals =
        store.settings?.networkState.tokenDecimals ?? Config.tokenDecimals;
    final S dic = S.of(context);

    Map? userVotes = store.gov?.userCouncilVotes;
    BigInt voteAmount = BigInt.zero;
    double listHeight = 48;
    if (userVotes != null) {
      voteAmount = BigInt.parse(userVotes['stake'].toString());
      int listCount = List.of(userVotes['votes']).length;
      if (listCount > 0) {
        listHeight = double.parse((listCount * 52).toString());
      }
    }
    return RoundedCard(
      margin: EdgeInsets.fromLTRB(16, 12, 16, 24),
      padding: EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InfoItem(
                crossAxisAlignment: CrossAxisAlignment.center,
                title: dic.seats,
                content:
                    '${store.gov?.council.members!.length}/${BigInt.parse(store.gov?.council.desiredSeats.toString() ?? "0").toString()}',
              ),
              InfoItem(
                crossAxisAlignment: CrossAxisAlignment.center,
                title: dic.up,
                content: store.gov!.council.runnersUp.length.toString(),
              ),
              InfoItem(
                crossAxisAlignment: CrossAxisAlignment.center,
                title: dic.candidate,
                content: store.gov!.council.candidates.length.toString(),
              )
            ],
          ),
          Divider(height: 24),
          Column(
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _votesExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 28,
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _votesExpanded = !_votesExpanded;
                      });
                    },
                  ),
                  InfoItem(
                    content: '${Fmt.token(voteAmount, decimals)} $tokenView',
                    title: dic.vote_my,
                  ),
                  OutlinedButtonSmall(
                    content: dic.vote_remove,
                    active: false,
                    onPressed: listHeight > 48
                        ? () {
                            _onCancelVotes();
                          }
                        : null,
                  ),
                ],
              ),
              AnimatedContainer(
                height: _votesExpanded ? listHeight : 0,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: AnimatedOpacity(
                  opacity: _votesExpanded ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: listHeight > 48
                      ? ListView(
                          children: List.of(userVotes!['votes']).map((i) {
                            Map? accInfo = store.account!.addressIndexMap[i];
                            return CandidateItem(
                              iconSize: 32,
                              accInfo: accInfo,
                              balance: [i],
                              tokenSymbol: tokenView,
                              decimals: decimals,
                              noTap: true,
                            );
                          }).toList(),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            dic.data_empty,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                ),
              )
            ],
          ),
          Divider(height: 24),
          RoundedButton(
            text: dic.vote,
            onPressed: () =>
                Navigator.of(context).pushNamed(CouncilVotePage.route),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    return Observer(builder: (_) {
      final int decimals = store.settings!.networkState.tokenDecimals;
      final String symbol = store.settings!.networkState.tokenSymbol;
      return RefreshIndicator(
        key: globalCouncilRefreshKey,
        onRefresh: _fetchCouncilInfo,
        child: store.gov?.council == null
            ? Container()
            : ListView(
                children: <Widget>[
                  _buildTopCard(symbol),
                  Container(
                    padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                    color: Theme.of(context).cardColor,
                    child: BorderedTitle(
                      title: dic.member,
                    ),
                  ),
                  Container(
                    color: Theme.of(context).cardColor,
                    child: Column(
                      children: store.gov!.council.members!.map((i) {
                        Map? accInfo = store.account!.addressIndexMap[i[0]];
                        return CandidateItem(
                          accInfo: accInfo,
                          balance: i,
                          tokenSymbol: symbol,
                          decimals: decimals,
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                    color: Theme.of(context).cardColor,
                    child: BorderedTitle(
                      title: dic.up,
                    ),
                  ),
                  Container(
                    color: Theme.of(context).cardColor,
                    child: Column(
                      children: store.gov!.council.runnersUp.map((i) {
                        Map? accInfo = store.account!.addressIndexMap[i[0]];
                        return CandidateItem(
                          accInfo: accInfo,
                          balance: i,
                          tokenSymbol: symbol,
                          decimals: decimals,
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                    color: Theme.of(context).cardColor,
                    child: BorderedTitle(
                      title: dic.candidate,
                    ),
                  ),
                  Container(
                    color: Theme.of(context).cardColor,
                    child: store.gov!.council.candidates.length > 0
                        ? Column(
                            children: store.gov!.council.candidates.map((i) {
                              Map? accInfo = store.account!.addressIndexMap[i];
                              return CandidateItem(
                                accInfo: accInfo,
                                balance: [i],
                                tokenSymbol: symbol,
                                decimals: decimals,
                              );
                            }).toList(),
                          )
                        : Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(dic.candidate_empty),
                          ),
                  ),
                ],
              ),
      );
    });
  }
}

class CandidateItem extends StatelessWidget {
  CandidateItem({
    required this.accInfo,
    required this.balance,
    required this.tokenSymbol,
    required this.decimals,
    this.iconSize,
    this.noTap = false,
    this.trailing,
  });
  final Map? accInfo;
  // balance == [<candidate_address>, <0x_candidate_backing_amount>]
  final List balance;
  final String tokenSymbol;
  final int decimals;
  final double? iconSize;
  final bool noTap;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AddressIcon(balance[0], size: iconSize),
      title: Fmt.accountDisplayName(balance[0], accInfo),
      subtitle: balance.length == 1
          ? null
          : Text('${S.of(context).backing}: ${Fmt.token(
              BigInt.parse(balance[1].toString()),
              decimals,
              length: 0,
            )} $tokenSymbol'),
      onTap: noTap
          ? null
          : () => Navigator.of(context).pushNamed(CandidateDetailPage.route,
              arguments: balance.length == 1 ? [balance[0], '0x0'] : balance),
      trailing: trailing ?? Container(width: 8),
    );
  }
}
