import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/material.dart';

class TopTabs extends StatelessWidget {
  TopTabs(
      {required this.names,
      required this.activeTab,
      required this.onTab,
      this.activeColor,
      this.unselectColor});

  final List<String> names;
  final Function(int) onTab;
  final int activeTab;
  final Color? activeColor;
  final Color? unselectColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: names.map(
        (title) {
          int index = names.indexOf(title);
          return GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  // width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: Adapt.px(40),
                            color: activeTab == index
                                ? activeColor ?? Theme.of(context).primaryColor
                                : unselectColor ??
                                    Theme.of(context).unselectedWidgetColor,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 12,
                  width: 32,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: activeTab == index ? 3 : 0,
                            color:
                                activeColor ?? Theme.of(context).primaryColor)),
                  ),
                )
              ],
            ),
            onTap: () => onTab(index),
          );
        },
      ).toList(),
    );
  }
}
