import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:nbassetentry/common/dao/dao_result.dart';
import 'package:nbassetentry/common/dao/nb_dao.dart';
import 'package:nbassetentry/common/model/scan.dart';
import 'package:nbassetentry/common/util/screen_utils.dart';
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

class _NbScanPageState extends State<NbScanPage> {
  final _bottomSheetKey = GlobalKey<ScaffoldState>();
  Location _location;
  int _currentIndex = -1;
  bool _isClick = false;
  List<Option> _groupOptions = [];
  String _groupName;
  String _carrierName;
  List<Option> _carrierOptions = [];
  List<Option> _loopOptions = [];
  final TextEditingController _nameController = TextEditingController();
  String _barCode = StringSet.EMPTY;
  String _imei = StringSet.EMPTY;
  String _imsi = StringSet.EMPTY;
  String _longitude = StringSet.EMPTY;
  String _latitude = StringSet.EMPTY;
  bool _switchUsed = false;
  bool _switchAlarm = false;
  bool _switchReply = false;
  String _loopName;
  List<Option> _nbLight = [];
  List<String> _urls = [];
  List<String> _paths = [];
  FocusNode blankNode = FocusNode();
  List<String> _summonValue = [];
  List<String> _summonTitle = [];
  double _dimmingValue = 0;
  String assetId = '0';
  int groupId;
  int carrierId;
  int loopId = 1;

  @override
  initState() {
    super.initState();
    _initParseData();
  }

