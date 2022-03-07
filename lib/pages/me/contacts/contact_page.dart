import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dicolite/pages/me/scan_page.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/utils/loading.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/my_appbar.dart';

class ContactPage extends StatefulWidget {
  ContactPage(this.store);

  static final String route = '/me/contact';
  final AppStore store;

  @override
  _Contact createState() => _Contact(store);
}

class _Contact extends State<ContactPage> {
  _Contact(this.store);
  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressCtrl = new TextEditingController();
  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _memoCtrl = new TextEditingController();

  String? _errAddr;
  bool _enableBtn = false;

  bool _isObservation = false;
  final FocusNode _addrFocusNode = new FocusNode();
  final FocusNode _nameFocusNode = new FocusNode();
  final FocusNode _memoFocusNode = new FocusNode();
  AccountData? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _args = ModalRoute.of(context)!.settings.arguments as AccountData?;
    if (_args != null) {
      _addressCtrl.text = _args!.address;
      _nameCtrl.text = _args?.name ?? "";
      _memoCtrl.text = _args?.memo ?? "";
      _isObservation = _args?.observation ?? false;
    }
  }

  _onSave() async {
    if (_formKey.currentState!.validate()) {
      Loading.showLoading(context);
      var dic = S.of(context);
      String addr = _addressCtrl.text.trim();
      Map? pubKeyAddress = await webApi!.account!.decodeAddress([addr]);

      /// if addresss is invalid
      if (pubKeyAddress == null) {
        setState(() {
          _errAddr = addr;
        });
        _enableBtn = _formKey.currentState!.validate();
        Loading.hideLoading(context);
        return;
      }
      String pubKey = pubKeyAddress.keys.toList()[0];
      Map<String, dynamic> con = {
        'address': addr,
        'name': _nameCtrl.text,
        'memo': _memoCtrl.text,
        'observation': _isObservation,
        'pubKey': pubKey,
      };
      if (_args == null) {
        // create new contact
        int exist =
            store.settings!.contactList.indexWhere((i) => i.address == addr);
        if (exist > -1) {
          Loading.hideLoading(context);
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Container(),
                content: Text(dic.contact_exist),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text(dic.ok),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
          return;
        } else {
          store.settings!.addContact(con);
        }
      } else {
        // edit contact
        store.settings!.updateContact(con);
      }

      // get contact info
      if (_isObservation) {
        webApi!.account!.encodeAddress([pubKey]);
        webApi!.account!.getPubKeyIcons([pubKey]);
      }
      webApi!.account!.getAddressIcons([addr]);
      Loading.hideLoading(context);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _nameCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    List<Widget> action = <Widget>[
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
              showErrorMsg(S.of(context).noCamaraPremission);
            }
          }
        },
      )
    ];
    return Scaffold(
      appBar: myAppBar(
        context,
        dic.contact,
        actions: _args == null ? action : null,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                onChanged: () => setState(
                    () => _enableBtn = _formKey.currentState!.validate()),
                child: ListView(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: dic.contact_address,
                          // labelText: dic.contact_address,
                        ),
                        controller: _addressCtrl,
                        validator: (v) {
                          if (v == null) return null;
                          if (!Fmt.isAddress(v.trim()) ||
                              _errAddr == v.trim()) {
                            return dic.address_error;
                          }
                          if (store.account!.currentAddress == v.trim()) {
                            return dic.doNotAddYourOwnAddresses;
                          }

                          return null;
                        },
                        focusNode: _addrFocusNode,
                        onFieldSubmitted: (v) {
                          _addrFocusNode.nextFocus();
                        },
                        textInputAction: TextInputAction.next,
                        readOnly: _args != null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: dic.contact_name,
                          // labelText: dic.contact_name,
                        ),
                        controller: _nameCtrl,
                        validator: (v) {
                          if (v == null) return null;
                          return v.trim().length > 0
                              ? null
                              : dic.contact_name_error;
                        },
                        focusNode: _nameFocusNode,
                        onFieldSubmitted: (v) {
                          _nameFocusNode.nextFocus();
                        },
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: dic.contact_memo,
                          // labelText: dic.contact_memo,
                        ),
                        controller: _memoCtrl,
                        focusNode: _memoFocusNode,
                        onFieldSubmitted: (v) {
                          if (_enableBtn) {
                            _onSave();
                          }
                        },
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _isObservation,
                          onChanged: (v) {
                            if (v != null && mounted)
                              setState(() {
                                _isObservation = v;
                              });
                          },
                        ),
                        GestureDetector(
                          child: Text(dic.observe),
                          onTap: () {
                            setState(() {
                              _isObservation = !_isObservation;
                            });
                          },
                        ),
                        Tooltip(
                          message: dic.observe_brief,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.info_outline, size: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: RoundedButton(
                text: dic.contact_save,
                onPressed: _enableBtn ? _onSave : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
