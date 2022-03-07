import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/council/council.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/account_info.dart';
import 'package:dicolite/widgets/bordered_title.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class CandidateDetailPage extends StatelessWidget {
  CandidateDetailPage(this.store);
  static final String route = '/gov/candidate';
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final List info = ModalRoute.of(context)!.settings.arguments as List;
    final int decimals = store.settings!.networkState.tokenDecimals;
    final String symbol = store.settings!.networkState.tokenSymbol;
    return Scaffold(
      appBar: myAppBar(context, S.of(context).detail),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            Map? accInfo = store.account!.addressIndexMap[info[0]]!;
            TextStyle? style = Theme.of(context).textTheme.bodyText2;

            Map? voters = Map();
            List voterList = [];
            if (store.gov?.councilVotes != null) {
              voters = store.gov!.councilVotes![info[0]];
              if (voters != null) {
                voterList = voters.keys.toList();
              }
            }
            return ListView(
              children: <Widget>[
                RoundedCard(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AccountInfo(accInfo: accInfo, address: info[0]),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                            '${Fmt.token(BigInt.parse(info[1]), decimals)} $symbol',
                            style: style),
                      ),
                      Text(dic.backing)
                    ],
                  ),
                ),
                voterList.length > 0
                    ? Container(
                        padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                        color: Theme.of(context).cardColor,
                        child: BorderedTitle(
                          title: dic.vote_voter,
                        ),
                      )
                    : Container(),
                Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    children: voterList.map((i) {
                      Map? accInfo = store.account?.addressIndexMap[i];
                      return CandidateItem(
                        accInfo: accInfo,
                        balance: [i, voters?[i]??"0"],
                        tokenSymbol: symbol,
                        decimals: decimals,
                        noTap: true,
                      );
                    }).toList(),
                  ),
                ),
                FutureBuilder(
                  future: webApi!.account!.getAddressIcons(voterList),
                  builder: (_, __) => Container(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
