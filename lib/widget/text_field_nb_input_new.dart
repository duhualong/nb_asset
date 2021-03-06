import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nbassetentry/common/style/string_set.dart';
import 'package:nbassetentry/common/util/screen_utils.dart';

class NbTextFieldNewWidget extends StatefulWidget {
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

  NbTextFieldNewWidget({
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
  _NbTextFieldNewWidgetState createState() => _NbTextFieldNewWidgetState();
}

class _NbTextFieldNewWidgetState extends State<NbTextFieldNewWidget> {
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
    return _TextField(label: '姓名', hint: '请输入名称');
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.only(left: 10, top: 10),
//          child: RichText(
//              text: TextSpan(
//                  text: widget.labelText,
//                  style: TextStyle(color: Colors.black, fontSize: 16),
//                  children: <TextSpan>[
//                TextSpan(
//                    text:
//                        widget.required ? StringSet.NECESSARY : StringSet.EMPTY,
//                    style: TextStyle(color: Colors.red))
//              ])),
//        ),
////        Container(
////          padding: EdgeInsets.only(left: 10),
////          margin: EdgeInsets.only(left: 10, top: 10),
////          alignment: Alignment(0, 0),
////          height: 42,
////          width: ScreenUtils.screenW(context) - 40,
////          decoration: new BoxDecoration(
////            color: widget.backgroundColor,
////            borderRadius: BorderRadius.all(Radius.circular(8.0)),
////            border: new Border.all(color: Colors.grey, width: 1),
////          ),
//      ////    NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(12))
//        Neumorphic(
//
//          padding: EdgeInsets.only(left: 10,top:0,right: 10,bottom: 0),
//          margin: EdgeInsets.only(left: 10, top: 10),
//          style: NeumorphicStyle(
//              shape: NeumorphicShape.concave,
//              boxShape:
//           NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
//              depth: 10,
//
//              lightSource: LightSource.left,
//              color: Colors.grey
//          ),
//          child: Stack(
//            children: <Widget>[
//              Align(
//                child: TextField(
//                  maxLines: widget.maxLines,
//                  keyboardAppearance: widget.keyboardAppearance,
//                  keyboardType: widget.keyboardType,
//                  focusNode: widget.focusNode,
//                  enabled: widget.enabled,
//                  controller: widget.controller,
//                  onChanged: widget.onChanged,
//                  obscureText: widget.obscureText,
//                  style: widget.textStyle,
//                  inputFormatters: inputFormatters,
//                  decoration: InputDecoration(
//                      border: InputBorder.none,
//                      hintText: StringSet.NB_HINT + widget.labelText),
//                ),
//              ),
//
//            ],
//          ),
//        )
//      ],
//    );
  }




}
class _TextField extends StatefulWidget {
  final String label;
  final String hint;

  final ValueChanged<String> onChanged;

  _TextField({@required this.label, @required this.hint, this.onChanged});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<_TextField> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            this.widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Neumorphic(
          margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
          style: NeumorphicStyle(
            shadowLightColorEmboss: Colors.black38,
//            depth: NeumorphicTheme.embossDepth(context),
            depth: -20,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
          ),
          padding: EdgeInsets.symmetric(vertical:5, horizontal: 18),
          child: TextField(
            onChanged: this.widget.onChanged,
            controller: _controller,
            decoration: InputDecoration.collapsed(hintText: this.widget.hint),
          ),
        )
      ],
    );
  }
}