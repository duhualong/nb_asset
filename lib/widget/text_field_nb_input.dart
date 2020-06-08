import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nbassetentry/common/style/string_set.dart';
import 'package:nbassetentry/common/util/screen_utils.dart';

class NbTextFieldWidget extends StatefulWidget {
  final Color backgroundColor;

  final bool obscureText;

  final bool enabled;

  final bool underlineIsHidden;

  final String labelText;
  final bool required;

  final String hintText;

  final IconData iconData;

  final bool suffixIconIsHidden;

  final IconData suffixIconData;

  final IconData prefixIcon;

  final GestureTapCallback suffixIconOnTap;

  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextStyle hintStyle;

  final TextEditingController controller;

  final EdgeInsetsGeometry contentPadding;

  final FocusNode focusNode;

  final TextInputType keyboardType;

  final Brightness keyboardAppearance;

  final int maxLength;

  final int maxLines;

  NbTextFieldWidget({
    Key key,
    this.backgroundColor = Colors.white,
    this.labelText,
    this.hintText,
    this.enabled,
    this.iconData,
    this.suffixIconData,
    this.suffixIconOnTap,
    this.prefixIcon,
    this.onChanged,
    this.textStyle,
    this.hintStyle,
    this.controller,
    this.underlineIsHidden = false,
    this.suffixIconIsHidden = false,
    this.obscureText = false,
    this.required = false,
    this.contentPadding,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.keyboardAppearance = Brightness.light,
    this.maxLength,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _NbTextFieldWidgetState createState() => _NbTextFieldWidgetState();
}

class _NbTextFieldWidgetState extends State<NbTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> inputFormatters = [
      // 限制最大长度
      LengthLimitingTextInputFormatter(widget.maxLength),
    ];
    if (widget.keyboardType == TextInputType.number) {
      // 只允许输入数字
      inputFormatters.add(WhitelistingTextInputFormatter.digitsOnly);
    }
    if (widget.keyboardType == TextInputType.numberWithOptions(decimal: true)) {
      // 只允许输入小数
      inputFormatters.add(WhitelistingTextInputFormatter(RegExp("[0-9.]")));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10),
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
        Container(
          padding: EdgeInsets.only(left: 16),
          margin: EdgeInsets.only(left: 20, top: 10),
          alignment: Alignment(0, 0),
          height: 42,
          width: ScreenUtils.screenW(context) - 40,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            border: new Border.all(color: Colors.grey, width: 1),
          ),
          child: Align(
            child: TextField(
              maxLines: widget.maxLines,
              keyboardAppearance: widget.keyboardAppearance,
              keyboardType: widget.keyboardType,
              focusNode: widget.focusNode,
              enabled: widget.enabled,
              controller: widget.controller,
              onChanged: widget.onChanged,
              obscureText: widget.obscureText,
              style: widget.textStyle,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: StringSet.NB_HINT + widget.labelText),
            ),
          ),
        )
      ],
    );
  }
}
