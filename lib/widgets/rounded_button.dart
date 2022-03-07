import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {required this.text,
      required this.onPressed,
      this.icon,
      this.backgroundColor,
      this.foregroundColor,
      this.submitting = false,
      this.outlined = false,
      this.round = false});

  final String text;
  final Function()? onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool submitting;
  final bool round;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = <Widget>[];
    if (submitting) {
      row.add(CupertinoActivityIndicator());
    }
    if (icon != null) {
      row.add(Container(
        width: 32,
        child: icon,
      ));
    }
    row.add(Text(
      text,
    ));
    Color borderColor = (onPressed == null || submitting)
        ? Colors.grey.shade300
        : foregroundColor != null
            ? foregroundColor!
            : Theme.of(context).primaryColor;
    return outlined
        ? OutlinedButton(
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(color: borderColor, width: 1)),
                backgroundColor: backgroundColor != null
                    ? MaterialStateProperty.all(backgroundColor)
                    : null,
                foregroundColor: foregroundColor != null
                    ? MaterialStateProperty.all(foregroundColor)
                    : null,
                shape: MaterialStateProperty.all((RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(round ? 30 : 5))))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row,
            ),
            onPressed: submitting
                ? null
                : onPressed != null
                    ? onPressed
                    : null,
          )
        : ElevatedButton(
            style: ButtonStyle(
                backgroundColor: backgroundColor != null
                    ? MaterialStateProperty.all(backgroundColor)
                    : null,
                foregroundColor: foregroundColor != null
                    ? MaterialStateProperty.all(foregroundColor)
                    : null,
                shape: MaterialStateProperty.all((RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(round ? 30 : 5))))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row,
            ),
            onPressed: submitting
                ? null
                : onPressed != null
                    ? onPressed
                    : null,
          );
  }
}
