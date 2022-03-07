import 'dart:convert';

import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/utils/local_storage.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/my_appbar.dart';

class CustomTypes extends StatefulWidget {
  CustomTypes(this.store);
  static const route = '/me/setting/CustomTypes';
  final AppStore store;
  @override
  _CustomTypesState createState() => _CustomTypesState(store);
}

class _CustomTypesState extends State<CustomTypes> {
  _CustomTypesState(this.store);

  final AppStore store;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typesCtrl = new TextEditingController();
  bool _enableBtn = true;

  @override
  void initState() {
    super.initState();
    _getTypes();
  }

  @override
  void dispose() {
    _typesCtrl.dispose();
    super.dispose();
  }

  Future<void> _getTypes() async {
    String? types = await LocalStorage.getCustomTypes();
    if (types != null) {
      try {
        jsonDecode(types);
        setState(() {
          _typesCtrl.text = types;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? types;
        if (_typesCtrl.text.trim().isNotEmpty) {
          jsonEncode(_typesCtrl.text.trim());
          types = _typesCtrl.text.trim();
        } else {
          types = null;
        }

        LocalStorage.setCustomTypes(types);
        webApi?.changeNode();
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    return Scaffold(
      appBar: myAppBar(context, dic.custom_types),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: () => setState(
                () => _enableBtn = _formKey.currentState!.validate(),
              ),
              child: ListView(
                padding: EdgeInsets.all(Adapt.px(30)),
                children: <Widget>[
                 
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText:dic.add_custom_types, 
                    ),
                    onFieldSubmitted: (v) {
                      if (_enableBtn) {
                        _onSave();
                      }
                    },
                    scrollPadding: EdgeInsets.all(5),
                    maxLines: 15,
                    minLines: 2,
                    maxLength: 30000,
                    validator: (v) {
                      if (v!.trim().isNotEmpty) {
                        try {
                          jsonDecode(v.trim());
                        } catch (e) {
                          return S.of(context).formatMistake;
                        }
                      }

                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    controller: _typesCtrl,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Config.secondColor),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: Text(
                            S.of(context).copy,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            copy(context, _typesCtrl.text.trim());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Config.errorColor),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: Text(
                            dic.clear,
                          ),
                          onPressed: () {
                            WidgetsBinding.instance!
                                .addPostFrameCallback((_) => _typesCtrl.clear());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text(
                            S.of(context).save,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _enableBtn ? _onSave : null,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
