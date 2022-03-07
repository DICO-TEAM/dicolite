import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/pages/me/council/motionDetailPage.dart';
import 'package:dicolite/pages/me/treasury/treasuryPage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/service/substrate_api/types/genExternalLinksParams.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/gov/types/treasuryOverviewData.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/bordered_title.dart';
import 'package:dicolite/widgets/info_item.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class SpendProposalPage extends StatefulWidget {
  SpendProposalPage(this.store);

  static const String route = '/gov/treasury/proposal';

  final AppStore store;

  @override
  _SpendProposalPageState createState() => _SpendProposalPageState();
}

class _SpendProposalPageState extends State<SpendProposalPage> {
  List? _links;

  Future<List?> _getExternalLinks(int id) async {
    if (_links != null) return _links;

    final List? res = await webApi!.getExternalLinks(
      GenExternalLinksParams.fromJson(
          {'data': id.toString(), 'type': 'treasury'}),
    );
    if (res != null && mounted) {
      setState(() {
        _links = res;
      });
    }
    return res;
  }

  Future<void> _showActions({bool isVote = false}) async {
    final dic = S.of(context);
    final SpendProposalData proposal =
        ModalRoute.of(context)!.settings.arguments as SpendProposalData;
    CouncilProposalData proposalData = CouncilProposalData();
    if (isVote) {
      proposalData = proposal.council![0].proposal!;
    }
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(isVote ? dic.treasury_vote : dic.treasury_send),
        message: isVote
            ? Text('${proposalData.section}.${proposalData.method}()')
            : null,
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(isVote ? dic.yes_text : dic.treasury_approve),
            onPressed: () {
              Navigator.of(context).pop();
              if (isVote) {
                _onVote(true);
              } else {
                _onSendToCouncil(true);
              }
            },
          ),
          CupertinoActionSheetAction(
            child: Text(isVote ? dic.no_text : dic.treasury_reject),
            onPressed: () {
              Navigator.of(context).pop();
              if (isVote) {
                _onVote(false);
              } else {
                _onSendToCouncil(false);
              }
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _onSendToCouncil(bool approve) async {
    var dic = S.of(context);
    final SpendProposalData proposal =
        ModalRoute.of(context)!.settings.arguments as SpendProposalData;
    final String txName =
        'treasury_${approve ? 'approveProposal' : 'rejectProposal'}';
    TxConfirmParams args = TxConfirmParams(
      title: approve ? dic.treasury_approve : dic.treasury_reject,
      module: 'council',
      call: 'propose',
      txName: txName,
      detail: jsonEncode({"proposal": txName, "proposalId": proposal.id}),
      params: [proposal.id],
      onSuccess: (res) {
        globalProposalsRefreshKey.currentState?.show();
      },
    );
    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(TreasuryPage.route));
    }
  }

  Future<void> _onVote(bool approve) async {
    var dic = S.of(context);
    final SpendProposalData proposal =
        ModalRoute.of(context)!.settings.arguments as SpendProposalData;
    final CouncilMotionData councilProposal = proposal.council![0];
    TxConfirmParams args = TxConfirmParams(
      title: dic.treasury_vote,
      module: 'council',
      call: 'vote',
      detail: jsonEncode({
        "councilHash": councilProposal.hash,
        "councilId": councilProposal.votes!.index,
        "voteValue": approve,
      }),
      params: [
        councilProposal.hash,
        councilProposal.votes!.index,
        approve,
      ],
      onSuccess: (res) {
        globalProposalsRefreshKey.currentState?.show();
      },
    );
    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(context, ModalRoute.withName(TreasuryPage.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final String symbol = widget.store.settings!.networkState.tokenSymbol;
    final int decimals = widget.store.settings!.networkState.tokenDecimals;
    final SpendProposalData proposal =
        ModalRoute.of(context)!.settings.arguments as SpendProposalData;
    final AccountData proposer = AccountData();
    final AccountData beneficiary = AccountData();
    proposer.address = proposal.proposal!.proposer!;
    beneficiary.address = proposal.proposal!.beneficiary!;
    final Map? accInfoProposer =
        widget.store.account!.addressIndexMap[proposer.address];
    final Map? accInfoBeneficiary =
        widget.store.account!.addressIndexMap[beneficiary.address];
    bool isCouncil = false;
    widget.store.gov!.council.members!.forEach((e) {
      if (widget.store.account!.currentAddress == e[0]) {
        isCouncil = true;
      }
    });
    final bool isApproval = proposal.isApproval ?? false;
    final bool hasProposals = proposal.council!.length > 0;
    bool isVotedYes = false;
    bool isVotedNo = false;
    if (hasProposals) {
      proposal.council![0].votes!.ayes!.forEach((e) {
        if (e == widget.store.account!.currentAddress) {
          isVotedYes = true;
        }
      });
      proposal.council![0].votes!.nays!.forEach((e) {
        if (e == widget.store.account!.currentAddress) {
          isVotedNo = true;
        }
      });
    }
    return Scaffold(
      appBar: myAppBar(context, '${dic.treasury_proposal} #${proposal.id}'),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            RoundedCard(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: <Widget>[
                        InfoItem(
                          title: dic.treasury_value,
                          content: '${Fmt.balance(
                            proposal.proposal!.value.toString(),
                            decimals,
                          )} $symbol',
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                        InfoItem(
                          title: dic.treasury_bond,
                          content: '${Fmt.balance(
                            proposal.proposal!.bond.toString(),
                            decimals,
                          )} $symbol',
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: AddressIcon(proposal.proposal!.proposer!),
                    title: Fmt.accountDisplayName(
                        proposal.proposal!.proposer!, accInfoProposer),
                    subtitle: Text(dic.treasury_proposer),
                  ),
                  ListTile(
                    leading: AddressIcon(proposal.proposal!.beneficiary!),
                    title: Fmt.accountDisplayName(
                        proposal.proposal!.beneficiary!, accInfoBeneficiary),
                    subtitle: Text(dic.treasury_beneficiary),
                  ),
                  hasProposals
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: ProposalArgsItem(
                            label: Text(dic.proposal),
                            content: Text(
                              '${proposal.council![0].proposal!.section!}.${proposal.council![0].proposal!.method!}',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            margin: EdgeInsets.only(left: 16, right: 16),
                          ),
                        )
                      : Container(),
                  FutureBuilder(
                    future: _getExternalLinks(int.parse(proposal.id!)),
                    builder: (_, AsyncSnapshot<List?> snapshot) {
                      if (snapshot.hasData) {
                        return ExternalLinks(snapshot.data!);
                      }
                      return Container();
                    },
                  ),
                  isApproval
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Divider(),
                        ),
                  isApproval
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: !hasProposals
                              ? RoundedButton(
                                  text: dic.treasury_send,
                                  onPressed:
                                      isCouncil ? () => _showActions() : null,
                                )
                              : ProposalVoteButtonsRow(
                                  isCouncil: isCouncil,
                                  isVotedNo: isVotedNo,
                                  isVotedYes: isVotedYes,
                                  onVote: _onVote,
                                ),
                        ),
                ],
              ),
            ),
            !hasProposals
                ? Container()
                : Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: BorderedTitle(title: dic.vote_voter),
                  ),
            !hasProposals
                ? Container()
                : ProposalVotingList(
                    store: widget.store,
                    council: proposal.council![0],
                  )
          ],
        ),
      ),
    );
  }
}
