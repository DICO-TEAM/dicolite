import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/council/council.dart';
import 'package:dicolite/pages/me/council/councilPage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/service/substrate_api/types/genExternalLinksParams.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/gov/types/treasuryOverviewData.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/bordered_title.dart';
import 'package:dicolite/widgets/jump_to_browser_link.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class MotionDetailPage extends StatefulWidget {
  MotionDetailPage(this.store);

  static const String route = '/gov/council/motion';

  final AppStore store;

  @override
  _MotionDetailPageState createState() => _MotionDetailPageState();
}

class _MotionDetailPageState extends State<MotionDetailPage> {
  final List<String> methodExternal = [
    'externalPropose',
    'externalProposeDefault',
    'externalProposeMajority'
  ];
  final List<String> methodTreasury = ['approveProposal', 'rejectProposal'];

  Map? _treasuryProposal;

  List? _links;

  Future<List?> _getExternalLinks(int id) async {
    if (_links != null) return _links;

    final List? res = await webApi!.getExternalLinks(
      GenExternalLinksParams.fromJson(
          {'data': id.toString(), 'type': 'council'}),
    );
    if (res != null) {
      setState(() {
        _links = res;
      });
    }
    return res;
  }

  Future<Map> _fetchTreasuryProposal(String id) async {
    if (_treasuryProposal != null) return _treasuryProposal!;

    final Map? data =
        await webApi!.evalJavascript('api.query.treasury.proposals($id)');
    if (data != null) {
      setState(() {
        _treasuryProposal = data;
      });
    }
    return _treasuryProposal!;
  }

