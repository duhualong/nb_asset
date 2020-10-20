import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nbassetentry/common/style/string_set.dart';
import 'package:nbassetentry/common/util/screen_utils.dart';

class NbTextWidget extends StatefulWidget {
  final Color backgroundColor;

  final String labelText;
  final bool required;
  final String value;
  final Color textColor;

  NbTextWidget({
    Key key,
    this.backgroundColor = Colors.white,
    this.labelText,
    this.required = false,
    this.value,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  _NbTextWidgetState createState() => _NbTextWidgetState();
}

class _NbTextWidgetState extends State<NbTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16, top: 10),
          child: RichText(
              text: TextSpan(
                  text: widget.labelText,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: <TextSpan>[
                TextSpan(
                    text:
                        widget.required ? StringSet.NECESSARY : StringSet.EMPTY,
                    style: TextStyle(color: Colors.red))
              ])),
        ),
//        Container(
//          padding: EdgeInsets.only(left: 10),
//          margin: EdgeInsets.only(left: 10, top: 10),
//          alignment: Alignment(0, 0),
//          height: 42,
//          width: ScreenUtils.screenW(context) - 40,
//          decoration: new BoxDecoration(
//            color: widget.backgroundColor,
//            borderRadius: BorderRadius.all(Radius.circular(25.0)),
//            border: new Border.all(color: Colors.grey, width: 1),
//          ),

        Neumorphic(
          padding: EdgeInsets.fromLTRB(20, 16, 10, 16),
          margin: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 2),
          style: NeumorphicStyle(
            surfaceIntensity: 0.15,
            depth: 10,
            border: NeumorphicBorder(width: 0.1, color: Colors.white60),
            boxShape: NeumorphicBoxShape.stadium(),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.value,
              style: TextStyle(
                  color: widget.textColor,
                  fontSize: widget.value.length > 10 ? 12 : 14),
            ),
          ),
        ),
      ],
    );
  }
}
