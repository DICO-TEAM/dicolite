import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/dao_proposal_model.dart';
import 'package:dicolite/model/ico_unrelease_assets_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/bordered_title.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/vote_rate_line.dart';
import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DaoVote extends StatefulWidget {
  DaoVote(this.store);
  static final String route = '/dao/DaoVote';
  final AppStore store;

  @override
  _DaoVote createState() => _DaoVote(store);
}

class _DaoVote extends State<DaoVote> {
  _DaoVote(this.store);

  final AppStore store;

  IcoUnreleaseAssetsModel? userJoinAmount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      DaoProposalModel proposal =
          ModalRoute.of(context)!.settings.arguments as DaoProposalModel;
      _getUserJoinAmount(proposal);
    });
  }

  _computeReleaseAmount(DaoProposalModel e) {
    if (e.icoRequestReleaseInfo == null) return BigInt.zero;
    return BigInt.from(
        (BigInt.parse(e.icoRequestReleaseInfo!.percent.toString()) *
                e.ico!.totalUnrealeaseAmount *
                e.ico!.totalIcoAmount /
                e.ico!.exchangeTokenTotalAmount) /
            100);
  }

  /// get user join ico amount
  Future _getUserJoinAmount(DaoProposalModel proposal) async {
    if (store.account!.currentAccount.address == proposal.ico!.initiator)
      return;
    List? res = await webApi?.dico?.fetchUserJoinIcoAmount();
    if (res != null && mounted) {
      List<IcoUnreleaseAssetsModel> list =
          res.map((e) => IcoUnreleaseAssetsModel.fromJson(e)).toList();
      int index = list.indexWhere((e) =>
          e.currencyId == proposal.currencyId && e.index == proposal.icoIndex);
      setState(() {
        userJoinAmount = index == -1 ? null : list[index];
      });
    }
  }

  Future onVote(bool approve, DaoProposalModel proposal) async {
    TxConfirmParams args = TxConfirmParams(
        title: S.of(context).vote,
        module: 'dao',
        call: 'vote',
        detail: jsonEncode({
          "currencyId": proposal.currencyId,
          "icoIndex": proposal.icoIndex,
          "proposal": proposal.hash,
          "index": proposal.proposalIndex,
          "approve": approve,
        }),
        params: [
          proposal.currencyId,
          proposal.icoIndex,
          proposal.hash,
          proposal.proposalIndex,
          approve,
        ],
        onSuccess: (res) {
          globalDaoRefreshKey.currentState?.show();
        });

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(Home.route));
    }
  }

  Future close(DaoProposalModel proposal) async {
    TxConfirmParams args = TxConfirmParams(
        title: S.of(context).close,
        module: 'dao',
        call: 'close',
        detail: jsonEncode({
          "currencyId": proposal.currencyId,
          "icoIndex": proposal.icoIndex,
          "proposalHash": proposal.hash,
          "index": proposal.proposalIndex,
          "proposalWeightBound": 1000000000,
          "lengthBound": 1000000000,
        }),
        params: [
          proposal.currencyId,
          proposal.icoIndex,
          proposal.hash,
          proposal.proposalIndex,
          1000000000,
          1000000000,
        ],
        onSuccess: (res) {
          globalDaoRefreshKey.currentState?.show();
        });

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(Home.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    DaoProposalModel proposal =
        ModalRoute.of(context)!.settings.arguments as DaoProposalModel;
    return Observer(builder: (_) {
      int blockTime = store.settings?.blockDuration ?? 0;
      bool isVotedYes = false;
      bool isVotedNo = false;
      proposal.ayes.forEach((e) {
        if (e[0] == store.account!.currentAddress) {
          isVotedYes = true;
        }
      });
      proposal.nays.forEach((e) {
        if (e[0] == store.account!.currentAddress) {
          isVotedNo = true;
        }
      });
      int now = store.dico?.newHeads?.number ?? 0;
      bool isFinished = proposal.end - now < 0;

      bool canClose = false;
      int ayes = computeAyeRate(proposal);
      int nays = computeNayRate(proposal);
      if (ayes >= proposal.threshold || nays >= (100 - proposal.threshold)) {
        canClose = true;
      }
      if (isFinished) {
        canClose = true;
      }
      return Scaffold(
        appBar: myAppBar(context, dic.proposal),
        body: ListView(
          children: <Widget>[
            Container(color: Colors.white, child: Divider()),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Logo(symbol: proposal.ico!.tokenSymbol),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(proposal.ico!.projectName),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 7, 10, 7),
                            decoration: BoxDecoration(
                                color: isFinished
                                    ? Theme.of(context).disabledColor
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(50))),
                            child: Text(
                              isFinished
                                  ? dic.finished
                                  : Fmt.blockToTime(
                                      proposal.end - now, blockTime),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Wrap(
                        children: [
                          Text(proposal.ico!.desc),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Fmt.token(_computeReleaseAmount(proposal),
                              proposal.ico!.decimals),
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: Color(0xFFF5673A),
                                  fontWeight: FontWeight.bold),
                        ),
                        Text(
                          dic.requestRelease + "(${proposal.ico!.tokenSymbol})",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                proposal.section + "." + proposal.method,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                              ),
                              Text(
                                dic.proposalType,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                proposal.icoRequestReleaseInfo!.percent
                                        .toString() +
                                    "%",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                              ),
                              Text(
                                dic.releaseProgress,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    proposal.reason != null
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dic.reason),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  color: Color(0xFFeeeeee),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          proposal.reason ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    VoteRateLine(proposal),
                    userJoinAmount != null
                        ? Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: !isVotedYes
                                            ? () => onVote(true, proposal)
                                            : null,
                                        icon: Icon(Icons.check),
                                        label: Text(
                                          isVotedYes
                                              ? '${dic.aye}(${dic.voted})'
                                              : dic.aye,
                                        ),
                                      ),
                                    ),
                                    Container(width: 16),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: !isVotedNo
                                            ? () => onVote(false, proposal)
                                            : null,
                                        style: !isVotedNo
                                            ? ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.orange))
                                            : null,
                                        icon: Icon(Icons.clear),
                                        label: Text(
                                          isVotedNo
                                              ? '${dic.nay}(${dic.voted})'
                                              : dic.nay,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            canClose
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton.icon(
                      onPressed: () => close(proposal),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black)),
                      icon: Icon(Icons.clear),
                      label: Text(
                        dic.close + " " + dic.proposal,
                      ),
                    ),
                  )
                : Container(),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 26, 16, 8),
                  child: BorderedTitle(title: dic.vote_voter),
                ),
              ],
            ),
            ProposalVotingData(store: widget.store, proposal: proposal),
          ],
        ),
      );
    });
  }
}

