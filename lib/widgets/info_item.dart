import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  InfoItem({required this.title, this.content, this.crossAxisAlignment});
  final String title;
  final String? content;
  final CrossAxisAlignment? crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: Adapt.px(24)),
          ),
          Text(
            content ?? '-',
            style: TextStyle(
              fontSize: Adapt.px(28),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).unselectedWidgetColor,
            ),
          )
        ],
      ),
    );
  }
}
