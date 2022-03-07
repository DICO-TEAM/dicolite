import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/common/address_form_item.dart';
import 'package:dicolite/pages/me/contacts/contact_list_page.dart';
import 'package:dicolite/pages/me/treasury/treasuryPage.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

class SubmitProposalPage extends StatefulWidget {
  SubmitProposalPage(this.store);

  static const String route = '/gov/treasury/proposal/add';

  final AppStore store;

  @override
  _SubmitProposalPageState createState() => _SubmitProposalPageState();
}

class _SubmitProposalPageState extends State<SubmitProposalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtrl = new TextEditingController();

  AccountData? _beneficiary;

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      var dic = S.of(context);
      int decimals = widget.store.settings!.networkState.tokenDecimals;
      String amt = _amountCtrl.text.trim();
      String address = Fmt.addressOfAccount(_beneficiary!, widget.store);
      TxConfirmParams args = TxConfirmParams(
        title: dic.treasury_submit,
        
          module: 'treasury',
          call: 'proposeSpend',
        detail: jsonEncode({
          "value": amt,
          "beneficiary": address,
        }),
        params: [
          // "value"
          Fmt.tokenInt(amt, decimals).toString(),
          // "beneficiary"
          address,
        ],
         onSuccess: (res) {
          globalProposalsRefreshKey.currentState?.show();
        },
      );
       var res = await Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args) ;
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(TreasuryPage.route));
       
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _beneficiary = widget.store.account!.currentAccount;
      });
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final int decimals = widget.store.settings!.networkState.tokenDecimals;
    final String symbol = widget.store.settings!.networkState.tokenSymbol;
    final BigInt bondPercentage = Fmt.balanceInt(widget
            .store.settings!.networkConst['treasury']['proposalBond']
            .toString()) *
        BigInt.from(100) ~/
        BigInt.from(1000000);
    final BigInt minBond = Fmt.balanceInt(widget
        .store.settings!.networkConst['treasury']['proposalBondMinimum']
        .toString());
    return Scaffold(
      appBar: myAppBar(context, dic.treasury_submit),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _beneficiary == null
                  ? Container()
                  : ListView(
                      padding: EdgeInsets.all(16),
                      children: <Widget>[
                        AddressFormItem(
                          _beneficiary!,
                          label: dic.treasury_beneficiary,
                          onTap: () async {
                            var acc = await Navigator.of(context)
                                .pushNamed(ContactListPage.route);
                            if (acc != null) {
                              setState(() {
                                _beneficiary = acc as AccountData;
                              });
                            }
                          },
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: dic.amount,
                                  labelText: '${dic.amount} ($symbol)',
                                ),
                                inputFormatters: [
                                  UI.decimalInputFormatter(decimals)
                                ],
                                controller: _amountCtrl,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return dic.amount_error;
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText:
                                      '${dic.treasury_bond} ($symbol)',
                                ),
                                initialValue: '$bondPercentage%',
                                readOnly: true,
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor),
                                validator: (v) {
                                  final BigInt bond = Fmt.tokenInt(
                                          _amountCtrl.text.trim(), decimals) *
                                      bondPercentage ~/
                                      BigInt.from(100);
                                  if (widget.store.assets!.balances[symbol]
                                          !.transferable! <=
                                      bond) {
                                    return dic.amount_low;
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText:
                                      '${dic.treasury_bond_min} ($symbol)',
                                ),
                                initialValue: Fmt.priceCeilBigInt(
                                  minBond,
                                  decimals,
                                  lengthFixed: 3,
                                ),
                                readOnly: true,
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor),
                                validator: (v) {
                                  if (widget.store.assets!.balances[symbol]
                                          !.transferable! <=
                                      minBond) {
                                    return dic.amount_low;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: dic.treasury_submit,
                onPressed: _onSubmit,
              ),
            )
          ],
        ),
      ),
    );
  }
}
