import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nbassetentry/common/dao/dao_result.dart';
import 'package:nbassetentry/common/dao/nb_dao.dart';
import 'package:nbassetentry/common/global/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'base_page.dart';
import 'login_page.dart';
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

Future<bool> requestPermission() async {
  final permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.location]);

  if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
    return true;
  } else {
    Fluttertoast.showToast(msg: StringSet.LOCATION_PERMISSION);
    return false;
  }
}



class _HomeWidgetState extends State<HomeWidget> {
  BuildContext _buildContext;
  Future<void> _loginOut(BuildContext context) async {
    Navigator.of(context).pop();
    await NbDao.loginOut();
    Global.user.uuid = null;
    Navigator.of(_buildContext).pushReplacementNamed(LoginPage.routeName);
  }

  showCustomDialog(  String title) {
    showDialog(
        context: _buildContext,
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
                  _loginOut(context);
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



  @override
  Widget build(BuildContext context) {
    _buildContext=context;
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
                showCustomDialog( StringSet.LOGIN_OUT_CONFIRM);
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
            onTap: () async {
              if (await requestPermission()) {
                _scan(context);
              }
            },
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
      if (result.isEmpty || result == null||result.trim()=='{}') {
        return;
      }
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
