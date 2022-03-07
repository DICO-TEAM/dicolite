import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/kyc_info_model.dart';
import 'package:dicolite/model/ipfs_node_model.dart';
import 'package:dicolite/model/kyc_application_form_model.dart';
import 'package:dicolite/model/kyc_fileds_model.dart';
import 'package:dicolite/model/kyc_judgement_model.dart';
import 'package:dicolite/pages/me/kyc/audit/view_image.dart';
import 'package:dicolite/pages/me/kyc/kyc.dart';
import 'package:dicolite/pages/me/tx_confirm_page.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/loading.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/kyc_info_widget.dart';
import 'package:dicolite/widgets/loading_widget.dart';

import 'package:flutter/material.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:crypto/crypto.dart';


class KycIasAudit extends StatefulWidget {
  KycIasAudit(this.store);
  static final String route = '/me/kyc/KycIasAudit';
  final AppStore store;

  @override
  _KycIasAudit createState() => _KycIasAudit(store);
}

class _KycIasAudit extends State<KycIasAudit> {
  _KycIasAudit(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();
  String _fileds = kycFiledsModelList[0];

  String _judgement = judgementList[0];
  final TextEditingController _idCtrl = new TextEditingController();
  final TextEditingController _messageCtrl = new TextEditingController();
  bool _enableBtn = false;
  KycApplicationFormModel? appliData;
  KycInfoModel? _senderKycInfo;
  String? hash;
  IpfsNodeModel? selectIPFSnode;

  bool loadingImage = false;

  @override
  void initState() {
    super.initState();
    selectIPFSnode = IpfsNodeModel.fromJson(Config.ipfsNodeList[0]);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var args =
          ModalRoute.of(context)!.settings.arguments as KycApplicationFormModel;
      setState(() {
        appliData = args;
      });
      _getSenderKycInfo(args.sender);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageCtrl.dispose();
    _idCtrl.dispose();
  }

  Future _getSenderKycInfo(String? sender) async {
    if (sender == null) return;
    var list = await webApi?.dico?.fetchKYCInfo(addr: sender);

    if (list != null && mounted) {
      KycInfoModel senderKycInfo = KycInfoModel.fromJson(list[0]);

      setState(() {
        _senderKycInfo = senderKycInfo;
      });
    }
  }

  Future _getImageHash() async {
    if (_senderKycInfo?.info.curvePublicKey == null || appliData == null)
      return;
    Loading.showLoading(context);
    String? res = await webApi?.dico?.decryptKYCMessage(
        context,
        appliData!.message!.substring(2, 90),
        _senderKycInfo!.info.curvePublicKey);
  
    if (res != null && res.isNotEmpty) {
      setState(() {
        hash = res;
      });
    }
    Loading.hideLoading(context);
  }

  Future _encryptKYCMessage() async {
    if (hash == null) return;
    Loading.showLoading(context);
    String? res = await webApi?.dico?.encryptKYCMessage(
        context, hash!, appliData!.swordHolder.curvePublicKey);
   
    if (res != null && res.isNotEmpty) {
      setState(() {
        _messageCtrl.text = "0x" + res + Config.kycMessageSuffix;
      });
    }
    Loading.hideLoading(context);
  }

  Future _submit() async {
    if (_formKey.currentState!.validate() && appliData != null) {
      String id = judgementList[0] != _judgement ? '' : _idCtrl.text.trim();
      var bytes = utf8.encode(id);
      Digest idOut = sha1.convert(bytes);
      String idData = "0x$idOut";
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).set_kyc,
        
          module: 'kyc',
          call: 'iasProvideJudgement',
        detail: jsonEncode({
          "kycFields": _fileds,
          "kycIndex": appliData!.iasIndex,
          "target": appliData!.sender,
          "judgement": _judgement,
          "id": idData,
          "message": _messageCtrl.text.trim()
        }),
        params: [
          _fileds,
          appliData!.iasIndex,
          appliData!.sender,
          _judgement,
          idData,
          _messageCtrl.text.trim()
        ],
         onSuccess: (res) {
          globalKycInfoRefreshKey.currentState?.show();
        },
      );

      
     var res = await Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args) ;
      if (res != null) {
        Navigator.popUntil(context, ModalRoute.withName(Kyc.route));
       
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);

    return Scaffold(
      appBar: myAppBar(context, "IAS " + dic.audit),
      body: _senderKycInfo == null
          ? LoadingWidget()
          : Column(
              children: <Widget>[
                Expanded(
                  child: hash != null
                      ? Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: () => setState(() =>
                              _enableBtn = _formKey.currentState!.validate()),
                          child: ListView(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(15),
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(new FadeRoute(
                                        page: ViewImage(
                                      imageProvider: NetworkImage(
                                          selectIPFSnode!.url + "/ipfs/$hash"),
                                      heroTag: 'simple',
                                      minScale:
                                          PhotoViewComputedScale.contained *
                                              0.5,
                                      maxScale:
                                          PhotoViewComputedScale.contained * 3,
                                      backgroundDecoration:
                                          BoxDecoration(color: Colors.black),
                                    )));
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    imageUrl:
                                        selectIPFSnode!.url + "/ipfs/$hash",
                                    placeholder: (context, url) => Container(
                                      width: 200,
                                      height: 200,
                                      color: Colors.grey[200],
                                      child: LoadingWidget(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 200,
                                      height: 200,
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: Text(
                                          dic.image_load_error,
                                          style: TextStyle(
                                              color: Config.errorColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(15),
                                child: KycInfoWidget(_senderKycInfo!),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                  15,
                                ),
                                child: DropdownButtonFormField(
                                  value: _judgement,
                                  items: judgementList
                                      .map((f) => DropdownMenuItem(
                                            child: Container(
                                              width: Adapt.px(560),
                                              child: Text(
                                                f,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            value: f,
                                          ))
                                      .toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      _judgement = v as String;
                                      _enableBtn = _formKey.currentState!.validate();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 10, 0, 15),
                                      filled: true,
                                      labelText: dic.judgement),
                                ),
                              ),
                              judgementList[0] == _judgement
                                  ? Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: dic.kyc_info_id,
                                        ),
                                        controller: _idCtrl,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (v){
                                          setState(() {
                                            _messageCtrl.text="";
                                          });
                                        },
                                        validator: (v) {
                                          String val = v!.trim();
                                          if (judgementList[0] != _judgement) {
                                            return null;
                                          }
                                          if (val.isEmpty) {
                                            return dic.required;
                                          }

                                          return null;
                                        },
                                      ),
                                    )
                                  : Container(),
                              Padding(
                                padding: EdgeInsets.all(
                                  15,
                                ),
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          onPressed: hash != null
                                              ? _encryptKYCMessage
                                              : null,
                                          child: Text(dic.generate),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ),
                hash == null
                    ? Container(
                        margin: EdgeInsets.all(16),
                        child: RoundedButton(
                          text: dic.get_kyc_imageHash,
                          onPressed: _getImageHash,
                        ),
                      )
                    : Container(),
                Container(
                  margin: EdgeInsets.all(16),
                  child: RoundedButton(
                    text: dic.submit,
                    onPressed:_enableBtn&& hash != null ? _submit : null,
                  ),
                ),
              ],
            ),
    );
  }
}
