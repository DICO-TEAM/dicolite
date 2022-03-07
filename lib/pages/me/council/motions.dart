import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/council/motionDetailPage.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/list_tail.dart';
import 'package:dicolite/widgets/rounded_card.dart';

class Motions extends StatefulWidget {
  Motions(this.store);

  final AppStore store;

  @override
  _MotionsState createState() => _MotionsState();
}

class _MotionsState extends State<Motions> {
  Future<void> _fetchData() async {
    webApi!.gov!.updateBestNumber();
    await webApi!.gov!.fetchCouncilMotions();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      globalMotionsRefreshKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    return Observer(
      builder: (BuildContext context) {
        return RefreshIndicator(
          onRefresh: _fetchData,
          key: globalMotionsRefreshKey,
          child: widget.store.gov!.councilMotions.length == 0
              ? Center(
                  child: ListTail(isEmpty: true, isLoading: false),
                )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: widget.store.gov!.councilMotions.length + 1,
                    itemBuilder: (_, int i) {
                      if (i == widget.store.gov!.councilMotions.length) {
                        return Center(
                          child: ListTail(isEmpty: false, isLoading: false),
                        );
                      }
                      final e = widget.store.gov!.councilMotions[i];
                      return RoundedCard(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: ListTile(
                          title: Text(
                              '#${e.votes!.index} ${e.proposal!.section}.${e.proposal!.method}'),
                          subtitle: Text(e.proposal!.meta!.documentation!.trim()),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${e.votes!.ayes!.length}/${e.votes!.threshold}',
                                style: TextStyle(fontSize: Adapt.px(32)),
                              ),
                              Text(dic.yes),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(MotionDetailPage.route, arguments: e);
                          },
                        ),
                      );
                    }),
              ),
        );
      },
    );
  }
}
