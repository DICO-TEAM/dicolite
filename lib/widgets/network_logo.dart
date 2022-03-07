import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/material.dart';

class NetworkLogo extends StatelessWidget {
  const NetworkLogo(this.network, {Key? key}) : super(key: key);
  final String network;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/coins/${network.toLowerCase()}.png',
      width: Adapt.px(70),
      height: Adapt.px(70),
    );
  }
}