  void _onVote(bool approve) async {
    var dic = S.of(context);
    final CouncilMotionData motion =
        ModalRoute.of(context)!.settings.arguments as CouncilMotionData;
    TxConfirmParams args = TxConfirmParams(
      title: dic.treasury_vote,
      module: 'council',
      call: 'vote',
      detail: jsonEncode({
        "proposalHash": motion.hash,
        "proposalId": motion.votes!.index,
        "voteValue": approve,
      }),
      params: [
        motion.hash,
        motion.votes!.index,
        approve,
      ],
      onSuccess: (res) {
        globalMotionsRefreshKey.currentState?.show();
      },
    );
    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(CouncilPage.route));
    }
  }

  Future _close() async {
    var dic = S.of(context);
    final CouncilMotionData motion =
        ModalRoute.of(context)!.settings.arguments as CouncilMotionData;
    TxConfirmParams args = TxConfirmParams(
      title: dic.close,
      module: 'council',
      call: 'close',
      detail: jsonEncode({
        "proposalHash": motion.hash,
        "proposalId": motion.votes!.index,
        "proposalWeightBound": 1000000000,
        "lengthBound": 1000000000,
      }),
      params: [
        motion.hash,
        motion.votes!.index,
        1000000000,
        1000000000,
      ],
      onSuccess: (res) {
        globalMotionsRefreshKey.currentState?.show();
      },
    );

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(CouncilPage.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final CouncilMotionData motion =
        ModalRoute.of(context)!.settings.arguments as CouncilMotionData;
    return Observer(
      builder: (BuildContext context) {
        int blockTime = 6000;
        if (widget.store.settings!.networkConst['treasury'] != null) {
          blockTime = widget.store.settings?.blockDuration ?? 0;
        }
        List<List<String>> params = [];
        motion.proposal!.meta!.args!.asMap().forEach((k, v) {
          params.add(
              ['${v.name}: ${v.type}', motion.proposal!.args![k].toString()]);
        });
        bool isCouncil = false;
        widget.store.gov!.council.members!.forEach((e) {
          if (widget.store.account!.currentAddress == e[0]) {
            isCouncil = true;
          }
        });
        bool isVotedYes = false;
        bool isVotedNo = false;
        motion.votes!.ayes!.forEach((e) {
          if (e == widget.store.account!.currentAddress) {
            isVotedYes = true;
          }
        });
        motion.votes!.nays!.forEach((e) {
          if (e == widget.store.account!.currentAddress) {
            isVotedNo = true;
          }
        });
        bool isTreasury = motion.proposal!.section == 'treasury' &&
            methodTreasury.indexOf(motion.proposal!.method!) > -1;
        // bool isExternal = motion.proposal!.section == 'democracy' &&
        //     methodExternal.indexOf(motion.proposal!.method!) > -1;
        return Scaffold(
          appBar: myAppBar(
              context, '${dic.council_motion} #${motion.votes!.index}'),
          body: SafeArea(
            child: ListView(
              children: <Widget>[
                RoundedCard(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${motion.proposal!.section}.${motion.proposal!.method}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(motion.proposal!.meta!.documentation!.trim()),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: ProposalArgsItem(
                          label: Text('Hash'),
                          content: Text(
                            Fmt.address(motion.hash!, pad: 10),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          margin: EdgeInsets.all(0),
                        ),
                      ),
                      params.length > 0
                          ? Text(
                              dic.proposal_params,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).unselectedWidgetColor),
                            )
                          : Container(),
                      params.length > 0
                          ? ProposalArgsList(params)
                          : Container(),
                      isTreasury
                          ? FutureBuilder(
                              future: _fetchTreasuryProposal(
                                  motion.proposal!.args![0]),
                              builder: (_, AsyncSnapshot<Map> snapshot) {
                                if (snapshot.hasData) {
                                  return ProposalArgsItem(
                                    label: Text('proposal: TreasuryProposal'),
                                    content: Text(jsonEncode(snapshot.data)),
                                  );
                                }
                                return CupertinoActivityIndicator();
                              },
                            )
                          : Container(),
//                      isExternal
//                          ? FutureBuilder(
//                              future: _fetchTreasuryProposal(
//                                  motion.proposal!.args[0]),
//                              builder: (_, AsyncSnapshot<Map> snapshot) {
//                                return snapshot.hasData
//                                    ? ProposalArgsItem(
//                                        label: Text('rpop'),
//                                        content: Text('xx'),
//                                      )
//                                    : CupertinoActivityIndicator();
//                              },
//                            )
//                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(dic.vote_end),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  Fmt.blockToTime(
                                    motion.votes!.end! -
                                        widget.store.gov!.bestNumber,
                                    blockTime,
                                  ),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Text(
                                  '#${motion.votes!.end}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      FutureBuilder(
                        future: _getExternalLinks(motion.votes!.index!),
                        builder: (_, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ExternalLinks(snapshot.data);
                          }
                          return Container();
                        },
                      ),
                      Divider(height: 24),
                      ProposalVoteButtonsRow(
                        isCouncil: isCouncil,
                        isVotedNo: isVotedNo,
                        isVotedYes: isVotedYes,
                        onVote: _onVote,
                      ),
                    ],
                  ),
                ),
                ProposalClose(
                  store: widget.store,
                  council: motion,
                  close: _close,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: BorderedTitle(title: dic.vote_voter),
                ),
                ProposalVotingList(store: widget.store, council: motion),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProposalArgsList extends StatefulWidget {
  ProposalArgsList(this.args);
  final List<List<String>> args;
  @override
  _ProposalArgsListState createState() => _ProposalArgsListState();
}

class _ProposalArgsListState extends State<ProposalArgsList> {
  bool _showDetail = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      GestureDetector(
        child: Row(
          children: <Widget>[
            Icon(
              _showDetail
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
            ),
            Text(S.of(context).detail)
          ],
        ),
        onTap: () {
          setState(() {
            _showDetail = !_showDetail;
          });
        },
      )
    ];
    if (_showDetail) {
      items.addAll(widget.args.map((e) {
        return ProposalArgsItem(
          label: Text(e[0]),
          content: Text(
            e[1],
            style: Theme.of(context).textTheme.bodyText2,
          ),
        );
      }));
    }

    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          border: Border(
              left:
                  BorderSide(color: Theme.of(context).dividerColor, width: 3))),
      child: Column(
        children: items,
      ),
    );
  }
}

class ProposalArgsItem extends StatelessWidget {
  ProposalArgsItem({required this.label, required this.content, this.margin});

  final Widget label;
  final Widget content;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.fromLTRB(8, 4, 4, 4),
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[label, content],
            ),
          )
        ],
      ),
    );
  }
}

class ProposalVoteButtonsRow extends StatelessWidget {
  ProposalVoteButtonsRow({
    required this.isCouncil,
    required this.isVotedYes,
    required this.isVotedNo,
    this.onVote,
  });

