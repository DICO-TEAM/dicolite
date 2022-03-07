import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SelectToken extends StatefulWidget {
  const SelectToken(this.store, {Key? key}) : super(key: key);
  static String route = "/ico/SelectToken";

  final AppStore store;

  @override
  _SelectTokenState createState() => _SelectTokenState(store);
}

class SelectListModel {
  String code = '';
  String name = '';
  bool isSelect = false;
  SelectListModel(this.name, this.code);
}

class _SelectTokenState extends State<SelectToken> {
  _SelectTokenState(this.store);
  AppStore store;

  final TextEditingController _searchCtrl = new TextEditingController();
  List<CurrencyModel> listFilter = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    var useTokensInLP = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
        appBar: myAppBar(context, dic.selectToken),
        body: Observer(builder: (_) {
          List<CurrencyModel>? list = [];
          list = useTokensInLP == null
              ? store.dico?.tokensSort.where((e) => !e.isLP).toList()
              : store.dico?.tokensInLPSort;
          if (list == null) {
            return LoadingWidget();
          }
          listFilter = list
              .where((e) => (e.symbol.toUpperCase() + e.currencyId)
                  .contains(_searchCtrl.text.trim().toUpperCase()))
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: dic.searchTip,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    isDense: true,
                  ),
                  onChanged: (v) {
                   
                    if (v.trim().isEmpty) {
                      setState(() {
                        listFilter = list!;
                      });
                    } else {
                      setState(() {
                        listFilter = list!
                            .where((e) =>
                                (e.symbol.toUpperCase() + e.currencyId)
                                    .contains(v.trim().toUpperCase()))
                            .toList();
                      });
                    }
                  },
                ),
              ),
              listFilter.isEmpty
                  ? NoData()
                  : Expanded(
                      child: ListView.builder(
                          itemCount: listFilter.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              minVerticalPadding: 22,
                              leading: Logo(symbol: listFilter[index].symbol),
                              title: Text(listFilter[index].symbol),
                              subtitle: Text(
                                "ID: " + listFilter[index].currencyId,
                                style: TextStyle(fontSize: Adapt.px(24)),
                              ),
                              trailing: Text(Fmt.token(
                                  listFilter[index].tokenBalance.free,
                                  listFilter[index].decimals)),
                              onTap: () {
                                Navigator.pop(context, listFilter[index]);
                              },
                            );
                          }),
                    ),
            ],
          );
        }));
  }
}
