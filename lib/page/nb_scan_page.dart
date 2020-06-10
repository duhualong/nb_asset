import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbassetentry/widget/custom_editable_image_cell.dart';
import '../common/model/option.dart';
import '../common/style/string_set.dart';
import '../common/style/style_set.dart';
import '../page/base_page.dart';
import '../widget/custom_picker_cell.dart';
import '../widget/custom_picker_power_cell.dart';
import '../widget/text_field_nb_input.dart';
import '../widget/text_nb.dart';
import '../common/config/config.dart';

class NbScanPage extends StatefulWidget {
  static final String routeName = '/nb_scan';

  final String result;

  NbScanPage({
    Key key,
    this.result,
  }) : super(key: key);

  @override
  _NbScanPageState createState() => _NbScanPageState();
}

class SortCondition {
  String name;
  bool isSelected;

  SortCondition({this.name, this.isSelected});
}

class _NbScanPageState extends State<NbScanPage> {
  int _currentIndex = -1;
  bool _isClick = false;
  List<Option> _groupOptions = [];
  int _groupPosition;
  String _groupName;
  String _carrierName;
  List<Option> _carrierOptions = [];
  List<Option> _loopOptions = [];
  int _carrierPosition;
  final TextEditingController _nameController = TextEditingController();
  String _barCode;
  String _imei;
  String _imsi;
  String _longitude;
  String _latitude;
  bool _switchUsed;
  bool _switchAlarm;
  bool _switchReply;
  int _loopPosition;
  String _loopName;
  List<Option> _powerOptions = StringSet.powerOptions;
  int _powerPosition;
  String _powerName;
  List<Option> _nbLight = [];
  List<String>_urls=[];
  List<String> _paths=[];

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController?.dispose();
  }

  void initData() {
    _switchUsed = false;
    _switchAlarm = false;
    _switchReply = false;
    _longitude = '123.99911';
    _latitude = '35.87766';
    _imei = '1523334555';
    _imsi = '222344556';
    _barCode = '112223444';
    _groupPosition = 0;
    _carrierPosition = 0;
    _loopPosition = 1;
    _loopName = '2';
    _carrierName = '移动';
    _groupName = '组1';
    _powerName = StringSet.NO_SETTING;
    _powerPosition = 0;
    _powerOptions
        .forEach((power) => power.isChecked == (power.id == _powerPosition));
    for (int i = 0; i <= _loopPosition; i++) {
      _nbLight.add(Option(
          id: i, title: StringSet.NO_SETTING, isChecked: false, value: 0));
    }
    _groupOptions.add(Option(id: 0, title: '组1', isChecked: true, value: 1));
    _groupOptions.add(Option(id: 1, title: '组2', isChecked: false, value: 2));
    _groupOptions.add(Option(id: 2, title: '组3', isChecked: false, value: 3));
    _carrierOptions.add(Option(id: 0, title: '移动', isChecked: true, value: 1));
    _carrierOptions.add(Option(id: 1, title: '电信', isChecked: false, value: 2));
    _carrierOptions.add(Option(id: 2, title: '联通', isChecked: false, value: 3));
    _loopOptions.add(Option(id: 0, title: '1', isChecked: false, value: 1));
    _loopOptions.add(Option(id: 1, title: '2', isChecked: true, value: 2));
    _loopOptions.add(Option(id: 2, title: '3', isChecked: false, value: 3));
    _loopOptions.add(Option(id: 3, title: '4', isChecked: false, value: 4));
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      hasAppBar: true,
      color: ThemeDataSet.tabColor,
      title: StringSet.NB_LAMP,
      leadingIconData: Icons.arrow_back_ios,
      leadingOnTap: () => Navigator.pop(context),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                _isClick
                    ? AssetSet.NB_SUMMON_SELECT
                    : AssetSet.NB_SUMMON_DEFAULT,
                height: Config.CIRCLE_SIZE,
                width: Config.CIRCLE_SIZE,
              ),
              title: Text(StringSet.EMPTY)),
          BottomNavigationBarItem(
              icon: Image.asset(
                _isClick
                    ? AssetSet.NB_DIMMING_SELECT
                    : AssetSet.NB_DIMMING_DEFAULT,
                height: Config.CIRCLE_SIZE,
                width: Config.CIRCLE_SIZE,
              ),
              title: Text(StringSet.EMPTY)),
          BottomNavigationBarItem(
              icon: Image.asset(
                _isClick ? AssetSet.NB_RESET_SELECT : AssetSet.NB_RESET_DEFAULT,
                height: Config.CIRCLE_SIZE,
                width: Config.CIRCLE_SIZE,
              ),
              title: Text(StringSet.EMPTY)),
          BottomNavigationBarItem(
              icon: Image.asset(
                _isClick
                    ? AssetSet.NB_ISSUED_SELECT
                    : AssetSet.NB_ISSUED_DEFAULT,
                height: Config.CIRCLE_SIZE,
                width: Config.CIRCLE_SIZE,
              ),
              title: Text(StringSet.EMPTY)),
        ],
        onTap: (int index) {
          if (!_isClick) {
            return;
          }
          _currentIndex = index;
          setState(() {});
        },
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            print('nameValue:${_nameController.text.trim()}');
            print('path::$_paths');
            print('url::$_urls');
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              StringSet.SAVE,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        )
      ],
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(239, 239, 244, 1),
          child: Column(
            children: <Widget>[
              NbTextFieldWidget(
                labelText: StringSet.NB_NAME,
                required: true,
                controller: _nameController,
              ),
              CustomPickerCell(
                title: StringSet.NB_GROUP,
                isNecessary: true,
                content: _groupName,
                options: _groupOptions,
                isMultiple: false,
                okButtonCanDisabled: true,
                onConfirm: (options) {
                  _groupPosition =
                      options.indexWhere((option) => option.isChecked);
                  _groupOptions.forEach((group) {
                    group.isChecked = (group.id == _groupPosition);
                  });

                  _groupName = _groupOptions[_groupPosition].title;
                  setState(() {});
                },
              ),
              CustomPickerCell(
                title: StringSet.NB_OPERATOR,
                isNecessary: true,
                content: _carrierName,
                options: _carrierOptions,
                isMultiple: false,
                okButtonCanDisabled: true,
                onConfirm: (options) {
                  _carrierPosition =
                      options.indexWhere((option) => option.isChecked);
                  _carrierOptions.forEach((carrier) {
                    carrier.isChecked = (carrier.id == _carrierPosition);
                  });

                  _carrierName = _carrierOptions[_carrierPosition].title;
                  setState(() {});
                },
              ),
              NbTextWidget(
                labelText: StringSet.NB_BARCODE,
                backgroundColor: Color.fromRGBO(229, 229, 234, 1.0),
                value: _barCode,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: NbTextWidget(
                      labelText: StringSet.NB_IMEI,
                      backgroundColor: Color.fromRGBO(229, 229, 234, 1.0),
                      value: _imei,
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: NbTextWidget(
                      labelText: StringSet.NB_IMSI,
                      backgroundColor: Color.fromRGBO(229, 229, 234, 1.0),
                      value: _imsi,
                    ),
                    flex: 1,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              NbTextWidget(
                labelText: StringSet.NB_LONGITUDE,
                backgroundColor: Color.fromRGBO(229, 229, 234, 1.0),
                value: _longitude,
              ),
              NbTextWidget(
                labelText: StringSet.NB_LATITUDE,
                backgroundColor: Color.fromRGBO(229, 229, 234, 1.0),
                value: _latitude,
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: EdgeInsets.fromLTRB(24, 6, 10, 6),
                child: Row(
                  children: <Widget>[
                    Text(
                      StringSet.NB_USED,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    CupertinoSwitch(
                      value: _switchUsed,
                      onChanged: (bool value) {
                        _switchUsed = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 1.0),
                padding: EdgeInsets.fromLTRB(24, 6, 10, 6),
                child: Row(
                  children: <Widget>[
                    Text(
                      StringSet.NB_ALARM,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    CupertinoSwitch(
                      value: _switchAlarm,
                      onChanged: (bool value) {
                        _switchAlarm = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(24, 6, 10, 6),
                child: Row(
                  children: <Widget>[
                    Text(
                      StringSet.NB_REPLY,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    CupertinoSwitch(
                      value: _switchReply,
                      onChanged: (bool value) {
                        _switchReply = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              CustomPickerCell(
                title: StringSet.NB_LOOP_COUNT,
                isNecessary: true,
                content: _loopName,
                options: _loopOptions,
                isMultiple: false,
                okButtonCanDisabled: true,
                onConfirm: (options) {
                  _loopPosition =
                      options.indexWhere((option) => option.isChecked);
                  _loopOptions.forEach((loop) {
                    loop.isChecked = (loop.id == _loopPosition);
                  });

                  _loopName = _loopOptions[_loopPosition].title;
                  _nbLight.clear();
                  print('_loopPosition:$_loopPosition');

                  setState(() {
                    for (int i = 0; i <= _loopPosition; i++) {
                      _nbLight.add(Option(
                          id: i,
                          title: StringSet.NO_SETTING,
                          isChecked: false,
                          value: 0));
                    }
                    print('_nbLight:${_nbLight.length}');
                  });
                },
              ),
              Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: new NeverScrollableScrollPhysics(),
                      itemCount: _nbLight.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 10, bottom: 1),
                              padding: EdgeInsets.fromLTRB(24, 2, 10, 2),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    StringSet.NB_OPEN_STATUS + '${index + 1}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  CupertinoSwitch(
                                    value: _nbLight[index].isChecked,
                                    onChanged: (bool value) {
                                      _nbLight[index].isChecked = value;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                            CustomPickerPowerCell(
                              title: '回路${index + 1}额定功率',
                              isNecessary: true,
                              content: _nbLight[index].title,
                              options: StringSet.powerOptions
                                  .map((power) => Option(
                                        id: power.id,
                                        title: power.title,
                                        isChecked: _nbLight[index].title ==
                                            power.title,
                                      ))
                                  .toList(),
                              isMultiple: false,
                              okButtonCanDisabled: true,
                              onConfirm: (options) {
                                _nbLight[index].title = StringSet
                                    .powerOptions[options.indexWhere(
                                        (option) => option.isChecked)]
                                    .title;
                                setState(() {});
                              },
                            ),
                          ],
                        );
                      })),
              CustomEditableImageCell(
                title:StringSet.NB_PICTURE,
                attribute: 'image',
                urls: _urls,
                paths:_paths,
              )
            ],
          ),
        ),
      ),
    );
  }
}
