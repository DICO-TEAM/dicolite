import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/utils/adapt.dart';


class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:38.0,top: 40),
            child: Image.asset('assets/images/no_data.png',width: Adapt.px(200),),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            S.of(context).data_empty,
            style: TextStyle(color: Config.color999),
          ),
        ],
      ),
    );
  }
}
