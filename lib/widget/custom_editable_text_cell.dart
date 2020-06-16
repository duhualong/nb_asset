import 'package:flutter/material.dart';
import 'text_field_widget.dart';
import '../common/style/string_set.dart';

class CustomEditableTextCell extends StatefulWidget {
  final String title;
  final bool isNecessary;
  final String content;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final int maxLength;
  final bool obscureText;

  CustomEditableTextCell({
    Key key,
    @required this.title,
    this.isNecessary = false,
    this.content,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onClear,
    this.maxLength,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _CustomEditableTextCellState createState() => _CustomEditableTextCellState();
}

class _CustomEditableTextCellState extends State<CustomEditableTextCell> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.content ?? StringSet.EMPTY;
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50.0),
            child: UnconstrainedBox(
              constrainedAxis: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  SizedBox(
                    width: 100,
                    child: Text(
                      widget.isNecessary
                          ? widget.title + StringSet.IS_NECESSARY
                          : widget.title,
                      style: TextStyle(
                        color: Color.fromRGBO(100, 100, 100, 1),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFieldWidget(
                      maxLines: 1,
                      underlineIsHidden: true,
                      controller: _textEditingController,
                      obscureText: widget.obscureText,
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[300],
                      ),
                      suffixIconData: Icons.clear,
                      suffixIconIsHidden: _textEditingController.text.isEmpty,
                      keyboardType: widget.keyboardType,
                      hintText: StringSet.PLEASE_INPUT +
                          (widget.title.startsWith(RegExp('[0-9a-zA-Z]'))
                              ? StringSet.SPACE
                              : StringSet.EMPTY) +
                          widget.title,
                      suffixIconOnTap: () {
                        widget.onClear();
                        _textEditingController.clear();
                      },
                      maxLength: widget.maxLength,
                      onChanged: widget.onChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