  final bool isCouncil;
  final bool isVotedYes;
  final bool isVotedNo;
  final Function(bool)? onVote;

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: RoundedButton(
            icon: Icon(
              Icons.check,
              color: Theme.of(context).cardColor,
            ),
            text: isVotedYes ? '${dic.aye}(${dic.voted})' : dic.aye,
            onPressed: isCouncil && !isVotedYes ? () => onVote!(true) : null,
          ),
        ),
        Container(width: 16),
        Expanded(
          child: RoundedButton(
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).cardColor,
            ),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            text: isVotedNo ? '${dic.nay}(${dic.voted})' : dic.nay,
            onPressed: isCouncil && !isVotedNo ? () => onVote!(false) : null,
          ),
        ),
      ],
    );
  }
}

class ProposalVotingList extends StatefulWidget {
  ProposalVotingList({required this.store, required this.council});

  final AppStore store;
  final CouncilMotionData council;

  @override
  _ProposalVotingListState createState() => _ProposalVotingListState();
}

class _ProposalVotingListState extends State<ProposalVotingList> {
  int _tab = 0;

  void _changeTab(int i) {
    if (_tab != i) {
      setState(() {
        _tab = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final String symbol = widget.store.settings!.networkState.tokenSymbol;
    final int decimals = widget.store.settings!.networkState.tokenDecimals;
    final String voteCountAye =
        '${widget.council.votes!.ayes!.length}/${widget.council.votes!.threshold}';
    int thresholdNay = widget.store.gov!.council.members!.length -
        widget.council.votes!.threshold! +
        1;
    
    final String voteCountNay =
        '${widget.council.votes!.nays!.length}/$thresholdNay';

    return Container(
      padding: EdgeInsets.only(bottom: 24),
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
                      e == 0
                          ? '${dic.aye}($voteCountAye)'
                          : '${dic.nay}($voteCountNay)',
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
                ? widget.council.votes!.ayes!.map((e) {
                    final Map? accInfo =
                        widget.store.account!.addressIndexMap[e];
                    if (widget.store.gov!.council.members!
                            .indexWhere((i) => i[0] == e) ==
                        -1) {
                      return Container();
                    }
                    return CandidateItem(
                      accInfo: accInfo,
                      balance: widget.store.gov!.council.members!
                          .firstWhere((i) => i[0] == e),
                      tokenSymbol: symbol,
                      decimals: decimals,
                    );
                  }).toList()
                : widget.council.votes!.nays!.map((e) {
                    final Map? accInfo =
                        widget.store.account!.addressIndexMap[e];
                    if (widget.store.gov!.council.members!
                            .indexWhere((i) => i[0] == e) ==
                        -1) {
                      return Container();
                    }
                    return CandidateItem(
                      accInfo: accInfo,
                      balance: widget.store.gov!.council.members!
                          .firstWhere((i) => i[0] == e),
                      tokenSymbol: symbol,
                      decimals: decimals,
                    );
                  }).toList(),
          )
        ],
      ),
    );
  }
}

class ExternalLinks extends StatelessWidget {
  ExternalLinks(this.links);

  final List links;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        links.length > 0
            ? Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    JumpToBrowserLink(
                      links[0]['link'],
                      text: links[0]['name'],
                    ),
                    links.length > 1
                        ? JumpToBrowserLink(
                            links[1]['link'],
                            text: links[1]['name'],
                          )
                        : Container(width: 80)
                  ],
                ),
              )
            : Container(),
        links.length > 2
            ? Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    JumpToBrowserLink(
                      links[2]['link'],
                      text: links[2]['name'],
                    ),
                    links.length > 3
                        ? JumpToBrowserLink(
                            links[3]['link'],
                            text: links[3]['name'],
                          )
                        : Container(width: 80)
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}

class ProposalClose extends StatelessWidget {
  const ProposalClose(
      {required this.store,
      required this.council,
      required this.close,
      Key? key})
      : super(key: key);
  final AppStore store;
  final CouncilMotionData council;
  final Function close;
  @override
  Widget build(BuildContext context) {
    bool canClose = false;

    int thresholdNay =
        store.gov!.council.members!.length - council.votes!.threshold! + 1;

    if (council.votes!.ayes!.length >= council.votes!.threshold! ||
        council.votes!.nays!.length >= thresholdNay) {
      canClose = true;
    }
    S dic = S.of(context);
    return canClose
        ? Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
            child: ElevatedButton.icon(
              onPressed: () => close(),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)),
              icon: Icon(Icons.clear),
              label: Text(
                dic.close + " " + dic.proposal,
              ),
            ),
          )
        : Container();
  }
}
