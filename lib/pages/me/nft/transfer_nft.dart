import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/nft_token_info_model.dart';
import 'package:dicolite/pages/me/nft/my_nft.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/widgets/nft_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/pages/me/contacts/contact_list_page.dart';
import 'package:dicolite/pages/me/scan_page.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class TransferNft extends StatefulWidget {
  const TransferNft(this.store);

  static final String route = '/me/nft/TransferNft';
  final AppStore store;

  @override
  _TransferNftState createState() => _TransferNftState(store);
}

class _TransferNftState extends State<TransferNft> {
  _TransferNftState(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressCtrl = new TextEditingController();

  bool _enableBtn = false;

  _handleSubmit() async {
    NftTokenInfoModel? nft =
        ModalRoute.of(context)?.settings.arguments as NftTokenInfoModel?;
    if (_formKey.currentState!.validate() && nft != null) {
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).transfer,
        module: 'nft',
        call: 'transfer',
        detail: jsonEncode({
          "to": _addressCtrl.text.trim(),
          "token": {
            "ClassId": nft.data.classId,
            "TokenId": nft.tokenId,
          },
        }),
        params: [
          _addressCtrl.text.trim(),
          [
            nft.data.classId,
            nft.tokenId,
          ],
        ],
        onSuccess: (res) {
          globalMyNFTRefreshKey.currentState?.show();
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
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    return Observer(
      builder: (_) {
        NftTokenInfoModel nft =
            ModalRoute.of(context)?.settings.arguments as NftTokenInfoModel;

        return Scaffold(
          appBar: myAppBar(context, dic.send + " NFT", actions: <Widget>[
            IconButton(
              icon: Image.asset('assets/images/main/scan.png'),
              onPressed: () async {
                try {
                  var to = await Navigator.pushNamed(context, ScanPage.route);
                  if (to != null) {
                    _addressCtrl.text = to.toString();
                  }
                } catch (e) {
                  if (e is PlatformException) {
                    showErrorMsg(dic.noCamaraPremission);
                  }
                }
              },
            )
          ]),
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
                            hintText: dic.toAddress,
                            labelText: dic.toAddress,
                            suffix: GestureDetector(
                              child: Image.asset(
                                  'assets/images/main/my-accountmanage.png'),
                              onTap: () async {
                                var to = await Navigator.of(context)
                                    .pushNamed(ContactListPage.route);
                                if (to != null && mounted) {
                                  setState(() {
                                    _addressCtrl.text =
                                        (to as AccountData).address;
                                  });
                                }
                              },
                            ),
                          ),
                          controller: _addressCtrl,
                          validator: (v) {
                            if (v!.trim().isEmpty) {
                              return dic.required;
                            }
                            return Fmt.isAddress(v.trim())
                                ? null
                                : dic.address_error;
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
                  text: dic.send,
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
