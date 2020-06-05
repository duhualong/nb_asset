import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

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
  runApp(App());
  SystemUiOverlayStyle systemUiOverlayStyle =
  SystemUiOverlayStyle(statusBarColor:ThemeDataSet.tabColor);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);


//  if (Platform.isIOS) {
//    await AMap.init(StringSet.IOS_AMAP_KEY);
//  }
}
