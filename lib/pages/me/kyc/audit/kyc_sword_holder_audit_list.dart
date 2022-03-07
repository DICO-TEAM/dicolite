
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/kyc_application_form_model.dart';
import 'package:dicolite/pages/me/kyc/audit/kyc_sword_holder_audit.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/address_icon.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/my_tile.dart';
import 'package:dicolite/widgets/no_data.dart';

import 'package:flutter/material.dart';

import 'package:dicolite/widgets/my_appbar.dart';

class KycSwordHolderAuditList extends StatefulWidget {
  KycSwordHolderAuditList(this.store);
  static final String route = '/me/kyc/KycSwordHolderAuditList';
  final AppStore store;

  @override
  _KycSwordHolderAuditList createState() => _KycSwordHolderAuditList(store);
}

class _KycSwordHolderAuditList extends State<KycSwordHolderAuditList> {
  _KycSwordHolderAuditList(this.store);

  final AppStore store;

  List<KycApplicationFormModel>? appliList;

  @override
  void initState() {
    super.initState();
    _getAppliList();
  }

  Future _getAppliList() async {
    List<KycApplicationFormModel>? res =
        await webApi?.dico?.fetchSwordHolderMessageList();

    if (res != null && mounted) {
      setState(() {
        appliList = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);

    return Scaffold(
        appBar: myAppBar(context, "SwordHolder " + dic.audit_list),
        body: RefreshIndicator(
          onRefresh: _getAppliList,
          child: appliList == null
              ? LoadingWidget()
              : appliList!.isEmpty
                  ? NoData()
                  : Container(
                      color: Colors.white,
                      child: ListView(
                        children: appliList!
                            .map((e) => myTile(
                              leading: AddressIcon(e.sender!),
                                  title: e.sender == null
                                      ? ''
                                      : Fmt.address(e.sender),
                                  onTap: () => Navigator.of(context).pushNamed(
                                      KycSwordHolderAudit.route,
                                      arguments: e),
                                  noborder: true,
                                ))
                            .toList(),
                      ),
                    ),
        ));
  }
}
