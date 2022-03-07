import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/council/motionDetailPage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/service/substrate_api/types/genExternalLinksParams.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/gov/types/proposalInfoData.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/bordered_title.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class ProposalDetailPage extends StatefulWidget {
  ProposalDetailPage(this.store);

  static const String route = '/gov/democracy/proposal';

  final AppStore store;

  @override
  _ProposalDetailPageState createState() => _ProposalDetailPageState();
}

class _ProposalDetailPageState extends State<ProposalDetailPage> {
  List? _links;

  Future<List?> _getExternalLinks(int id) async {
    if (_links != null) return _links;

    final List? res = await webApi!.getExternalLinks(
      GenExternalLinksParams.fromJson(
          {'data': id.toString(), 'type': 'proposal'}),
    );
    if (res != null) {
      setState(() {
        _links = res;
      });
    }
    return res;
  }

  Future<void> _fetchData() async {
    await webApi!.gov!.fetchProposals();
  }

  Future<void> _onSwitch() async {
    var dic = S.of(context);
    final ProposalInfoData proposal =
        ModalRoute.of(context)!.settings.arguments as ProposalInfoData;
    TxConfirmParams args = TxConfirmParams(
      title: dic.proposal_second,
      module: 'democracy',
      call: 'second',
      detail: jsonEncode({
        "proposal": proposal.index,
        "seconds": proposal.seconds.length,
      }),
      params: [
        proposal.index,
        proposal.seconds.length,
      ],
      onSuccess: (res) {
        globalProposalDetailRefreshKey.currentState?.show();
      },
    );

    var res = await Navigator.of(context)
        .pushNamed(TxConfirmPage.route, arguments: args);
    if (res != null) {
      Navigator.popUntil(
          context, ModalRoute.withName(ProposalDetailPage.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    final ProposalInfoData proposalPara =
        ModalRoute.of(context)!.settings.arguments as ProposalInfoData;
    return Scaffold(
      appBar: myAppBar(context, '${dic.proposal} #${proposalPara.index}'),
      body: SafeArea(
        child: RefreshIndicator(
          key: globalProposalDetailRefreshKey,
          onRefresh: _fetchData,
          child: Observer(
            builder: (_) {
              final ProposalInfoData proposal = widget.store.gov!.proposals
                  .firstWhere((e) => e.index == proposalPara.index);
              final int decimals =
                  widget.store.settings!.networkState.tokenDecimals;
              final String symbol =
                  widget.store.settings!.networkState.tokenSymbol;
              final List<List<String>> params = [];
              bool hasProposal = false;
              if (proposal.image?.proposal != null) {
                proposal.image!.proposal!.meta!.args!.asMap().forEach((k, v) {
                  params.add([
                    '${v.name}: ${v.type}',
                    proposal.image!.proposal!.args![k].toString()
                  ]);
                });
                hasProposal = true;
              }
              final bool isSecondOn = proposal.seconds
                      .indexOf(widget.store.account!.currentAddress) >=
                  0;
              return ListView(
                children: <Widget>[
                  RoundedCard(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        hasProposal
                            ? Text(
                                '${proposal.image!.proposal!.section}.${proposal.image!.proposal!.method}',
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            : Container(),
                        hasProposal
                            ? Text(proposal
                                .image!.proposal!.meta!.documentation!
                                .trim())
                            : Container(),
                        hasProposal ? Divider(height: 24) : Container(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: ProposalArgsItem(
                            label: Text('Hash'),
                            content: Text(
                              Fmt.address(proposal.imageHash!, pad: 10),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            margin: EdgeInsets.all(0),
                          ),
                        ),
                        params.length > 0
                            ? Text(
                                dic.proposal_params,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .unselectedWidgetColor),
                              )
                            : Container(),
                        params.length > 0
                            ? ProposalArgsList(params)
                            : Container(),
                        Text(
                          dic.treasury_proposer,
                          style: TextStyle(
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: AddressIcon(proposal.proposer),
                          title: Text(Fmt.address(proposal.proposer)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  dic.treasury_bond,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .unselectedWidgetColor),
                                ),
                              ),
                              Text(
                                '${Fmt.balance(proposal.balance.toString(), decimals)} $symbol',
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: _getExternalLinks(proposal.index),
                          builder: (_, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return ExternalLinks(snapshot.data);
                            }
                            return Container();
                          },
                        ),
                        Divider(height: 24),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                dic.proposal_second,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .unselectedWidgetColor),
                              ),
                            ),
                            CupertinoSwitch(
                              value: isSecondOn,
                              onChanged: (res) {
                                if (res) {
                                  _onSwitch();
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ProposalSecondsList(store: widget.store, proposal: proposal),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProposalSecondsList extends StatelessWidget {
  ProposalSecondsList({required this.store, required this.proposal});

  final AppStore store;
  final ProposalInfoData proposal;

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final List seconding = proposal.seconds.toList();
    seconding.removeAt(0);
    return Container(
      padding: EdgeInsets.only(bottom: 24),
      margin: EdgeInsets.only(top: 8),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: BorderedTitle(
                title: '${dic.proposal_seconds}(${seconding.length})'),
          ),
          Column(
            children: seconding.map((e) {
              final Map? accInfo = store.account!.addressIndexMap[e];
              return ListTile(
                leading: AddressIcon(e),
                title: Fmt.accountDisplayName(e, accInfo),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