class ProposalVotingData extends StatefulWidget {
  ProposalVotingData({required this.store, required this.proposal});

  final AppStore store;
  final DaoProposalModel proposal;

  @override
  _ProposalVotingDataState createState() => _ProposalVotingDataState();
}

class _ProposalVotingDataState extends State<ProposalVotingData> {
  int _tab = 0;

  void _changeTab(int i) {
    if (_tab != i) {
      setState(() {
        _tab = i;
      });
    }
  }

  Widget addrInfo(List e) {
    final Map? accInfo = widget.store.account!.addressIndexMap[e[0]];
    return ListTile(
      leading: AddressIcon(e[0]),
      title: Fmt.accountDisplayName(e[0], accInfo),
      subtitle: Text('${S.of(context).backing}: ${Fmt.token(
        BigInt.parse(e[1].toString()),
        widget.proposal.ico!.decimals,
        length: 0,
      )} ${widget.proposal.ico!.tokenSymbol}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);

    return Container(
      padding: EdgeInsets.only(bottom: 354),
      margin: EdgeInsets.only(top: 8),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [0, 1].map((e) {
                final Color tabColor = e == _tab
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor;
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      e == 0 ? dic.aye : dic.nay,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Adapt.px(36),
                        fontWeight: FontWeight.bold,
                        color: tabColor,
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        width: 2,
                        color: tabColor,
                      )),
                    ),
                  ),
                  onTap: () => _changeTab(e),
                );
              }).toList(),
            ),
          ),
          Column(
              children: _tab == 0
                  ? widget.proposal.ayes.map((e) => addrInfo(e)).toList()
                  : widget.proposal.nays.map((e) => addrInfo(e)).toList())
        ],
      ),
    );
  }
}
