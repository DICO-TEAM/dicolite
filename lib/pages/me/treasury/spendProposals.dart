import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/common/settings.dart';
import 'package:dicolite/pages/me/treasury/spendProposalPage.dart';
import 'package:dicolite/pages/me/treasury/submitProposalPage.dart';
import 'package:dicolite/pages/me/treasury/submitTipPage.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/gov/types/treasuryOverviewData.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/bordered_title.dart';
import 'package:dicolite/widgets/list_tail.dart';
import 'package:dicolite/widgets/info_item.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class SpendProposals extends StatefulWidget {
  SpendProposals(this.store);

  final AppStore store;

  @override
  _ProposalsState createState() => _ProposalsState();
}

class _ProposalsState extends State<SpendProposals> {
  Future<void> _fetchData() async {
    await webApi?.gov?.fetchTreasuryOverview();
  }

  int _getSpendPeriod() {
    int spendDays = 0;
    if (widget.store.settings!.networkConst['treasury'] != null) {
      final int period =
          int.parse(widget.store.settings!.networkConst['treasury']['spendPeriod'].toString());
      final int blockTime =widget.store.settings?.blockDuration??0;
      spendDays = period * (blockTime ~/ 1000) ~/ SECONDS_OF_DAY;
    }
    return spendDays;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      globalProposalsRefreshKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    return Observer(
      builder: (BuildContext context) {
        final int decimals = widget.store.settings?.networkState.tokenDecimals ??
            Config.tokenDecimals;
        final String symbol =
            widget.store.settings?.networkState.tokenSymbol ?? Config.tokenSymbol;
        String balance = Fmt.balance(
          widget.store.gov!.treasuryOverview.balance??'0',
          decimals,
        );
        bool isCouncil = false;
        widget.store.gov!.council.councilMembers!.forEach((e) {
          if (widget.store.account!.currentAddress == e) {
            isCouncil = true;
          }
        });
        return RefreshIndicator(
          onRefresh: _fetchData,
          key: globalProposalsRefreshKey,
          child: ListView(
            children: <Widget>[
              _OverviewCard(
                symbol: symbol,
                balance: balance,
                spendPeriod: _getSpendPeriod(),
                overview: widget.store.gov!.treasuryOverview,
                isCouncil: isCouncil,
              ),
              Container(
                color: Theme.of(context).cardColor,
                margin: EdgeInsets.only(top: 8),
                child: widget.store.gov!.treasuryOverview.proposals == null
                    ? Center(child: CupertinoActivityIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: BorderedTitle(
                              title: dic.treasury_proposal,
                            ),
                          ),
                          widget.store.gov!.treasuryOverview.proposals != null &&
                                  widget.store.gov!.treasuryOverview.proposals
                                          !.length >
                                      0
                              ? Column(
                                  children: widget
                                      .store.gov!.treasuryOverview.proposals
                                      !.map((e) {
                                    Map accInfo = widget.store.account
                                        !.addressIndexMap[e.proposal!.proposer]!;
                                    return _ProposalItem(
                                      symbol: symbol,
                                      decimals: decimals,
                                      accInfo: accInfo,
                                      proposal: e,
                                    );
                                  }).toList(),
                                )
                              : ListTail(
                                  isEmpty: widget.store.gov!.treasuryOverview
                                          .proposals!.length ==
                                      0,
                                  isLoading: widget.store.gov!.treasuryOverview
                                          .proposals ==
                                      null,
                                ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: BorderedTitle(
                              title: dic.treasury_approval,
                            ),
                          ),
                          widget.store.gov!.treasuryOverview.approvals != null &&
                                  widget.store.gov!.treasuryOverview.approvals
                                          !.length >
                                      0
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 24),
                                  child: Column(
                                    children: widget
                                        .store.gov!.treasuryOverview.approvals!
                                        .map((e) {
                                      Map accInfo = widget.store.account
                                          !.addressIndexMap[e.proposal?.proposer]!;
                                      e.isApproval = true;
                                      return _ProposalItem(
                                        symbol: symbol,
                                        decimals: decimals,
                                        accInfo: accInfo,
                                        proposal: e,
                                      );
                                    }).toList(),
                                  ),
                                )
                              : ListTail(
                                  isEmpty: widget.store.gov!.treasuryOverview
                                          .approvals?.length ==
                                      0,
                                  isLoading: widget.store.gov!.treasuryOverview
                                          .approvals ==
                                      null,
                                ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  _OverviewCard({
   required this.symbol,
   required this.balance,
   required this.spendPeriod,
   required this.overview,
   required this.isCouncil,
  });

  final String symbol;
  final String balance;
  final int spendPeriod;
  final TreasuryOverviewData overview;
  final bool isCouncil;

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    return RoundedCard(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InfoItem(
                crossAxisAlignment: CrossAxisAlignment.center,
                title: dic.treasury_proposal,
                content: overview.proposals?.length.toString()??'',
              ),
              InfoItem(
                crossAxisAlignment: CrossAxisAlignment.center,
                title: dic.treasury_total,
                content: overview.proposalCount.toString(),
              ),
              InfoItem(
                crossAxisAlignment: CrossAxisAlignment.center,
                title: dic.treasury_approval,
                content: overview.approvals?.length.toString()??'',
              ),
            ],
          ),
          Container(height: 24),
          Row(
            children: <Widget>[
              InfoItem(
                crossAxisAlignment: CrossAxisAlignment.center,
                title: '${dic.treasury_available} ($symbol)',
                content: balance,
              ),
              InfoItem(
                crossAxisAlignment: CrossAxisAlignment.center,
                title: dic.treasury_period,
                content: '$spendPeriod days',
              ),
            ],
          ),
          Divider(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: RoundedButton(
                  text: dic.treasury_submit,
                  icon: Icon(Icons.add, color: Theme.of(context).cardColor),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SubmitProposalPage.route);
                  },
                ),
              ),
              Container(width: 16),
              RoundedButton(
                text: dic.treasury_tip,
                icon: Icon(Icons.add, color: Theme.of(context).cardColor),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    SubmitTipPage.route,
                    arguments: isCouncil,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProposalItem extends StatelessWidget {
  _ProposalItem({required this.symbol, required this.decimals, required this.proposal, required this.accInfo});

  final String symbol;
  final int decimals;
  final Map accInfo;
  final SpendProposalData proposal;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AddressIcon(proposal.proposal?.proposer??''),
      title: Fmt.accountDisplayName(proposal.proposal?.proposer??'', accInfo),
      subtitle: Text(
          '${Fmt.balance(proposal.proposal?.value.toString()??'', decimals)} $symbol'),
      trailing: Text(
        '# ${proposal.id}',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(SpendProposalPage.route, arguments: proposal);
      },
    );
  }
}
