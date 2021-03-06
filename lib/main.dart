import 'dart:io';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'common/style/string_set.dart';
import 'common/style/style_set.dart';

void main() async {
  debugPaintSizeEnabled = false;

  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          StringSet.SOMETHING_WRONG + StringSet.PERIOD,
          style: TextStyle(
            fontSize: 17,
            decoration: TextDecoration.none,
            color: Colors.black,
          ),
        ),
      ),
    );
  };


  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await AmapCore.init(StringSet.IOS_AMAP_KEY);
  }
  runApp(App());
  SystemUiOverlayStyle systemUiOverlayStyle =
  SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

}
