import 'package:flutter/material.dart';
import 'package:nbassetentry/common/model/option.dart';
import 'string_set.dart';

class AssetSet {
  static const String SPLASH_BG = 'assets/splash_bg.png';
  static const String SPLASH_COMPANY = 'assets/splash_company_name.png';
  static const String SPLASH_HELP = 'assets/splash_help.png';
  static const String LOGIN_BG = 'assets/login_bg.png';
  static const String HOME_BG = 'assets/home_bg.png';
  static const String HOME_NB = 'assets/home_nb_button.png';
  static const String NB_DIMMING_DEFAULT = 'assets/nb_dimming_default.png';
  static const String NB_DIMMING_SELECT = 'assets/nb_dimming_select.png';
  static const String NB_ISSUED_DEFAULT = 'assets/nb_issued_default.png';
  static const String NB_ISSUED_SELECT = 'assets/nb_issued_select.png';
  static const String NB_RESET_DEFAULT = 'assets/nb_reset_default.png';
  static const String NB_RESET_SELECT = 'assets/nb_reset_select.png';
  static const String NB_SUMMON_DEFAULT = 'assets/nb_summon_default.png';
  static const String NB_SUMMON_SELECT = 'assets/nb_summon_select.png';
  static const String NB_BOTTOM_SHEET_SUMMON='assets/bottom_sheet_summon.png';
  static const String NB_BOTTOM_SHEET_DIMMING='assets/bottom_sheet_dimming.png';
  static const String NB_SMALL_DIMMING='assets/nb_small_dimming.png';
  static const String NB_LARGE_DIMMING='assets/nb_large_dimming.png';
  static const String SPLASH='assets/splash.png';
}
class ThemeDataSet {
  static const Color tabColor = Color.fromRGBO(54, 120, 255, 1.0);
  static const Color tabColorOther = Color.fromRGBO(99, 198, 214, 1.0);
  static final themeData=ThemeData(
      primaryColor:tabColor,
      primaryColorDark: tabColor,
      highlightColor: tabColor,
      disabledColor: tabColor,
      backgroundColor:tabColor,
      dividerColor: tabColor,
      platform: TargetPlatform.android,
    );


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
