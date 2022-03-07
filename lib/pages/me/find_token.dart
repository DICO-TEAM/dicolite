import 'dart:async';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/loading.dart';
import 'package:dicolite/utils/local_storage.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:flutter/material.dart';


class FindToken extends StatefulWidget {
  static const route = '/me/FindToken';
  FindToken(this.store);
  final AppStore store;
  @override
  _FindTokenState createState() => _FindTokenState(store);
}

class _FindTokenState extends State<FindToken> {
  _FindTokenState(this.store);
  final AppStore store;
  final TextEditingController _searchCtrl = new TextEditingController();

  List<CurrencyModel>? list;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _searchCtrl.dispose();
  }

  /// get all token
  Future _getData() async {
    List? res = await webApi?.dico?.fetchAllTokenInfoList();

    if (mounted && res != null) {
      setState(() {
        list = res.map((e) => CurrencyModel.fromJson(e)).toList();
      });
    }
  }

  Future _submit(CurrencyModel currency) async {
   
      Loading.showLoading(context);
      await LocalStorage.updateTokenToList(currency.toJson());
      await store.dico?.getTokens();
      webApi!.dico!.subTokensBalanceChange();
      Loading.hideLoading(context);
      Navigator.of(context).pop();
   
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Scaffold(
      appBar: myAppBar(context, dic.findToken),
      body: mainWidget(dic),
    );
  }

  mainWidget(S dic) {
    List<CurrencyModel> listFilter = [];

    if (list == null) {
      return LoadingWidget();
    }
    listFilter = list!
        .where((e) => e.currencyId!="0"&&(e.symbol.toUpperCase() + e.currencyId).contains(_searchCtrl.text.trim().toUpperCase()))
        .toList();
    listFilter
        .sort((a, b) => (int.parse(a.currencyId) - int.parse(b.currencyId)));
    listFilter.forEach((element) {
      if (store.dico!.tokens!
              .indexWhere((e) => e.currencyId == element.currencyId) !=
          -1) {
        element.hasAdded = true;
      }
    });
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
                      .where((e) => (e.symbol.toUpperCase() + e.currencyId)
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
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: listFilter[index].hasAdded
                            ? Icon(Icons.check_circle_outline)
                            : Icon(Icons.add_circle_outline,color: Theme.of(context).primaryColor,),
                        onTap: ()=>_submit(listFilter[index]),
                      );
                    }),
              ),
      ],
    );
  }
}
