import 'dart:io';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/utils/adapt.dart';

import 'package:dicolite/utils/my_utils.dart';
import 'package:dicolite/widgets/address_icon.dart';

class AddressQR extends StatefulWidget {
  static const route = '/me/addressQR';
  AddressQR(this.store);
  final AppStore store;
  @override
  _AddressQRState createState() => _AddressQRState();
}

class _AddressQRState extends State<AddressQR> {
  setSystemStyle(bool isLight) {}
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    }
    final String _address = widget.store.account?.currentAddress ?? '';

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dico/bg-qr.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Image.asset(
                      'assets/images/dico/back-white.png',
                      width: 11,
                    ),
                  ),
                  Text(
                    S.of(context).myAccountAddress,
                    style: TextStyle(
                        fontSize: Adapt.px(40),
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  IconButton(onPressed: () {}, icon: Container()),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40, left: 30, right: 30),
                  padding:
                      EdgeInsets.only(top: Adapt.px(40), bottom: Adapt.px(70)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFE3F4F1),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(35, 174, 132, 0.12),
                        offset: Offset(0, Adapt.px(4)),
                        blurRadius: Adapt.px(12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(
                            height: Adapt.px(38),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.store.account?.currentAccount.name ??
                                  'name',
                              style: TextStyle(
                                fontSize: Adapt.px(36),
                                color: Config.color333,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Adapt.px(70),
                      ),
                      QrImage(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF00807B),
                        data: _address,
                        version: QrVersions.auto,
                        size: Adapt.px(400),
                      ),
                      SizedBox(
                        height: Adapt.px(70),
                      ),
                      Text(
                        Fmt.address(_address),
                        style: TextStyle(
                          color: Config.color666,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: Adapt.px(30),
                      ),
                      Container(
                        width: Adapt.px(370),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  S.of(context).copy,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  copy(context, _address);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  child: widget.store.dico?.activeNftToken?.imageUrl != null &&
                          widget.store.dico!.activeNftToken!.imageUrl.isNotEmpty
                      ? Logo(
                          logoUrl: widget.store.dico?.activeNftToken?.imageUrl,
                          size: 60,
                        )
                      : AddressIcon(
                          '',
                          size: 60,
                          pubKey: widget.store.account?.currentAccount.pubKey,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
