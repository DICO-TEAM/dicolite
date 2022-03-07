import 'dart:convert';
import 'dart:io';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/ipfs_node_model.dart';
import 'package:dicolite/model/kyc_application_form_model.dart';
import 'package:dicolite/pages/me/kyc/kyc.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/loading.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RequestJudgement extends StatefulWidget {
  RequestJudgement(this.store);
  static final String route = '/me/kyc/requestJudgement';
  final AppStore store;

  @override
  _RequestJudgement createState() => _RequestJudgement(store);
}

class _RequestJudgement extends State<RequestJudgement> {
  _RequestJudgement(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  // final TextEditingController _messageCtrl = new TextEditingController(text:"df41074faa3da03282357906560bded51f76bb16c0e6aea07da7fd46f6592b39fc9010699102d4485fc32d5b6a8cb7093463912b21a6e96d6c22670c38e5549c");
  final TextEditingController _messageCtrl = new TextEditingController();

  bool _enableBtn = false;

  String? fileName;
  String? hash;
  int? size;
  String? filePath;
  IpfsNodeModel? selectIPFSnode;
  List<IpfsNodeModel> selectIPFSnodeList = [];

  KycApplicationFormModel? kycApplicationForm;

  TextStyle boldStyle =
      TextStyle(color: Config.color666, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _getNodeData();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var args =
          ModalRoute.of(context)!.settings.arguments as KycApplicationFormModel;

      kycApplicationForm = args;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _messageCtrl.dispose();
  }

  _getNodeData() {
    setState(() {
      selectIPFSnodeList =
          Config.ipfsNodeList.map((e) => IpfsNodeModel.fromJson(e)).toList();
      selectIPFSnode = selectIPFSnodeList[0];
    });
  }

  Future<void> _upload() async {
    FilePickerResult? result;
    PlatformFile? file;
    try {
      result = await FilePicker.platform.pickFiles(type: FileType.image);
    } on PlatformException catch (e) {
      print(e);
      if (e.message != null) showErrorMsg(e.message!);
      return;
    }

    if (result == null) return;
    file = result.files.first;
   

    if (file.size < 10 * 1024) {
      return showErrorMsg(S.of(context).over_size);
    }
    if (file.size > 20 * 1024 * 1024) {
      return showErrorMsg(S.of(context).less_size);
    }

    List nameList = file.name.split('/');
    if (mounted) {
      setState(() {
        fileName = nameList.last;
      });
    }
    if (file.path == null) return;

    var option = Options(
      method: "POST",
      headers: {"Content-Type": "multipart/form-data"},
    );
    Dio dio = new Dio();
    FormData formData =
        FormData.fromMap({"file": await MultipartFile.fromFile(file.path!)});
    Loading.showLoading(context);
    try {
      var res = await dio.post(
        "${selectIPFSnode!.url}/kyc/add/info",
        data: formData,
        options: option,
        onSendProgress: (int sent, int total) {
          print((sent / total * 100).toStringAsFixed(0) + "%");
        },
      );

      Loading.hideLoading(context);

      if (res.data != null && (res.data as Map)['Hash'] != null && mounted) {
        setState(() {
          hash = (res.data as Map)['Hash'];
          filePath = file?.path;
          size = int.parse((file!.size / 1000).toStringAsFixed(0));
        });

       
      }
    } catch (e) {
      print(e.toString());
      Loading.hideLoading(context);
      showErrorMsg(S.of(context).upload_retry);
    }
  }

  Future _encryptKYCMessage() async {
    Loading.showLoading(context);
    String? res = await webApi?.dico?.encryptKYCMessage(
        context, hash!, kycApplicationForm!.ias.curvePublicKey);
    
    if (res != null && res.isNotEmpty) {
      setState(() {
        _messageCtrl.text = "0x" + res + Config.kycMessageSuffix;
      });
    }
    Loading.hideLoading(context);
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).requestJudgement,
        module: 'kyc',
        call: 'requestJudgement',
        detail: jsonEncode({
          "kycFields": kycApplicationForm!.ias.fields,
          "iasIndex": kycApplicationForm!.iasIndex,
          "message": _messageCtrl.text.trim(),
        }),
        params: [
          kycApplicationForm!.ias.fields,
          kycApplicationForm!.iasIndex,
          _messageCtrl.text.trim()
        ],
        onSuccess: (res) {
          globalKycInfoRefreshKey.currentState?.show();
        },
      );

      var res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: args);
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Kyc.route));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    return Observer(builder: (_) {
      return Scaffold(
        appBar: myAppBar(context, dic.requestJudgement),
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
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Text(
                                dic.kyc_info_upload_tip1,
                              ),
                              Text(
                                dic.kyc_info_upload_tip2,
                                style: boldStyle,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: _upload,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    filePath != null
                                        ? Image.file(
                                            File(filePath!),
                                          )
                                        : Image.asset(
                                            'assets/images/dico/certificate.jpg'),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      hash == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "hash:",
                                    style: TextStyle(
                                        color: Config.color666,
                                        fontSize: Adapt.px(28)),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    hash ?? '',
                                    style: TextStyle(
                                        color: Config.color666,
                                        fontSize: Adapt.px(18)),
                                  ),
                                ],
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.all(
                          15,
                        ),
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: dic.kyc_message,
                                  ),
                                  readOnly: true,
                                  controller: _messageCtrl,
                                  textInputAction: TextInputAction.done,
                                  validator: (v) {
                                    String val = v!.trim();
                                    if (val.isEmpty) {
                                      return dic.required;
                                    } else if (val.length != 128) {
                                      return dic.formatMistake;
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 6,
                                  right: 6,
                                ),
                                child: ElevatedButton(
                                  onPressed:
                                      hash != null ? _encryptKYCMessage : null,
                                  child: Text(dic.generate),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(dic.tips_kyc_info),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: RoundedButton(
                  text: dic.submit,
                  onPressed: _enableBtn ? _submit : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
