import 'package:flutter/material.dart';
import 'string_set.dart';

class AssetSet {
  static const String SPLASH_BG = 'assets/splash_bg.png';
  static const String SPLASH_COMPANY = 'assets/splash_company_name.png';
  static const String SPLASH_HELP = 'assets/splash_help.png';
  static const String LOGIN_BG = 'assets/login_bg.png';
  static const String HOME_BG = 'assets/home_bg.png';
  static const String HOME_NB = 'assets/home_nb_button.png';
  static const String NB_DIMMING_DEFAULT = 'nb_dimming_default.png';
  static const String NB_DIMMING_SELECT = 'nb_dimming_select.png';
  static const String NB_ISSUED_DEFAULT = 'nb_issued_default.png';
  static const String NB_ISSUED_SELECT = 'nb_issued_select.png';
  static const String NB_RESET_DEFAULT = 'nb_reset_default.png';
  static const String NB_RESET_SELECT = 'nb_reset_select.png';
  static const String NB_SUMMON_DEFAULT = 'nb_summon_default.png';
  static const String NB_SUMMON_SELECT = 'nb_summon_select.png';
}

class ThemeDataSet {
  static const Color tabColor = Color.fromRGBO(54, 120, 255, 1.0);
  static final List<ThemeData> THEME_DATAS = ACCENTS.map((accent) {
    int index = ACCENTS.indexOf(accent);
    return ThemeData(
      primaryColor: PRIMARIES[index],
      primaryColorDark: Colors.black,
      highlightColor: ACCENTS[index],
      disabledColor: Colors.black38,
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      dividerColor: Color.fromRGBO(242, 242, 242, 1),
      platform: TargetPlatform.android,
    );
  }).toList();

  static const List<Color> PRIMARIES = [
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
  ];

  static const List<Color> ACCENTS = [
    Colors.blueAccent,
    Colors.lightBlueAccent,
    Colors.cyanAccent,
    Colors.tealAccent,
    Colors.greenAccent,
    Colors.lightGreenAccent,
    Colors.limeAccent,
    Colors.yellowAccent,
    Colors.amberAccent,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.deepPurpleAccent,
    Colors.indigoAccent,
  ];

  static const List<String> NAMES = [
    StringSet.BLUE,
    StringSet.LIGHT_BLUE,
    StringSet.CYAN,
    StringSet.TEAL,
    StringSet.GREEN,
    StringSet.LIGHT_GREEN,
    StringSet.LIME,
    StringSet.YELLOW,
    StringSet.AMBER,
    StringSet.ORANGE,
    StringSet.DEEP_ORANGE,
    StringSet.PINK,
    StringSet.PURPLE,
    StringSet.DEEP_PURPLE,
    StringSet.INDIGO,
  ];
}
