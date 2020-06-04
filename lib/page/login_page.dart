import 'package:flutter/material.dart';
import 'base_page.dart';


class LoginPage extends StatelessWidget {
  static final String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return BasePage(
      hasAppBar: false,
      resizeToAvoidBottomInset: false,
      body:LoginWidget() ,
    );
  }
}
class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