  Future<void> _initParseData() async {
    _location = await AmapLocation.fetchLocation();

    DaoResult result = await NbDao.scan(data: widget.result);
    if (!result.isSuccess) {
      return;
    }
    ScanResult scanResult = result.data;
    if (scanResult != null) {
      _nameController.value = TextEditingValue(
          text: scanResult.deviceParam.lightPoleCode ?? StringSet.EMPTY);
      assetId = scanResult.deviceParam.assetId;
      if (assetId != '0') {
        _isClick = true;
      }
      _imei = scanResult.deviceParam.imei;
      _imsi = scanResult.deviceParam.imsi;
      _carrierName = scanResult.deviceParam.carrierName;
      carrierId = scanResult.deviceParam.carrierId;
      _groupName = scanResult.deviceParam.groupName ?? StringSet.EMPTY;
      groupId = scanResult.deviceParam.groupId;
      _barCode = scanResult.deviceParam.barcodeId;
      _switchReply = (scanResult.deviceParam.reportReply == 1);
      _switchAlarm = (scanResult.deviceParam.autoAlarm == 1);
      _switchUsed = (scanResult.deviceParam.ctrlState == 1);
      scanResult.candidateItems.carrierList.forEach((carrier) =>
          _carrierOptions.add(Option(
              id: carrier.carrierId,
              title: carrier.carrierName,
              isChecked: carrierId == carrier.carrierId)));
      scanResult.candidateItems.groupList.forEach((group) => _groupOptions.add(
          Option(
              id: group.groupId,
              title: group.groupName,
              isChecked: groupId == group.groupId)));
      if (_groupName == StringSet.EMPTY) {
        _groupOptions[0].isChecked = true;
        groupId = _groupOptions[0].id;
        _groupName = _groupOptions[0].title;
      }
      for (int i = 1; i <= 4; i++) {
        _loopOptions.add(Option(
            id: i,
            title: i.toString(),
            isChecked: (i == scanResult.deviceParam.lampCount)));
      }
      if (scanResult.deviceParam.lampCount == 0 ||
          scanResult.deviceParam.lampCount > 4) {
        _loopOptions[1].isChecked = true;
        _loopName = '2';
        loopId = 1;
        for (int i = 0; i <= loopId; i++) {
          _nbLight.add(
              Option(id: 0, title: StringSet.NO_SETTING, isChecked: false));
        }
      } else {
        loopId = scanResult.deviceParam.lampCount - 1;
        _loopName = scanResult.deviceParam.lampCount.toString();

        if (scanResult.deviceParam.lampStatus.length > 0) {
          for (int i = 0; i <= loopId; i++) {
            _nbLight.add(Option(
                id: i,
                title: scanResult.deviceParam.lampStatus[i].powerRate == 0
                    ? StringSet.NO_SETTING
                    : (scanResult.deviceParam.lampStatus[i].powerRate
                            .toString() + 'W'),
                isChecked:
                    scanResult.deviceParam.lampStatus[i].autoLight == 1));
          }
        }
      }

      _longitude = scanResult.deviceParam.longitude > 10
          ? scanResult.deviceParam.longitude.toString()
          : _location.latLng.longitude.toString();
      _latitude = scanResult.deviceParam.latitude > 10
          ? scanResult.deviceParam.latitude.toString()
          : _location.latLng.latitude.toString();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController?.dispose();
  }



  void showDimming(BuildContext context) {
    List<int> _buttonLightStatus = [
      1,
      _nbLight.length > 1 ? 1 : 0,
      _nbLight.length > 2 ? 1 : 0,
      _nbLight.length > 3 ? 1 : 0
    ];
    bool _isEnable = false;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, state) {
                return Stack(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 30),
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        child: Column(children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Align(
                                alignment: Alignment(1.0, 0.0),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 16.0, top: 6.0),
                                  child: Icon(
                                    Icons.clear,
                                    size: 28,
                                    color: Colors.black26,
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 30, bottom: 20),
                            height: 40,
                            alignment: Alignment.center,
                            width: ScreenUtils.screenW(context),
                            child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 4,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 15,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (_buttonLightStatus[index] == 0) {
                                        return;
                                      }
                                      _buttonLightStatus[index] =
                                          (_buttonLightStatus[index] - 3).abs();
                                      _isEnable =
                                          _buttonLightStatus.contains(2);
                                      state(() {});
                                    },
                                    child: _buttonLightStatus[index] == 1
                                        ? DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(
                                                Config.CLIP_RANGE),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Config.CLIP_RANGE)),
                                              child: Container(
                                                height: 40,
                                                width: ScreenUtils.screenW(
                                                            context) /
                                                        4 -
                                                    20,
                                                color: Color.fromRGBO(
                                                    239, 239, 244, 1),
                                                child: Center(
                                                  child: Text('灯头${index + 1}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14)),
                                                ),
                                              ),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Config.CLIP_RANGE)),
                                            child: Container(
                                              height: 40,
                                              width:
                                                  ScreenUtils.screenW(context) /
                                                          4 -
                                                      20,
                                              color:
                                                  _buttonLightStatus[index] == 2
                                                      ? ThemeDataSet.tabColor
                                                      : Color.fromRGBO(
                                                          239, 239, 244, 1),
                                              child: Center(
                                                child: Text(
                                                  '灯头${index + 1}',
                                                  style: TextStyle(
                                                      color: _buttonLightStatus[
                                                                  index] ==
                                                              2
                                                          ? Colors.white
                                                          : Colors.grey,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            )),
                                  );
                                }),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(16),
                            child: Text(
                              '光照：${_dimmingValue.toInt()}%',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          Container(
                            width: ScreenUtils.screenW(context),
                            height: 60,
                            padding: EdgeInsets.all(16),
                            alignment: Alignment.center,
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  AssetSet.NB_SMALL_DIMMING,
                                  height: 15,
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: FlutterSlider(
                                    values: [_dimmingValue],
                                    jump: false,
                                    max: 100,
                                    min: 0,
                                    disabled: false,
                                    handlerWidth: 20,
                                    handlerHeight: 24,
                                    trackBar: FlutterSliderTrackBar(
                                      inactiveTrackBarHeight: 16,
                                      activeTrackBarHeight: 16,
                                      inactiveTrackBar: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0x10000000),
                                      ),
                                      activeTrackBar: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: ThemeDataSet.tabColor),
                                      activeDisabledTrackBarColor:
                                          Theme.of(context).disabledColor,
                                    ),
                                    handler: FlutterSliderHandler(
                                      decoration: BoxDecoration(),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0x35000000),
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 3.0,
                                                spreadRadius: 1.0),
                                            BoxShadow(
                                                color: Color(0x35000000),
                                                offset: Offset(1.0, 1.0)),
                                            BoxShadow(color: Color(0x35000000))
                                          ],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    onDragCompleted:
                                        (handlerIndex, lowerValue, upperValue) {
                                      print('lowerValue:$lowerValue');
                                      _dimmingValue = lowerValue;
                                      state(() {});
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Image.asset(
                                  AssetSet.NB_LARGE_DIMMING,
                                  height: 24,
                                  width: 24,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          SizedBox(
                            width: ScreenUtils.screenW(context) / 3,
                            height: 40,
                            child: FlatButton(
                              color: ThemeDataSet.tabColor,
                              highlightColor: Theme.of(context).highlightColor,
                              disabledColor: Theme.of(context).disabledColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Text(
                                StringSet.CONFIRM,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: _isEnable ? () {} : null,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ])),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Hero(
                          tag: AssetSet.NB_BOTTOM_SHEET_SUMMON,
                          child: Container(
                            height: 60.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        AssetSet.NB_BOTTOM_SHEET_DIMMING))),
                          )),
                    ),
                  ],
                );
              },
            ));
  }

  void _showMenu(BuildContext context) {
    _summonValue.clear();
    _summonValue.add(_nameController.text.trim());
    _summonValue.add(_carrierName);
    _summonValue.add(_barCode);
    _summonValue.add(_imei);
    _summonValue.add(_imsi);
    _summonValue.add(_longitude);
    _summonValue.add(_latitude);
    _summonValue.add(_switchUsed ? StringSet.YES : StringSet.NO);
    _summonValue.add(_switchAlarm ? StringSet.YES : StringSet.NO);
    _summonValue.add(_switchReply ? StringSet.YES : StringSet.NO);
    _summonValue.add(_nbLight.length.toString());
    _summonTitle.clear();
    _summonTitle.addAll(StringSet.summonName);
    _nbLight.forEach((light) {
      _summonTitle.add('上电开灯${light.id + 1}');
      _summonValue.add(light.isChecked ? StringSet.YES : StringSet.NO);
      _summonTitle.add('回路${light.id + 1}额定功率');
      _summonValue.add(light.title);
    });

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 30),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Align(
                      alignment: Alignment(1.0, 0.0),
                      child: Container(
                          margin: const EdgeInsets.only(right: 16.0, top: 6.0),
                          child: Icon(
                            Icons.clear,
                            size: 28,
                            color: Colors.black26,
                          )),
                    )),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, bottom: 10, top: 10),
                    child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: _summonTitle.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  _summonTitle[index],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                    _summonValue[index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                            ],
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
                tag: AssetSet.NB_BOTTOM_SHEET_SUMMON,
                child: Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(AssetSet.NB_BOTTOM_SHEET_SUMMON))),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      key: _bottomSheetKey,
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
          switch (index) {
            case 0:
              _showMenu(context);
              break;
            case 1:
              showDimming(context);
              break;
            case 2:
              showCustomDialog(context, '复位成功');
              break;
            case 3:
              showCustomDialog(context, '下发参数成功');

              break;
          }
          setState(() {});
        },
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            print('nameValue:${_nameController.text.trim()}');
            print('path::$_paths');
            print('url::$_urls');
            FocusScope.of(context).requestFocus(blankNode);
            if (_nameController.text.trim() != StringSet.EMPTY) {
              setState(() {
                _isClick = true;
              });
            }
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
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(blankNode);
        },
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
                  int position =
                      options.indexWhere((option) => option.isChecked);
                  for (int index = 0; index < _groupOptions.length; index++) {
                    _groupOptions[index].isChecked = (position == index);
                    if (_groupOptions[index].isChecked) {
                      _groupName = _groupOptions[index].title;
                      groupId = _groupOptions[index].id;
                    }
                  }

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
                  int position =
                      options.indexWhere((option) => option.isChecked);
                  for (int index = 0; index < _carrierOptions.length; index++) {
                    _carrierOptions[index].isChecked = (position == index);
                    if (_carrierOptions[index].isChecked) {
                      _carrierName = _carrierOptions[index].title;
                      carrierId = _carrierOptions[index].id;
                    }
                  }

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
                    width: 12,
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
                    width: 12,
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
                padding: EdgeInsets.fromLTRB(20, 6, 10, 6),
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
                padding: EdgeInsets.fromLTRB(20, 6, 10, 6),
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
                padding: EdgeInsets.fromLTRB(20, 6, 10, 6),
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
                  loopId = options.indexWhere((option) => option.isChecked);
                  _loopOptions.forEach((loop) {
                    loop.isChecked = (loop.id == (loopId + 1));
                  });

                  _loopName = _loopOptions[loopId].title;
                  _nbLight.clear();
                  setState(() {
                    for (int i = 0; i <= loopId; i++) {
                      _nbLight.add(Option(
                        id: i,
                        title: StringSet.NO_SETTING,
                        isChecked: false,
                      ));
                    }
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
                              padding: EdgeInsets.fromLTRB(20, 2, 10, 2),
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
                title: StringSet.NB_PICTURE,
                attribute: 'image',
                urls: _urls,
                paths: _paths,
              )
            ],
          ),
        ),
      )),
    );
  }

  void showCustomDialog(BuildContext context, String title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Padding(
              child: Text(title),
              padding: EdgeInsets.all(10),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  StringSet.CONFIRM,
                  style: TextStyle(
                      color: Color.fromRGBO(26, 136, 255, 1.0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
