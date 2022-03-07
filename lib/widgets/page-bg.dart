import 'package:flutter/material.dart';
import 'package:dicolite/utils/adapt.dart';

class PageBg extends StatelessWidget {
  PageBg({
    required this.child,
    this.title = '',
    this.action,
    this.height,
    this.onBack,
  });
  final String? title;
  final Widget child;
  final Function()? onBack;
  final Widget? action;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            height: height ?? Adapt.px(430),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/dico/ICO-participate-bg.png',
                    ),
                    fit: BoxFit.fill)),
          ),
        ),
        Positioned(
          child: SafeArea(
            top: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: onBack != null
                      ? onBack
                      : () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                  icon: Image.asset(
                    'assets/images/dico/back-white.png',
                    width: 11,
                  ),
                ),
                Expanded(
                  child: Text(
                    title ?? '',
                    style:
                        TextStyle(color: Colors.white, fontSize: Adapt.px(40)),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                action ??
                    Container(
                      width: 45.0,
                      child: Text(''),
                    ),
              ],
            ),
          ),
        ),
        Positioned(
          child: SafeArea(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 60, 0, 0), child: child),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
