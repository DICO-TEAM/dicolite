import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/treasury/tipDetailPage.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/gov/types/treasuryTipData.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/list_tail.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class MoneyTips extends StatefulWidget {
  MoneyTips(this.store);

  final AppStore store;

  @override
  _ProposalsState createState() => _ProposalsState();
}

class _ProposalsState extends State<MoneyTips> {
  Future<void> _fetchData() async {
    webApi!.gov!.updateBestNumber();
    await webApi!.gov!.fetchTreasuryTips();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      globalTipsRefreshKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        List<TreasuryTipData> tips = [];
        if (widget.store.gov!.treasuryTips != null) {
          tips.addAll(widget.store.gov!.treasuryTips!.reversed);
        }
        return RefreshIndicator(
          key: globalTipsRefreshKey,
          onRefresh: _fetchData,
          child: tips.length == 0
              ? Center(
                  child: ListTail(
                  isEmpty: true,
                  isLoading: false,
                ))
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 32),
                  itemCount: tips.length + 1,
                  itemBuilder: (_, int i) {
                    if (tips.length == i) {
                      return ListTail(
                        isEmpty: false,
                        isLoading: false,
                      );
                    }
                    final TreasuryTipData tip = tips[i];
                    final Map? accInfo =
                        widget.store.account!.addressIndexMap[tip.who];
                    return RoundedCard(
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: ListTile(
                        leading: AddressIcon(tip.who),
                        title: Fmt.accountDisplayName(tip.who, accInfo),
                        subtitle: Text(tip.reason),
                        trailing: Column(
                          children: <Widget>[
                            Text(
                              tip.tips.length.toString(),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(S.of(context).treasury_tipper)
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            TipDetailPage.route,
                            arguments: tip,
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
