import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:nbassetentry/common/dao/nb_dao.dart';
import 'package:nbassetentry/common/event/jpush_event.dart';
import 'package:nbassetentry/common/model/nb_data.dart';

import 'base_page.dart';
import 'home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/config/config.dart';
import '../common/dao/dao_result.dart';
import '../common/event/network_event.dart';
import '../common/http/http.dart';
import '../common/local/local_storage.dart';
import '../common/local/network_storage.dart';
import '../common/model/network.dart';
import '../common/style/string_set.dart';
import '../common/style/style_set.dart';
import '../common/util/screen_utils.dart';

import '../widget/text_field_widget.dart';
import 'network_setting_page.dart';

class LoginPage extends StatelessWidget {
  static final String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return BasePage(
      hasAppBar: false,
      resizeToAvoidBottomInset: false,
      body: LoginWidget(),
    );
  }
}

class LoginWidget extends StatefulWidget {
  static final String routeName = '/login';

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _isChecked = true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Container(
              color: Colors.white,
            ),
          ),
          Container(
            height: ScreenUtils.screenH(context) / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetSet.LOGIN_BG),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                AssetSet.SPLASH_HELP,
                height: 70,
              ),
            ),
          ),
          Positioned(
            top: 60 + ScreenUtils.screenH(context) / 4,
            left: 25,
            right: 25,
            child: LoginFormWidget(isCheck: _isChecked),
          ),
        ],
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  final bool isCheck;

  LoginFormWidget({
    Key key,
    this.isCheck,
  }) : super(key: key);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget>
    with SingleTickerProviderStateMixin {
  bool _clearIsHidden = true;
  bool _passwordIsVisible = false;
  bool _loginIsEnabled = false;
  bool _isLoading = false;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  StreamSubscription _stream;
  FocusNode _commentFocus = FocusNode();
  JPush _jPush = JPush();

  @override
  void initState() {
    super.initState();
    _initialize();
    _initJpush();
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController?.dispose();
    _passwordController?.dispose();
    _stream?.cancel();
    _stream = null;
  }

  void _initialize() async {
    if (Platform.isIOS) {
      await FlutterStatusbarcolor.setStatusBarColor(ThemeDataSet.tabColor);

    }
    String userName =
        await LocalStorage.get(Config.USER_NAME_KEY) ?? StringSet.EMPTY;
    String password =
        await LocalStorage.get(Config.USER_PWD) ?? StringSet.EMPTY;
    _userNameController.value =
        TextEditingValue(text: userName ?? StringSet.EMPTY);
    _passwordController.value =
        TextEditingValue(text: password ?? StringSet.EMPTY);
    FocusScope.of(context).requestFocus(_commentFocus);
    _checkStates();
    _stream = NetworkEvent.eventBus.on<String>().listen((data) {
      if (data != NetworkEvent.ON_UPDATED) {
        return;
      }
      _checkStates();
    });
  }

  Future<void> _checkStates() async {
    _clearIsHidden = _userNameController.text.isEmpty;
    Network network = await NetworkStorage.getCheckedNetwork();
    _loginIsEnabled = _userNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        network != null;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _login() async {
    HttpLoading.context = context;
    DaoResult.context = context;
    HttpManager.context=context;
    _isLoading = true;
    if (mounted) {
      setState(() {});
    }

    DaoResult result = await NbDao.userLogin(
        userName: _userNameController.text.trim(),
        pwd: _passwordController.text.trim());

    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
    if (result == null || !result.isSuccess) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }

  @override
  Widget build(BuildContext mainContext) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFieldWidget(
            iconData: Icons.account_circle,
            enabled: !_isLoading,
            labelText: StringSet.USER_NAME + StringSet.IS_NECESSARY,
            hintText: StringSet.USER_NAME_HINT,
            suffixIconData: Icons.clear,
            suffixIconIsHidden: _clearIsHidden,
            suffixIconOnTap: () {
              _userNameController.clear();
              _userNameController.text = StringSet.EMPTY;
              _passwordController.clear();
              _passwordController.text = StringSet.EMPTY;
              setState(() async => _checkStates());
            },
            onChanged: (value) {
              setState(() => _checkStates());
            },
            controller: _userNameController,
          ),
          SizedBox(height: 12),
          TextFieldWidget(
            iconData: Icons.lock_outline,
            enabled: !_isLoading,
            labelText: StringSet.PASSWORD + StringSet.IS_NECESSARY,
            hintText: StringSet.PASSWORD_HINT,
            obscureText: !_passwordIsVisible,
            suffixIconData:
                _passwordIsVisible ? Icons.visibility_off : Icons.visibility,
            suffixIconOnTap: () {
              setState(() => _passwordIsVisible = !_passwordIsVisible);
            },
            onChanged: (value) {
              setState(() => _checkStates());
            },
            controller: _passwordController,
          ),
          SizedBox(height: 45),
          SizedBox(
            width: ScreenUtils.screenW(context) - 100,
            height: 40,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              highlightColor: Theme.of(context).highlightColor,
              disabledColor: Theme.of(context).disabledColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                StringSet.LOGIN,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: _loginIsEnabled && widget.isCheck ? _login : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 6),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(NetworkSettingPage.routeName);
                },
                child: Text(
                  StringSet.NETWORK_SETTING,
                  style: TextStyle(
                    color: ThemeDataSet.tabColor,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void>_initJpush()async {
    try {
      _jPush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          if(!message.containsKey('extras')){
           return;
          }
          JpushEvent.eventBus.fire(message);
        },
        onOpenNotification: (Map<String, dynamic> message) async {
        },
        onReceiveMessage: (Map<String, dynamic> message) async {

        },
      );
    } on PlatformException {}

    _jPush.setup(
      appKey: StringSet.JPUSH_KEY,
      channel: 'defaultChannel',
      production: false,
      debug: false,
    );

    _jPush.applyPushAuthority(NotificationSettingsIOS(
      sound: true,
      alert: true,
      badge: true,
    ));
  }
}
