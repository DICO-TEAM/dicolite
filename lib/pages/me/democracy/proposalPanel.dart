import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/pages/me/democracy/proposalDetailPage.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/gov/types/proposalInfoData.dart';
import 'package:dicolite/store/gov/types/treasuryOverviewData.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class ProposalPanel extends StatefulWidget {
  ProposalPanel(this.store, this.proposal);

  final AppStore store;
  final ProposalInfoData proposal;

  @override
  _ProposalPanelState createState() => _ProposalPanelState();
}

class _ProposalPanelState extends State<ProposalPanel> {
  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    final int decimals = widget.store.settings!.networkState.tokenDecimals;
    final String symbol = widget.store.settings!.networkState.tokenSymbol;
    final CouncilProposalData? proposalMeta = widget.proposal.image?.proposal;
    final Map? accInfo =
        widget.store.account!.addressIndexMap[widget.proposal.proposer];
    final List seconding = widget.proposal.seconds.toList();
    seconding.removeAt(0);
    return GestureDetector(
      child: RoundedCard(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  proposalMeta != null
                      ? '${proposalMeta.section}.${proposalMeta.method}'
                      : 'preimage: ${Fmt.address(widget.proposal.imageHash!)}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  '#${widget.proposal.index}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            Divider(height: 24),
            Row(
              children: <Widget>[
                AddressIcon(widget.proposal.proposer),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Fmt.accountDisplayName(
                            widget.proposal.proposer, accInfo),
                        Text(
                          '${dic.treasury_bond}: ${Fmt.balance(
                            widget.proposal.balance.toString(),
                            decimals,
                          )} $symbol',
                          style: TextStyle(
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      seconding.length.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(dic.proposal_seconds)
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context)
          .pushNamed(ProposalDetailPage.route, arguments: widget.proposal),
    );
  }
}
