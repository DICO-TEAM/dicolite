import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/config/config.dart';
import 'package:flutter/services.dart';

// const MaterialColor dicoColor = const MaterialColor(
//   0xFF29B58D,
//   const <int, Color>{
//     50: const Color(0xFFe2efeb),
//     100: const Color(0xFFcae2db),
//     200: const Color(0xFFb0d8cc),
//     300: const Color(0xFF8ecab8),
//     400: const Color(0xFF6bb39e),
//     500: const Color(0xFF57b59a),
//     600: const Color(0xFF44b393),
//     700: const Color(0xFF38b591),
//     800: const Color(0xFF30b38d),
//     900: const Color(0xFF29B58D),
//   },
// );

const MaterialColor dicoColor = const MaterialColor(
  0xFF00CEA6,
  const <int, Color>{
    50: const Color(0xFFe2efeb),
    100: const Color(0xFFaecfc8),
    200: const Color(0xFF9cd3c8),
    300: const Color(0xFF88d9c9),
    400: const Color(0xFF67d9c3),
    500: const Color(0xFF4ed9be),
    600: const Color(0xFF3fd5b8),
    700: const Color(0xFF29d3b2),
    800: const Color(0xFF13d3ae),
    900: const Color(0xFF00CEA6),
  },
);

class AppTheme {
  static getThemeData() {
    ThemeData themData = ThemeData(
      primarySwatch: dicoColor,

      scaffoldBackgroundColor: Config.bgColor,
      fontFamily: 'SourceHanSansCN',
      primaryColor: dicoColor,
      primaryColorLight: dicoColor[300],

      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        textTheme: ButtonTextTheme.accent,
        disabledColor: Color(0xFFCCCCCC),
      ),

      // appbar
      appBarTheme: AppBarTheme(
        color: dicoColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0.0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Adapt.px(36),
          fontFamily: 'SourceHanSansCN',
        ),
        iconTheme: IconThemeData(color: Config.color333),
        centerTitle: true,
        toolbarTextStyle: TextStyle(
          color: Config.color333,
          fontWeight: FontWeight.bold,
          fontSize: Adapt.px(36),
          fontFamily: 'SourceHanSansCN',
        ),
      ),

      cardTheme: CardTheme(elevation: 5, shadowColor: Color(0x0F111623)),
      textTheme: TextTheme(
        headline5: TextStyle(
          color: Config.color333,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceHanSansCN',
          fontSize: Adapt.px(42),
        ),
        bodyText1: TextStyle(
          color: Config.color333,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceHanSansCN',
          fontSize: Adapt.px(26),
        ),
        bodyText2: TextStyle(
          color: Config.color999,
          fontFamily: 'SourceHanSansCN',
          fontSize: Adapt.px(26),
        ),
        button: TextStyle(
          color: Colors.white,
          fontFamily: 'SourceHanSansCN',
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(40))),
        side: MaterialStateProperty.all(BorderSide(color: dicoColor, width: 1)),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(40))),
        elevation: MaterialStateProperty.all(0),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      )),

      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: Adapt.px(36),
          color: Colors.black87,
          fontFamily: 'SourceHanSansCN',
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        fillColor: Colors.white,
        hintStyle: TextStyle(fontSize: Adapt.px(30)),
        labelStyle: TextStyle(fontSize: Adapt.px(30)),
        filled: true,
      ),
    );
    return themData;
  }
}
