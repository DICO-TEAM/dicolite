import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dicolite/dico_app.dart';
import 'package:dicolite/widgets/restart_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';



Future<Null> main() async {


  WidgetsFlutterBinding.ensureInitialized();
 
  if (isInDebugMode) {
    runApp(RestartWidget(child: DicoApp()));
  } else {
    await SentryFlutter.init((options) {
      options.dsn =
          "https://f83a74b214bf4ca7843ffe1ac3e95dc9@o482555.ingest.sentry.io/5876411";
    }, appRunner: () => runApp(RestartWidget(child: DicoApp())));
  }

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

