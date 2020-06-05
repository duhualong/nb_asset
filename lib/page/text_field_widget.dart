import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final Color backgroundColor;

  final bool obscureText;

  final bool enabled;

  final bool underlineIsHidden;

  final String labelText;

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

  TextFieldWidget({
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
    this.contentPadding,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.keyboardAppearance = Brightness.light,
    this.maxLength,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
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
    return Container(
      color: widget.backgroundColor,
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
          contentPadding: widget.contentPadding,
          border: widget.underlineIsHidden ? InputBorder.none : null,
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          icon: widget.iconData == null ? null : Icon(widget.iconData),
          prefixIcon:
              widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
          suffixIcon: widget.suffixIconIsHidden
              ? null
              : Offstage(
                  offstage: false,
                  child: GestureDetector(
                    onTap: widget.suffixIconOnTap,
                    child: Icon(widget.suffixIconData),
                  ),
                ),
        ),
      ),
    );
  }
}
