import 'package:flutter/material.dart';
import 'package:nbassetentry/common/style/string_set.dart';
import 'package:nbassetentry/common/style/style_set.dart';
import 'package:nbassetentry/page/base_page.dart';

class NbScanPage extends StatelessWidget {
  static final String routeName = '/nb_scan';

  final String result;

  NbScanPage({
    Key key,
    this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      hasAppBar: true,
      color: ThemeDataSet.tabColor,
      title: StringSet.NB_LAMP,
      leadingIconData: Icons.arrow_back_ios,
      leadingOnTap: () => Navigator.pop(context),
      actions: <Widget>[
        GestureDetector(
          onTap: null,
          child: Align(
           alignment: Alignment.center,
            child: Text(
              StringSet.SAVE,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        )
      ],
      body:NBScanWidget() ,
    );
  }
}
class NBScanWidget extends StatefulWidget {
  @override
  _NBScanWidgetState createState() => _NBScanWidgetState();
}

class _NBScanWidgetState extends State<NBScanWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

