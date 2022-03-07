import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/kyc_info_model.dart';
import 'package:dicolite/model/ipfs_node_model.dart';
import 'package:dicolite/model/kyc_application_form_model.dart';
import 'package:dicolite/model/kyc_authentication_model.dart';
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

class KycSwordHolderAudit extends StatefulWidget {
  KycSwordHolderAudit(this.store);
  static final String route = '/me/kyc/KycSwordHolderAudit';
  final AppStore store;

  @override
  _KycSwordHolderAudit createState() => _KycSwordHolderAudit(store);
}

class _KycSwordHolderAudit extends State<KycSwordHolderAudit> {
  _KycSwordHolderAudit(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();
  String _fileds = kycFiledsModelList[0];

  String _authentication = authenticationList[0];
  final TextEditingController _idCtrl = new TextEditingController();
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
    String? res = await webApi?.dico?.decryptKYCMessage(context,
        appliData!.message!.substring(2, 90), appliData!.ias.curvePublicKey);
   
    if (res != null && res.isNotEmpty) {
      setState(() {
        hash = res;
      });
    }
    Loading.hideLoading(context);
  }

  Future _submit() async {
    if (_formKey.currentState!.validate() && appliData != null) {
      String id =
          authenticationList[0] != _authentication ? '' : _idCtrl.text.trim();
      var bytes = utf8.encode(id);
      Digest idOut = sha1.convert(bytes);
      String idData = "0x$idOut";
      TxConfirmParams args = TxConfirmParams(
        title: S.of(context).set_kyc,
        
          module: 'kyc',
          call: 'swordHolderProvideJudgement',
        detail: jsonEncode({
          "kycFields": _fileds,
          "kycIndex": appliData!.swordHolderIndex,
          "target": appliData!.sender,
          "auth": _authentication,
          "id": idData,
        }),
        params: [
          _fileds,
          appliData!.iasIndex,
          appliData!.sender,
          _authentication,
          idData,
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
      appBar: myAppBar(context, "SwordHolder " + dic.audit),
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
                                child: Column(
                                  children: [
                                    KycInfoWidget(_senderKycInfo!),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "IAS " + dic.judgement,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        Text(
                                          _senderKycInfo!.iasJudgement,
                                          style: TextStyle(
                                              color: _senderKycInfo!
                                                          .iasJudgement ==
                                                      judgementList[0]
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.pink),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                  15,
                                ),
                                child: DropdownButtonFormField(
                                  value: _authentication,
                                  items: authenticationList
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
                                      _authentication = v as String;
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
                              authenticationList[0] == _authentication
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
                                        validator: (v) {
                                          String val = v!.trim();
                                          if (authenticationList[0] !=
                                              _authentication) {
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
                    onPressed: _enableBtn && hash != null ? _submit : null,
                  ),
                ),
              ],
            ),
    );
  }
}
