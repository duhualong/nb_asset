import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:nbassetentry/common/util/screen_utils.dart';
import '../common/style/string_set.dart';
import '../common/style/style_set.dart';
import 'base_page.dart';

class HomePage extends StatelessWidget {
  static final String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return BasePage(
      hasAppBar: false,
      body: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  YYDialog alertDialogWithDivider(BuildContext context) {
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 4.0
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: StringSet.LOGIN_OUT_CONFIRM,
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: StringSet.CANCEL,
        color1: Colors.black,
        fontSize1: 14.0,
        onTap1: () {
          print("取消");
        },
        text2: StringSet.CONFIRM,
        color2: Colors.blue,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () {
          print("确定");
        },
      )
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: ThemeDataSet.tabColor,
          height: 64,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                StringSet.HOME_TITLE,
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
        ),
        Container(
          height: 64,
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                alertDialogWithDivider(context);
                print('点击11111');
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    StringSet.LOGIN_OUT,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 64),
          width: ScreenUtils.screenW(context),
          height: ScreenUtils.screenH(context) / 4 + 10,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetSet.HOME_BG),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    AssetSet.SPLASH_COMPANY,
                    height: 40,
                    width: 100,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    AssetSet.SPLASH_HELP,
                    height: 60,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 10),
                  child: Text(
                    StringSet.HOME_HINT,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: ScreenUtils.screenH(context) / 4 + 100, left: 24),
          child: GestureDetector(
            onTap: null,
            child: Image.asset(
              AssetSet.HOME_NB,
              width: ScreenUtils.screenW(context) / 2 - 20,
            ),
          ),
        )
      ],
    );
  }
}
