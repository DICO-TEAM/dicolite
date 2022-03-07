import 'package:flutter/material.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/address_icon.dart';

class AccountInfo extends StatelessWidget {
  AccountInfo({this.accInfo, required this.address});
  final Map? accInfo;
  final String address;
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    bool hasJudgements = false;
    if (accInfo != null) {
      List<Widget> ls = [];
      accInfo!['identity'].keys.forEach((k) {
        if (k != 'judgements' && k != 'other') {
          String content = accInfo!['identity'][k].toString();
          if (k == 'parent') {
            content = Fmt.address(content);
          }
          ls.add(Row(
            children: <Widget>[
              Container(
                width: 80,
                child: Text(k),
              ),
              Text(content),
            ],
          ));
        }
      });
      List judgements = accInfo!['identity']['judgements'];
      hasJudgements = judgements.length > 0;

      if (ls.length > 0) {
        list.add(Divider());
        list.add(Container(height: 4));
        list.addAll(ls);
      }
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: AddressIcon(address),
        ),
//        accInfo != null ? Text(accInfo['accountIndex']) : Container(),
        GestureDetector(
          onTap: () => copy(context, address),
          child: Container(
            width: Adapt.px(350),
            height: Adapt.px(44),
            decoration: BoxDecoration(
              color: Color(0xFFF7F7F7),
              borderRadius: BorderRadiusDirectional.circular(Adapt.px(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                hasJudgements
                    ? Container(
                        width: 16,
                        margin: EdgeInsets.only(right: 8),
                        child: Image.asset(
                            'assets/images/main/receive-success.png'),
                      )
                    : Container(),
                Text(
                  Fmt.address(address),
                  style: TextStyle(color: Config.color999),
                ),
                SizedBox(width: 5),
                Image.asset('assets/images/main/copy999.png')
              ],
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Padding(
        //       padding: EdgeInsets.only(right: 16),
        //       child: JumpToBrowserLink(
        //         'https://polkascan.io/pre/kusama/module/account/$address',
        //         text: 'Polkascan',
        //       ),
        //     ),
        //     JumpToBrowserLink(
        //       'https://kusama.subscan.io/account/$address',
        //       text: 'Subscan',
        //     ),
        //   ],
        // ),
        accInfo == null
            ? Container()
            : Container(
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 4),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: list),
              )
      ],
    );
  }
}
