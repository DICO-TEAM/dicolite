
import 'package:flutter/material.dart';

class OutlinedCircle extends StatelessWidget {
  OutlinedCircle({required this.icon,required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 1, color: color),
      ),
    );
  }
}
