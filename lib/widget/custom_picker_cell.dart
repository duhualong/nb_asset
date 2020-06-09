import 'package:flutter/material.dart';
import 'package:nbassetentry/common/util/screen_utils.dart';
import 'text_field_widget.dart';
import 'custom_cell_with_divider.dart';
import '../common/model/option.dart';
import '../common/style/string_set.dart';

class CustomPickerCell extends StatefulWidget {
  final String title;
  final bool isNecessary;
  final String content;
  final List<Option> options;

  /// 单选/多选
  final bool isMultiple;

  /// 没有选中任何一项时，确定按钮是否可用
  final bool okButtonCanDisabled;
  final ValueChanged<List<Option>> onConfirm;
  final bool require;

  CustomPickerCell({
    Key key,
    @required this.title,
    this.isNecessary = false,
    this.content,
    this.options = const [],
    this.onConfirm,
    this.isMultiple = false,
    this.okButtonCanDisabled = false,
    this.require = false,
  }) : super(key: key);

  @override
  _CustomPickerCellState createState() => _CustomPickerCellState();
}

class _CustomPickerCellState extends State<CustomPickerCell> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Option> _tempOptions = [];

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
    _textEditingController.text = widget.content ?? StringSet.EMPTY;
    return Container(
      child: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50.0),
            child: UnconstrainedBox(
                constrainedAxis: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: RichText(
                          text: TextSpan(
                              text: widget.title,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              children: <TextSpan>[
                            TextSpan(
                                text: widget.require
                                    ? StringSet.NECESSARY
                                    : StringSet.EMPTY,
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
                        child: GestureDetector(
                          onTap: () => _showPicker(),
                          child: TextFieldWidget(
                            backgroundColor: Colors.transparent,
                            maxLines: null,
                            enabled: false,
                            underlineIsHidden: true,
                            controller: _textEditingController,
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[300],
                            ),
                            suffixIconData: Icons.keyboard_arrow_down,
                            hintText: StringSet.PLEASE_SELECT +
                                (widget.title.startsWith(RegExp('[0-9a-zA-Z]'))
                                    ? StringSet.SPACE
                                    : StringSet.EMPTY) +
                                widget.title,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void _showPicker() {
    _tempOptions = widget.options.map((option) => option.copy()).toList();
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Row(
                      children:
                          _headerView(setState: setState, context: context),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 0.5)),
                      color: Theme.of(context).bottomAppBarColor,
                    ),
                  ),
                  Container(
                    height: 300,
                    child: Column(
                      children: <Widget>[
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.options.length,
                            itemBuilder: (context, index) {
                              return CustomCellWithDivider(
                                height: 50,
                                child: _listTile(
                                  index: index,
                                  setState: setState,
                                  context: context,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      isScrollControlled: true,
    );
  }

  Widget _listTile({int index, StateSetter setState, BuildContext context}) {
    return widget.isMultiple
        ? CheckboxListTile(
            activeColor: Theme.of(context).primaryColor,
            title: Text(widget.options[index].title),
            value: _tempOptions[index].isChecked,
            selected: false,
            onChanged: (value) {
              _tempOptions[index].isChecked = value;
              setState(() {});
            },
            controlAffinity: ListTileControlAffinity.trailing,
          )
        : RadioListTile(
            activeColor: Theme.of(context).primaryColor,
            title: Text(widget.options[index].title),
            value: true,
            groupValue: _tempOptions[index].isChecked,
            selected: false,
            onChanged: (value) {
              _tempOptions.forEach((option) => option.isChecked = false);
              _tempOptions[index].isChecked = value;
              setState(() {});
            },
            controlAffinity: ListTileControlAffinity.trailing,
          );
  }

  List<Widget> _headerView({StateSetter setState, BuildContext context}) {
    List<Widget> items = [];
    items.add(
      FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          StringSet.CANCEL,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color.fromRGBO(100, 100, 100, 1),
            fontSize: 15,
          ),
        ),
      ),
    );
    items.add(
      Expanded(
        child: Container(),
      ),
    );
    if (widget.isMultiple) {
      items.add(
        FlatButton(
          onPressed: () {
            _tempOptions.every((option) => option.isChecked)
                ? _tempOptions.forEach((option) => option.isChecked = false)
                : _tempOptions.forEach((option) => option.isChecked = true);
            setState(() {});
          },
          child: Text(
            _tempOptions.every((option) => option.isChecked)
                ? StringSet.UNSELECT_ALL
                : StringSet.SELECT_ALL,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15,
            ),
          ),
        ),
      );
    }
    items.add(
      FlatButton(
        onPressed: widget.okButtonCanDisabled &&
                _tempOptions.every((option) => !option.isChecked)
            ? null
            : () {
                widget.onConfirm(_tempOptions);
                Navigator.of(context).pop();
              },
        child: Text(
          StringSet.CONFIRM,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: widget.okButtonCanDisabled &&
                    _tempOptions.every((option) => !option.isChecked)
                ? Theme.of(context).disabledColor
                : Theme.of(context).primaryColor,
            fontSize: 15,
          ),
        ),
      ),
    );
    return items;
  }
}
