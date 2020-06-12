import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'base_page.dart';
import 'nb_scan_page.dart';
import 'package:flutter/services.dart';
import '../common/event/error_event.dart';
import '../common/util/screen_utils.dart';
import '../widget/error_handle.dart';
import '../common/style/string_set.dart';
import '../common/style/style_set.dart';

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

showCustomDialog(BuildContext context, String title) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Padding(
            child: Text(title),
            padding: EdgeInsets.all(10),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                StringSet.CONFIRM,
                style: TextStyle(
                  color: Color.fromRGBO(26, 136, 255, 1.0),
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                StringSet.CANCEL,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

class _HomeWidgetState extends State<HomeWidget> {
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
                showCustomDialog(context, StringSet.LOGIN_OUT_CONFIRM);
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
//            onTap: () => _scan(context),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ErrorHandle(
                  child: NbScanPage(result: ''),
//                  child: GZXDropDownMenuTestPage(),
                ),
              ),
            ),
            child: Image.asset(
              AssetSet.HOME_NB,
              width: ScreenUtils.screenW(context) / 2 - 20,
            ),
          ),
        )
      ],
    );
  }

  Future<void> _scan(BuildContext context) async {
    try {
      String result = await BarcodeScanner.scan();
      print('result:$result');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorHandle(
            child: NbScanPage(result: result),
          ),
        ),
      );
    } on PlatformException catch (error) {
      if (error.code == BarcodeScanner.CameraAccessDenied) {
        ErrorEvent.errorMessageToast(
            StringSet.CAMERA_ACCESS_DENIED + StringSet.PERIOD);
      } else {
        ErrorEvent.errorMessageToast(error.message);
      }
    } on FormatException {
      /// 取消操作
      ErrorEvent.errorMessageToast(
          StringSet.OPERATION_CANCELLED + StringSet.PERIOD);
    } catch (error) {
      ErrorEvent.errorMessageToast(error.message);
    }
  }
}
