import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/nft_token_info_model.dart';
import 'package:dicolite/pages/me/nft/my_nft.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/widgets/nft_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class SellNft extends StatefulWidget {
  const SellNft(this.store);

  static final String route = '/me/nft/SellNft';
  final AppStore store;

  @override
  _SellNftState createState() => _SellNftState(store);
}

class _SellNftState extends State<SellNft> {
  _SellNftState(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _priceCtrl = new TextEditingController();

  bool _enableBtn = false;

  _handleSubmit() async {
    NftTokenInfoModel? nft =
        ModalRoute.of(context)?.settings.arguments as NftTokenInfoModel?;
    if (_formKey.currentState!.validate() && nft != null) {
      int decimals = store.settings!.networkState.tokenDecimals;

      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).sell + " NFT",
        module: 'nft',
        call: 'offerTokenForSale',
        detail: jsonEncode({
          "token": {
            "ClassId": nft.data.classId,
            "TokenId": nft.tokenId,
          },
          "price": Fmt.tokenInt(_priceCtrl.text.trim(), decimals).toString(),
        }),
        params: [
          [
            nft.data.classId,
            nft.tokenId,
          ],
          Fmt.tokenInt(_priceCtrl.text.trim(), decimals).toString(),
        ],
        onSuccess: (res) {
          globalMyNFTRefreshKey.currentState?.show();
          globalNftListRefreshKey.currentState?.show();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(MyNft.route));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    NftTokenInfoModel nft =
        ModalRoute.of(context)?.settings.arguments as NftTokenInfoModel;
    return Observer(
      builder: (_) {
        String symbol = store.settings!.networkState.tokenSymbol;
        int decimals = store.settings!.networkState.tokenDecimals;

        return Scaffold(
          appBar: myAppBar(context, dic.sell + " NFT"),
          body: SafeArea(
              child: Column(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: () => setState(
                      () => _enableBtn = _formKey.currentState!.validate()),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      NftItem(nft),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: dic.price,
                            suffix: Text(symbol),
                          ),
                          inputFormatters: [UI.decimalInputFormatter(decimals)],
                          controller: _priceCtrl,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return dic.amount_error;
                            }

                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: dic.sell,
                  onPressed: _enableBtn ? _handleSubmit : null,
                ),
              )
            ],
          )),
        );
      },
    );
  }
}
