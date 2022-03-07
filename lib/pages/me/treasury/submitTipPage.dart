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

class SubmitTipPage extends StatefulWidget {
  SubmitTipPage(this.store);

  static const String route = '/gov/treasury/tip/add';

  final AppStore store;

  @override
  _SubmitTipPageState createState() => _SubmitTipPageState();
}

class _SubmitTipPageState extends State<SubmitTipPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtrl = new TextEditingController();
  final TextEditingController _reasonCtrl = new TextEditingController();
  static const MAX_REASON_LEN = 128;
  static const MIN_REASON_LEN = 5;

  AccountData? _beneficiary;

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      var dic = S.of(context);
      final int decimals = widget.store.settings!.networkState.tokenDecimals;
      final bool isCouncil = ModalRoute.of(context)!.settings.arguments as bool;
      final String amt = _amountCtrl.text.trim();
      final String address = Fmt.addressOfAccount(_beneficiary!, widget.store);
      TxConfirmParams args = TxConfirmParams(
        title: isCouncil ? dic.treasury_tipNew : dic.treasury_report,
        
          module: 'treasury',
          call: isCouncil ? 'tipNew' : 'reportAwesome',
        detail: jsonEncode(isCouncil
            ? {
                "beneficiary": address,
                "reason": _reasonCtrl.text.trim(),
                "value": amt,
              }
            : {
                "beneficiary": address,
                "reason": _reasonCtrl.text.trim(),
              }),
        params: isCouncil
            ? [
                // "reason"
                _reasonCtrl.text.trim(),
                // "beneficiary"
                address,
                // "value"
                Fmt.tokenInt(amt, decimals).toString(),
              ]
            : [
                // "reason"
                _reasonCtrl.text.trim(),
                // "beneficiary"
                address,
              ],
       
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
    _reasonCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);
    final int decimals = widget.store.settings!.networkState.tokenDecimals;
    final String symbol = widget.store.settings!.networkState.tokenSymbol;
    final bool isCouncil = ModalRoute.of(context)!.settings.arguments as bool;
    return Scaffold(
      appBar: myAppBar(context, isCouncil ? dic.treasury_tipNew : dic.treasury_report),
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
                            final acc = await Navigator.of(context)
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
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: dic.treasury_reason,
                                  labelText: dic.treasury_reason,
                                ),
                                controller: _reasonCtrl,
                                maxLines: 3,
                                validator: (v) {
                                  final String reason = v!.trim();
                                  if (reason.length < MIN_REASON_LEN ||
                                      reason.length > MAX_REASON_LEN) {
                                    return S.of(context).input_invalid;
                                  }
                                  return null;
                                },
                              ),
                              isCouncil
                                  ? TextFormField(
                                      decoration: InputDecoration(
                                        hintText: dic.amount,
                                        labelText:
                                            '${dic.amount} ($symbol)',
                                      ),
                                      inputFormatters: [
                                        UI.decimalInputFormatter(decimals)
                                      ],
                                      controller: _amountCtrl,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      validator: (v) {
                                        if (v!.isEmpty) {
                                          return dic.amount_error;
                                        }
                                        return null;
                                      },
                                    )
                                  : Container(),
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
