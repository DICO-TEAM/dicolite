import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:dicolite/config/config.dart';

import 'package:dicolite/widgets/no_data.dart';

class ListTail extends StatelessWidget {
  ListTail({required this.isEmpty,required this.isLoading});
  final bool isLoading;
  final bool isEmpty;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16),
          child: isLoading
              ? CupertinoActivityIndicator()
              : isEmpty
                  ? NoData()
                  : Text(
                      S.of(context).end,
                      style: TextStyle(fontSize: Adapt.px(30), color: Config.color999),
                    ),
        )
      ],
    );
  }
}
