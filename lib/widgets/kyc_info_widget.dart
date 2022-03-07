import 'package:dicolite/config/country_code_english.dart';
import 'package:dicolite/model/kyc_info_model.dart';
import 'package:dicolite/model/kyc_fileds_model.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:flutter/material.dart';

class KycInfoWidget extends StatelessWidget {
  const KycInfoWidget(this.kycInfo, {Key? key}) : super(key: key);
  final KycInfoModel kycInfo;

  @override
  Widget build(BuildContext context) {
    String area = kycInfo.info.area;
    int index = countryCodeEnglish
        .indexWhere((element) => element["code"] == kycInfo.info.area);
    if (index != -1) {
      area = countryCodeEnglish[index]["name"]! + "(${kycInfo.info.area})";
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              KycFiledsModel.Area.toString().split(".")[1],
              style: TextStyle(color: Colors.black54),
            ),
            TextButton(
              onPressed: () => copy(context, area),
              child: Text(
                area,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        kycInfo.info.name.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    KycFiledsModel.Name.toString().split(".")[1],
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                    onPressed: () => copy(context, kycInfo.info.name),
                    child: Text(
                      kycInfo.info.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            : Container(),
        kycInfo.info.email.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    KycFiledsModel.Email.toString().split(".")[1],
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                    onPressed: () => copy(context, kycInfo.info.email),
                    child: Text(
                      kycInfo.info.email,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              KycFiledsModel.CurvePubicKey.toString().split(".")[1],
              style: TextStyle(color: Colors.black54),
            ),
            TextButton(
              onPressed: () => copy(context, kycInfo.info.curvePublicKey),
              child: Text(
                Fmt.address(kycInfo.info.curvePublicKey),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
