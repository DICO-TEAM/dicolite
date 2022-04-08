import 'package:dicolite/config/config.dart';
import 'package:dicolite/store/app.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Logo extends StatelessWidget {
  const Logo({this.logoUrl, this.currencyId, this.size, Key? key})
      : super(key: key);
  final String? logoUrl;
  final String? currencyId;

  final double? size;

  Widget _buildWidget(String? currencyIdUsed) {
    if (logoUrl == null && (currencyIdUsed == null || currencyIdUsed.isEmpty)) {
      return emptyWidget();
    }
    return CachedNetworkImage(
      width: size ?? 35,
      height: size ?? 35,
      fit: BoxFit.cover,
      imageUrl: logoUrl ??
          (Config.logoCDN +
              (globalAppStore.settings?.endpoint.info.toUpperCase() == 'KICO'
                  ? "KICO"
                  : "TICO") +
              "/$currencyIdUsed.png"),
      placeholder: (context, url) => emptyWidget(),
      errorWidget: (context, url, error) => emptyWidget(),
    );
  }

  Widget _logo1(String? currencyId) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xFFEFEFEF),
          ),
          borderRadius: BorderRadius.circular(size ?? 35)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size ?? 35),
        child: _buildWidget(currencyId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (logoUrl == null && currencyId == null) {
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

    if (currencyId != null &&
        BigInt.parse(currencyId!) >= (Config.liquidityFirstId)) {
      /// liquidity 2 logo
      List<String> list = [];
      var index = globalAppStore.dico?.liquidityList
              ?.indexWhere((e) => e.liquidityId == currencyId) ??
          -1;
      if (index != -1) {
        list = globalAppStore.dico!.liquidityList![index].currencyIds;
      }
      return Container(
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Container(
              width: 62,
            ),
            Positioned(child: _logo1(list.isNotEmpty?list[0]:null)),
            Positioned(left: 25, child: _logo1(list.isNotEmpty?list[1]:null)),
          ],
        ),
      );
    }
    return _logo1(currencyId);
  }

  Widget emptyWidget() {
    return Container(
      width: size ?? 35,
      height: size ?? 35,
      color: Colors.grey[200],
    );
  }
}
