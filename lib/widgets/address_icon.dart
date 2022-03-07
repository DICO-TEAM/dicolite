import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/my_utils.dart';

class AddressIcon extends StatelessWidget {
  AddressIcon(
    this.address, {
    this.size,
    this.pubKey,
    this.tapToCopy = true,
    this.addressToCopy,
  });
  final String address;
  final String? pubKey;
  final double? size;
  final bool tapToCopy;
  final String? addressToCopy;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String? rawSvg;
        String addressView = address;
        rawSvg = globalAppStore.account!.addressIconsMap[address] ?? null;
        if (pubKey != null) {
          rawSvg = globalAppStore.account!.pubKeyIconsMap[pubKey] ?? rawSvg;
          if (globalAppStore.account!
                  .pubKeyAddressMap[globalAppStore.settings!.endpoint.ss58] !=
              null) {
            addressView = globalAppStore.account!.pubKeyAddressMap[
                    globalAppStore.settings!.endpoint.ss58]![pubKey] ??
                address;
          }
        }
        return GestureDetector(
          child: Container(
            width: size ?? 40,
            height: size ?? 40,
            child: rawSvg == null
                ? Image.asset('assets/images/main/assets-nav.png')
                : SvgPicture.string(rawSvg),
          ),
          onTap: tapToCopy
              ? () => copy(context, addressToCopy ?? addressView)
              : null,
        );
      },
    );
  }
}
