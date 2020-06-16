import 'dart:async';
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
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _isChecked = true;

  @override
  void initState() {
    super.initState();
//    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(54, 120, 255, 1.0));
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
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

  @override
  void initState() {
    super.initState();
    _initialize();
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
    String userName =
        await LocalStorage.get(Config.USER_NAME_KEY) ?? StringSet.EMPTY;
    String password = StringSet.EMPTY;
    _userNameController.value =
        TextEditingValue(text: userName ?? StringSet.EMPTY);
    _passwordController.value =
        TextEditingValue(text: password ?? StringSet.EMPTY);
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
    _isLoading = true;
    if (mounted) {
      setState(() {});
    }
//    DaoResult result = await UserDao.userLogin(
//        _userNameController.text.trim(), _passwordController.text.trim());
//
//
//    _isLoading = false;
//    if (mounted) {
//      setState(() {});
//    }
//    if (result == null || !result.isSuccess) {
//      return;
//    }
//
//    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
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
              setState(() => _checkStates());
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
            child: FlatButton(
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomePage()),

                );
              },
//              onPressed: _loginIsEnabled && widget.isCheck ? _login : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerRight,
              child:  GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(NetworkSettingPage.routeName);
                },
                child: Text(
                  StringSet.NETWORK_SETTING,
                  style: TextStyle(
                    color: ThemeDataSet.tabColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
