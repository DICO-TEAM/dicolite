import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/currency_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
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

class TransferPageParams {
  TransferPageParams({
    required this.symbol,
    this.currency,
    this.address,
    required this.redirect,
  });
  final String? address;
  final String redirect;
  final String symbol;
  final CurrencyModel? currency;
}

class TransferPage extends StatefulWidget {
  const TransferPage(this.store);

  static final String route = '/me/assets/transfer';
  final AppStore store;

  @override
  _TransferPageState createState() => _TransferPageState(store);
}

class _TransferPageState extends State<TransferPage> {
  _TransferPageState(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressCtrl = new TextEditingController();
  final TextEditingController _amountCtrl = new TextEditingController();

  String? _tokenSymbol;
  bool _enableBtn = false;
  bool _keepAlive = true;

  Map _fee = Map();

  Future<String> _getTxFee({bool reload = false}) async {
    if (_fee['partialFee'] != null && !reload) {
      return _fee['partialFee'].toString();
    }
    if (store.account!.currentAccount.observation) {
      webApi!.account!.queryRecoverable(store.account!.currentAddress);
    }
    final TransferPageParams routeArgs =
        ModalRoute.of(context)!.settings.arguments as TransferPageParams;

    int decimals = routeArgs.currency?.decimals ??
        store.settings!.networkState.tokenDecimals;

    Map args = routeArgs.currency == null
        ? {
            "txInfo": {
              "module": 'balances',
              "call": _keepAlive ? 'transferKeepAlive' : 'transfer',
              'pubKey': store.account!.currentAccount.pubKey,
              'address': store.account!.currentAddress,
            },
            "params": [
              store.account!.currentAddress,
              Fmt.tokenInt("1", decimals).toString(),
            ],
          }
        : {
            "txInfo": {
              "module": 'currencies',
              "call": 'transfer',
              'pubKey': store.account!.currentAccount.pubKey,
              'address': store.account!.currentAddress
            },
            "params": [
              store.account!.currentAddress,
              routeArgs.currency!.currencyId,
              Fmt.tokenInt("1", decimals).toString(),
            ],
          };

    Map? fee = await webApi!.account!.estimateTxFees(
        args["txInfo"], args['params'],
        rawParam: args['rawParam']);
    if (mounted) {
      setState(() {
        _fee = fee ?? {};
      });
    }
    if (fee == null) return "";
    return fee['partialFee'].toString();
  }

  Future<void> _setMaxAmount(BigInt available, BigInt amountExist, int decimals,
      bool isBaseToken) async {
    final fee = await _getTxFee();
    // keep 1.2 * amount of estimated fee left
    final max = isBaseToken
        ? (available -
            Fmt.balanceInt(fee) -
            (Fmt.balanceInt(fee) ~/ BigInt.from(5)) -
            (_keepAlive ? amountExist : BigInt.zero))
        : available;
    if (mounted) {
      setState(() {
        _amountCtrl.text =
            max > BigInt.zero ? Fmt.bigIntToDecimalString(max, decimals) : '0';
      });
    }
  }

  _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      String symbol = _tokenSymbol ??
          store.settings?.networkState.tokenSymbol ??
          Config.tokenSymbol;
      final TransferPageParams routeArgs =
          ModalRoute.of(context)!.settings.arguments as TransferPageParams;

      int decimals = routeArgs.currency?.decimals ??
          store.settings!.networkState.tokenDecimals;

      TxConfirmParams args = routeArgs.currency == null
          ? TxConfirmParams(
              title: S.of(context).transfer + ' $symbol',
              module: 'balances',
              call: _keepAlive ? 'transferKeepAlive' : 'transfer',
              params: [
                _addressCtrl.text.trim(),
                Fmt.tokenInt(_amountCtrl.text.trim(), decimals).toString(),
              ],
              detail: jsonEncode({
                "dest": _addressCtrl.text.trim(),
                "amount": _amountCtrl.text.trim(),
              }),
            )
          : TxConfirmParams(
              title: S.of(context).transfer + ' $symbol',
              module: 'currencies',
              call: 'transfer',
              params: [
                _addressCtrl.text.trim(),
                routeArgs.currency!.currencyId,
                Fmt.tokenInt(_amountCtrl.text.trim(), decimals).toString(),
              ],
              detail: jsonEncode({
                "dest": _addressCtrl.text.trim(),
                "currencyId": routeArgs.currency!.currencyId,
                "amount": _amountCtrl.text.trim(),
              }),
            );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final TransferPageParams args =
          ModalRoute.of(context)!.settings.arguments as TransferPageParams;
      _getTxFee();
      if (args.address != null) {
        setState(() {
          _addressCtrl.text = args.address!;
        });
      }

      setState(() {
        _tokenSymbol = args.symbol;
      });
    });
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TransferPageParams args =
        ModalRoute.of(context)!.settings.arguments as TransferPageParams;
    final S dic = S.of(context);
    return Observer(
      builder: (_) {
        String baseSymbol = store.settings!.networkState.tokenSymbol;
        int baseDecimals = store.settings!.networkState.tokenDecimals;
        String symbol = _tokenSymbol ??
            store.settings?.networkState.tokenSymbol ??
            Config.tokenSymbol;
        final bool isBaseToken = symbol == baseSymbol;

        int decimals = args.currency?.decimals ??
            store.settings!.networkState.tokenDecimals;
        final existDeposit = Fmt.tokenInt(
            store.settings!.existentialDeposit.toString(), decimals);

        BigInt available = BigInt.zero;

        if (isBaseToken) {
          available =
              store.assets?.balances[symbol]?.transferable ?? BigInt.zero;
        } else {
          List<CurrencyModel> tokens = store.dico?.tokens?.toList() ?? [];
          int i = tokens
              .indexWhere((e) => e.currencyId == args.currency!.currencyId);
          if (i != -1) {
            available = tokens[i].tokenBalance.free;
          }
        }

        return Scaffold(
          appBar:
              myAppBar(context, dic.transfer + " " + symbol, actions: <Widget>[
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
                      TextFormField(
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
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: dic.amount,
                          labelText:
                              '${dic.amount} (${dic.balance}: ${Fmt.token(available, decimals)} $symbol)',
                          suffix: GestureDetector(
                            child: Text(dic.amount_max,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                            onTap: () => _setMaxAmount(
                                available, existDeposit, decimals, isBaseToken),
                          ),
                        ),
                        inputFormatters: [UI.decimalInputFormatter(decimals)],
                        controller: _amountCtrl,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return dic.amount_error;
                          }
                          final input = Fmt.tokenInt(v, decimals);
                          if (isBaseToken) {
                            final feeLeft = available -
                                input -
                                (_keepAlive ? existDeposit : BigInt.zero);
                            BigInt fee = BigInt.zero;
                            if (feeLeft < Fmt.tokenInt('0.02', decimals) &&
                                _fee['partialFee'] != null) {
                              fee =
                                  Fmt.balanceInt(_fee['partialFee'].toString());
                            }
                            if (feeLeft - fee < BigInt.zero) {
                              return dic.amount_low;
                            }
                          } else if (Fmt.bigIntToDecimal(available, decimals) <
                              Decimal.parse(v)) {
                            return dic.amount_low;
                          }

                          return null;
                        },
                      ),
                      isBaseToken
                          ? Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Text(
                                      dic.amount_exist,
                                      style: TextStyle(
                                        fontSize: Adapt.px(32),
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    message: dic.amount_exist_msg,
                                    child: Icon(
                                      Icons.info,
                                      size: Adapt.px(32),
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                    ),
                                  ),
                                  Expanded(child: Container(width: 2)),
                                  Text(
                                    '${store.settings!.existentialDeposit} $baseSymbol',
                                    style: TextStyle(
                                      fontSize: Adapt.px(32),
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      _fee["partialFee"] != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Text(
                                      dic.amount_fee,
                                      style: TextStyle(
                                        fontSize: Adapt.px(32),
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container(width: 2)),
                                  isBaseToken
                                      ? Text(
                                          '${Fmt.priceCeilBigInt(Fmt.balanceInt(_fee["partialFee"].toString()), decimals, lengthMax: 6)} $symbol')
                                      : Text(
                                          '${Fmt.priceCeilBigInt(Fmt.balanceInt(_fee["partialFee"].toString()), baseDecimals, lengthMax: 6)} $baseSymbol'),
                                ],
                              ),
                            )
                          : Container(),
                      isBaseToken
                          ? Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Text(
                                      dic.transfer_alive,
                                      style: TextStyle(
                                        fontSize: Adapt.px(32),
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    message: dic.transfer_alive_msg,
                                    child: Icon(
                                      Icons.info,
                                      size: 16,
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                    ),
                                  ),
                                  Expanded(child: Container(width: 2)),
                                  CupertinoSwitch(
                                    value: _keepAlive,
                                    onChanged: (res) {
                                      setState(() {
                                        _keepAlive = res;
                                      });
                                    },
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: dic.make,
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
