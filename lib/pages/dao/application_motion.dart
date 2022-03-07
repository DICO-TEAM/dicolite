import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/ico_model.dart';
import 'package:dicolite/model/ico_request_release_info_model.dart';
import 'package:dicolite/pages/home.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/format.dart';
import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ApplicationMotion extends StatefulWidget {
  ApplicationMotion(this.store);
  static final String route = '/dao/ApplicationMotion';
  final AppStore store;

  @override
  _ApplicationMotion createState() => _ApplicationMotion(store);
}

class _ApplicationMotion extends State<ApplicationMotion> {
  _ApplicationMotion(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonCtrl = new TextEditingController();

  List<IcoModel> list = [];
  IcoModel? _selectIco;
  IcoRequestReleaseInfoModel? _selectIcoRelease;
  bool _enableBtn = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      List<IcoModel> listData = [];
      store.dico!.passedIcoList?.forEach((e) {
        store.dico!.requestReleaseList.forEach((x) {
          if (e.currencyId == x.currencyId &&
              e.index == x.index &&
              e.initiator == x.who) {
            listData.add(e);
          }
        });
      });
      store.dico!.daoProposalList?.forEach((e) {
        for (var i = listData.length - 1; i >= 0; i--) {
          if (e.currencyId == listData[i].currencyId &&
              e.icoIndex == listData[i].index) {
            listData.removeAt(i);
          }
        }
      });
      if (mounted && listData.isNotEmpty) {
        setState(() {
          list = listData;
          _selectIco = listData[0];
          _selectIcoRelease = store.dico!.requestReleaseList.firstWhere((e) =>
              e.currencyId == _selectIco!.currencyId &&
              e.index == _selectIco!.index);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _reasonCtrl.dispose();
  }

  Future _submit() async {
    if (_selectIco != null &&
        _selectIcoRelease != null &&
        _formKey.currentState!.validate()) {
      final String txName = 'dao_propose';

      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).createMotion,
        module: 'dao',
        call: 'propose',
        txName: txName,
        params: [
          _selectIco!.currencyId,
          _selectIco!.index,
          "51",
          _reasonCtrl.text.trim().isEmpty ? null : _reasonCtrl.text.trim(),
        ],
        detail: jsonEncode({
          "currencyId": _selectIco!.currencyId,
          "index": _selectIco!.index,
          "threshold": "51",
          "proposal": "ico.permitRelease(currencyId,index)",
          "reason":
              _reasonCtrl.text.trim().isEmpty ? null : _reasonCtrl.text.trim(),
        }),
        onSuccess: (Map res) {
          globalDaoRefreshKey.currentState?.show();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Home.route));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Observer(builder: (_) {
      return Scaffold(
        appBar: myAppBar(context, dic.createMotion),
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
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(
                          15,
                        ),
                        child: DropdownButtonFormField(
                          value: _selectIco,
                          items: list
                              .map((f) => DropdownMenuItem(
                                    child: Text(
                                      (f.projectName + "(#${f.index})"),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    value: f,
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _selectIco = v as IcoModel;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 0, 15),
                            filled: true,
                            labelText: dic.projectName,
                            helperText: _selectIco != null
                                ? (dic.releaseProgress +
                                    " " +
                                    _selectIcoRelease!.percent.toString() +
                                    "%")
                                : null,
                          ),
                        ),
                      ),
                      _selectIco == null
                          ? Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text(dic.waitApplicationRelease),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(
                          15,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: dic.reason + dic.optional,
                          ),
                          controller: _reasonCtrl,
                          textInputAction: TextInputAction.done,
                          maxLength: 300,
                          validator: (v) {
                            String val = v!.trim();
                            if (val.isNotEmpty && !Fmt.isEnglish(val)) {
                              return dic.pleaseInEnglish;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: RoundedButton(
                  text: dic.submit,
                  onPressed: _selectIco != null && _enableBtn ? _submit : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
