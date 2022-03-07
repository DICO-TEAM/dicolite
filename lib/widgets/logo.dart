import 'package:dicolite/config/config.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Logo extends StatelessWidget {
  const Logo({this.logoUrl, this.symbol, this.size, Key? key})
      : super(key: key);
  final String? logoUrl;
  final String? symbol;

  final double? size;

  Widget _buildWidget(String? symbolUsed) {
    if (logoUrl == null && (symbolUsed == null || symbolUsed.isEmpty)) {
      return emptyWidget();
    }
    return CachedNetworkImage(
      width: size ?? 35,
      height: size ?? 35,
      fit: BoxFit.cover,
      imageUrl: logoUrl ??
          (Config.logoCDN + (symbolUsed?.toUpperCase() ?? '') + ".png"),
      placeholder: (context, url) => emptyWidget(),
      errorWidget: (context, url, error) => emptyWidget(),
    );
  }

  Widget _logo1(String? symbol) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xFFEFEFEF),
          ),
          borderRadius: BorderRadius.circular(size ?? 35)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size ?? 35),
        child: _buildWidget(symbol),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (logoUrl == null && symbol == null) {
      return Container(
        width: size ?? 35,
        height: size ?? 35,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(
              color: Color(0xFFEFEFEF),
            ),
            borderRadius: BorderRadius.circular(size ?? 35)),
      );
    }

    if (symbol != null && symbol!.contains("-")) {
      /// liquidity 2 logo
      List list = symbol!.split("-");
      return Container(
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Container(
              width: 62,
            ),
            Positioned(child: _logo1(list[0])),
            Positioned(left: 25, child: _logo1(list[1])),
          ],
        ),
      );
    }
    return _logo1(symbol);
  }

  Widget emptyWidget() {
    return Container(
      width: size ?? 35,
      height: size ?? 35,
      color: Colors.grey[200],
    );
  }
}
