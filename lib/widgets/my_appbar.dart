import 'package:flutter/material.dart';
import 'package:dicolite/config/config.dart';
import 'package:flutter/services.dart';

///[title]；
///
///[isThemeBg]；
///
///[backgroundColor]；
PreferredSizeWidget myAppBar(BuildContext context, String title,
    {bool isBackFFF = false,
    bool isThemeBg = false,
    Function? onBack,
    Color backgroundColor = Colors.white,
    List<Widget>? actions}) {
  return AppBar(
    backgroundColor:
        isThemeBg ? Theme.of(context).primaryColor : backgroundColor,
    leading: IconButton(
      onPressed: () {
        if(onBack!=null) onBack();
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
      },
      icon: Image.asset(
        isBackFFF || isThemeBg
            ? 'assets/images/dico/back-white.png'
            : 'assets/images/dico/back.png',
        width: 11,
      ),
    ),
    systemOverlayStyle:
        isBackFFF || isThemeBg ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        color: isBackFFF || isThemeBg ? Colors.white : Config.color333,
        fontWeight: FontWeight.w500,
      ),
    ),
    actions: actions,
  );
}
