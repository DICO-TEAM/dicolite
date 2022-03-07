import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/material.dart';

class BorderedTitle extends StatelessWidget {
  BorderedTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(width: 3, color: Theme.of(context).primaryColor)),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Adapt.px(40),
            color: Colors.black54),
      ),
    );
  }
}
