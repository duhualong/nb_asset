import 'dart:async';

import 'package:flutter/material.dart';
import '../common/style/style_set.dart';
import '../common/util/screen_utils.dart';
import '../page/login_page.dart';

class SplashPage extends StatefulWidget {
  static final String routeName = '/';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool showAd = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Offstage(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetSet.SPLASH_BG),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(0.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        AssetSet.SPLASH_HELP,
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Image.asset(
                          AssetSet.SPLASH_COMPANY,
                          width: ScreenUtils.screenW(context) - 220,
                          height: 16,
                        ),
                      )
                    ],
                  ),
                ),
                SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment(1.0, 0.0),
                      child: Container(
                        margin: const EdgeInsets.only(right: 30.0, top: 20.0),
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                        child: CountDownWidget(
                          onCountDownFinishCallBack: (bool value) {
                            if (value) {
                              setState(() {
                                showAd = false;
                              });
                            }
                          },
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xffEDEDED),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                      ),
                    ),
                  ],
                )),
              ],
            ),
            width: ScreenUtils.screenW(context),
            height: ScreenUtils.screenH(context),
          ),
          offstage: !showAd,
        )
      ],
    );
  }
}

class CountDownWidget extends StatefulWidget {
  final onCountDownFinishCallBack;

  CountDownWidget({Key key, @required this.onCountDownFinishCallBack})
      : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  var _seconds = 2;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_seconds',
      style: TextStyle(
          fontSize: 15.0, color: Colors.cyan, fontWeight: FontWeight.bold),
    );
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
      if (_seconds <= 1) {
        widget.onCountDownFinishCallBack(true);
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
        _cancelTimer();
        return;
      }
      _seconds--;
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }
}
