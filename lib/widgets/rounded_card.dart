
import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  RoundedCard(
      {this.border,
      this.margin,
      this.padding,
      this.color,
      this.radius,
      required this.child});

  final BoxBorder? border;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 15),
      child: Container(
        margin: margin,
        padding: padding,
        child: child,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 15)),
          color:color?? Theme.of(context).cardColor,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 16.0, // has the effect of softening the shadow
          //     spreadRadius: 4.0, // has the effect of extending the shadow
          //     offset: Offset(
          //       2.0, // horizontal, move right 10
          //       2.0, // vertical, move down 10
          //     ),
          //   )
          // ],
        ),
      ),
    );
  }
}
