import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:nbassetentry/common/local/local_storage.dart';
import 'package:nbassetentry/common/model/nb_param_entity.dart';
import 'package:nbassetentry/widget/text_field_nb_input_new.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../common/dao/dao_result.dart';
import '../common/dao/nb_dao.dart';
import '../common/event/jpush_event.dart';
import '../common/model/nb_data.dart';
import '../common/model/scan.dart';
import '../common/util/screen_utils.dart';
import '../widget/custom_editable_image_cell.dart';
import '../common/model/option.dart';
import '../common/style/string_set.dart';
import '../common/style/style_set.dart';
import '../page/base_page.dart';
import '../widget/custom_picker_cell.dart';
import '../widget/custom_picker_power_cell.dart';
import '../widget/text_field_nb_input.dart';
import '../widget/text_nb.dart';
import '../common/config/config.dart';

class NbScanPage extends StatelessWidget {
  static final String routeName = '/nb_scan';
  final String result;

  NbScanPage({
    Key key,
    this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        defaultTextColor: Color(0xFF3E3E3E),
        accentColor: Colors.grey,
        variantColor: Colors.white60,
        depth: 8,
        intensity: 0.65,
      ),
      themeMode: ThemeMode.light,
      child: Material(
        child: NeumorphicBackground(
          child: NbScanWidget(
            result: result,
          ),
        ),
      ),
    );
  }
}

class NbScanWidget extends StatefulWidget {
  final String result;

  NbScanWidget({
    Key key,
    this.result,
  }) : super(key: key);

  @override
  _NbScanWidgetState createState() => _NbScanWidgetState();
}

class _NbScanWidgetState extends State<NbScanWidget> {
  Location _location;
  bool _isClick = false;
  List<Option> _groupOptions = [];
  List<Option> _providerOptions = [];
  List<Option> _versionOptions = [];
  String _groupName;
  String _carrierName;
  List<Option> _carrierOptions = [];
  List<Option> _loopOptions = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _lightingCodeController = TextEditingController();
  final TextEditingController _recycleController = TextEditingController();
  String _barCode = StringSet.EMPTY;
  String _imei = StringSet.EMPTY;
  int _recycle = Config.ZERO;
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
  double _dimmingValue = Config.ZERO_DOUBLE;
  String assetId = StringSet.ZERO;
  int groupId;
  int carrierId;
  int loopId = Config.LOOP_COUNT;
  StreamSubscription _stream;
  String icccid = StringSet.EMPTY;
  BuildContext _context;
  JPush _jPush = new JPush();
  String jpushId = StringSet.EMPTY;
  ProgressDialog pr;
  String op = StringSet.EMPTY;
  bool isOvertime = false;
  int _providerId = Config.ZERO;
  int _version;
  String _provider = StringSet.EMPTY;

  @override
  initState() {
    super.initState();
    _initParseData();
    _initStream();
  }

  ///接收极光推送信息
  Future<void> _initStream() async {
    _stream = JpushEvent.eventBus.on<dynamic>().listen((object) {
      if (!object.toString().contains('status') || isOvertime) {
        return;
      }

      Map<String, dynamic> data = object;
      int status = 0;
      if (Platform.isAndroid) {
        String _jsonString = data['extras']['cn.jpush.android.EXTRA'];
        Map<String, dynamic> map = json.decode(_jsonString);
        status = map['json']['status'];
      } else if (Platform.isIOS) {
        status = data['json']['status'];
      }

      bool isSuccess = status == 1;
      pr.hide();
      if (!isSuccess) {
        showCustomDialog(op + "失败");
        setState(() {});
        return;
      }
      if (data.toString().contains('longitude') &&
          data.toString().contains('run_param')) {
        if (Platform.isIOS) {
          List originList =
              data['json']['run_param']['lamp_status'] as List ?? [];
          List<LampStatus> lampStatusList = originList
              .map((value) => LampStatus(
                  autoLight: value['auto_light'],
                  lampVector: value['lamp_vector'],
                  powerRate: value['power_rate']))
              .toList();
          _showMenu(
              autoAlarm: data['json']['run_param']['auto_alarm'] as int ?? 0,
              ctrlState: data['json']['run_param']['ctrl_state'] as int ?? 0,
              lat: data['json']['run_param']['latitude'].toString(),
              lng: data['json']['run_param']['longitude'].toString(),
              reportReply:
                  data['json']['run_param']['report_reply'] as int ?? 0,
              lampStatus: lampStatusList ?? []);
        } else {
          String _jsonString = data['extras']['cn.jpush.android.EXTRA'];
          Map<String, dynamic> map = json.decode(_jsonString);
          NbData dimmingData = NbData.fromJson(map['json']);
          _showMenu(
              autoAlarm: dimmingData.autoAlarm,
              ctrlState: dimmingData.ctrlState,
              lat: dimmingData.latitude,
              lng: dimmingData.longitude,
              reportReply: dimmingData.reportReply,
              lampStatus:
                  dimmingData.lampCount > 0 ? dimmingData.lampStatus : []);
        }
      } else {
        showCustomDialog(op + "成功");
      }
      setState(() {});
    });
  }

  Future<void> _dimmingNb(List<int> loop) async {
    List<int> _loop = [];
    for (int i = 0; i < loop.length; i++) {
      if (loop[i] == 2) {
        _loop.add(i + 1);
      }
    }

    DaoResult result = await NbDao.dimmingNb(
      assetId: assetId,
      jpushId: jpushId,
      lampId: _loop,
      op: _dimmingValue.toInt(),
    );
    if (!result.isSuccess) {
      return;
    }

    pr.show();
    toastMessage(message: StringSet.NB_DIMMING_OVERTIME);
  }

  Future<void> _initParseData() async {
    jpushId = await _jPush.getRegistrationID();
    _location = await AmapLocation.fetchLocation();
    DaoResult result = await NbDao.scan(data: widget.result);
    if (!result.isSuccess) {
      return;
    }
//    ScanResult scanResult = result.data;
    NbParamEntity nbParamEntity = result.data;
    if (NbParamEntity != null) {
      _nameController.value = TextEditingValue(
          text: nbParamEntity.deviceParam.lightPoleCode ?? StringSet.EMPTY);
      _recycle = nbParamEntity.deviceParam.reportCycle ?? Config.ZERO;
      _recycleController.value = TextEditingValue(text: _recycle.toString());
      assetId = nbParamEntity.deviceParam.assetId;
      if (assetId != StringSet.ZERO) {
        _isClick = true;
      }
      _version = nbParamEntity.deviceParam.protocolVersion ?? Config.ZERO;
      _imei = nbParamEntity.deviceParam.imei;
      _imsi = nbParamEntity.deviceParam.imsi;
      _carrierName = nbParamEntity.deviceParam.carrierName;
      carrierId = nbParamEntity.deviceParam.carrierId;
      _groupName = nbParamEntity.deviceParam.groupName ?? StringSet.EMPTY;
      groupId = nbParamEntity.deviceParam.groupId;
      _providerId = nbParamEntity.deviceParam.providerId ?? Config.ZERO;
      _provider = nbParamEntity.deviceParam.provider ?? StringSet.EMPTY;
      _barCode = nbParamEntity.deviceParam.barcodeId;
      _switchReply = (nbParamEntity.deviceParam.reportReply == 1);
      _switchAlarm = (nbParamEntity.deviceParam.autoAlarm == 1);
      _switchUsed = (nbParamEntity.deviceParam.ctrlState == 1);
      icccid = nbParamEntity.deviceParam.iccid ?? StringSet.EMPTY;
      StringSet.versionOptions.forEach((version) => _versionOptions.add(Option(
          id: version.id,
          title: version.title,
          isChecked: _version == version.id)));

      nbParamEntity.candidateItems.carrierList.forEach((carrier) =>
          _carrierOptions.add(Option(
              id: carrier.carrierId,
              title: carrier.carrierName,
              isChecked: carrierId == carrier.carrierId)));
      nbParamEntity.candidateItems.groupList.forEach((group) =>
          _groupOptions.add(Option(
              id: group.groupId,
              title: group.groupName,
              isChecked: groupId == group.groupId)));
      nbParamEntity.candidateItems.providerList.forEach((provider) =>
          _providerOptions.add(Option(
              id: provider.providerId,
              title: provider.provider,
              isChecked: _providerId == provider.providerId)));
      if (_provider == StringSet.EMPTY) {
        _providerOptions[0].isChecked = true;
        _providerId = _providerOptions[0].id;
        _provider = _providerOptions[0].title;
      }
      if (_groupName == StringSet.EMPTY) {
        _groupOptions[0].isChecked = true;
        groupId = _groupOptions[0].id;
        _groupName = _groupOptions[0].title;
      }
      for (int i = 1; i <= 4; i++) {
        _loopOptions.add(Option(
            id: i,
            title: i.toString(),
            isChecked: (i == nbParamEntity.deviceParam.lampCount)));
      }
      if (nbParamEntity.deviceParam.lampCount == 0 ||
          nbParamEntity.deviceParam.lampCount > 4) {
        _loopOptions[1].isChecked = true;
        _loopName = '2';
        loopId = 1;
        for (int i = 0; i <= loopId; i++) {
          _nbLight.add(Option(
              id: 0,
              title: StringSet.NO_SETTING,
              isChecked: false,
              isReverse: false));
        }
      } else {
        loopId = nbParamEntity.deviceParam.lampCount - 1;
        _loopName = nbParamEntity.deviceParam.lampCount.toString();

        if (nbParamEntity.deviceParam.lampStatus.length > 0) {
          for (int i = 0; i <= loopId; i++) {
            _nbLight.add(Option(
                id: i,
                title: nbParamEntity.deviceParam.lampStatus[i].powerRate == 0
                    ? StringSet.NO_SETTING
                    : (nbParamEntity.deviceParam.lampStatus[i].powerRate
                            .toString() +
                        'W'),
                isChecked:
                    nbParamEntity.deviceParam.lampStatus[i].autoLight == 1,
                isReverse:
                    nbParamEntity.deviceParam.lampStatus[i].reverseDimming ==
                        1));
          }
        }
      }

      _longitude = (nbParamEntity.deviceParam.longitude > Config.ZERO)
          ? nbParamEntity.deviceParam.longitude.toString()
          : _location.latLng.longitude.toString();
      _latitude = (nbParamEntity.deviceParam.latitude > Config.ZERO)
          ? nbParamEntity.deviceParam.latitude.toString()
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
    _recycleController?.dispose();

    _stream?.cancel();
    _stream = null;
  }

  void showDimming() {
    List<int> _buttonLightStatus = [
      1,
      _nbLight.length > 1 ? 1 : 0,
      _nbLight.length > 2 ? 1 : 0,
      _nbLight.length > 3 ? 1 : 0
    ];
    bool _isEnable = false;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: _context,
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
                              '光照：${_dimmingValue.toInt()}% ' +
                                  '${_dimmingValue == 0 ? StringSet.CLOSE : (_dimmingValue == 100 ? StringSet.OPEN : StringSet.EMPTY)}',
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
                                    max: Config.MAX_DIMMING,
                                    min: Config.MIN_DIMMING,
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
                              onPressed: _isEnable
                                  ? () {
                                      Navigator.pop(context);

                                      _dimmingNb(_buttonLightStatus);
                                    }
                                  : null,
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

  void _showMenu(
      {int autoAlarm,
      int ctrlState,
      String lat,
      String lng,
      int reportReply,
      List<LampStatus> lampStatus}) {
    if (lampStatus.length > 0) {
      _nbLight.clear();
      lampStatus.forEach((lamp) => _nbLight.add(Option(
          id: lamp.lampVector - 1,
          title: lamp.powerRate == 0
              ? StringSet.NO_SETTING
              : (lamp.powerRate.toString() + 'W'),
          isChecked: lamp.autoLight == 1)));
    }
    _loopName = _nbLight.length.toString();
    loopId = _nbLight.length - 1;
    _summonValue.clear();
    _summonValue.add(_nameController.text.trim());
    _summonValue.add(_carrierName);
    _summonValue.add(_barCode);
    _summonValue.add(_imei);
    _summonValue.add(_imsi);
    _summonValue.add(lng != StringSet.EMPTY ? lng : StringSet.SLASH);
    _summonValue.add(lat != StringSet.EMPTY ? lat : StringSet.SLASH);
    _summonValue.add(icccid != StringSet.EMPTY ? icccid : StringSet.SLASH);
    _summonValue.add(
        ctrlState == Config.ONE ?? Config.ZERO ? StringSet.YES : StringSet.NO);
    _summonValue.add(
        autoAlarm == Config.ONE ?? Config.ZERO ? StringSet.YES : StringSet.NO);
    _summonValue.add(reportReply == Config.ONE ?? Config.ZERO
        ? StringSet.YES
        : StringSet.NO);
    _summonValue.add(_nbLight.length.toString());
    _summonTitle.clear();
    _summonTitle.addAll(StringSet.summonName);
    _nbLight.forEach((light) {
      _summonTitle.add('上电开灯${light.id + 1}');
      _summonValue.add(light.isChecked ? StringSet.YES : StringSet.NO);
      _summonTitle
          .add(StringSet.LOOP + '${light.id + 1}' + StringSet.RATED_POWER);
      _summonValue.add(light.title);
    });

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: _context,
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

  Future<void> _updateAsset(BuildContext buildContext) async {
    if (_switchAlarm) {
      String value = _recycleController.text.trim() ?? StringSet.ZERO;
      _recycle = int.parse(value);
    }
    DaoResult result = await NbDao.updateAssetInfo(
      assetId: assetId,
      lightPoleCode: _nameController.text.trim(),
      groupId: groupId,
      carrierId: carrierId,
      barCode: _barCode,
      imei: _imei,
      imsi: _imsi,
      lat: double.parse(_latitude),
      lng: double.parse(_longitude),
      ctrlState: _switchUsed ? 1 : 0,
      autoAlarm: _switchAlarm ? 1 : 0,
      lampCount: loopId + 1,
      autoLightOne: _nbLight[0].isChecked ? 1 : 0,
      reverseDimmingOne: _nbLight[0].isReverse ? 1 : 0,
//      autoLightOne: StringSet.powerOptions
//          .where((option) => option.title == _nbLight[0].title)
//          .toList()[0]
//          .isChecked
//          ? 1
//          : 0,
      powerRateOne: StringSet.powerOptions
          .where((option) => option.title == _nbLight[0].title)
          .toList()[0]
          .id,
      autoLightTwo: (loopId >= 1) ? (_nbLight[1].isChecked ? 1 : 0) : 0,
      reverseDimmingTwo: (loopId >= 1) ? (_nbLight[1].isReverse ? 1 : 0) : 0,
//      autoLightTwo: (loopId >= 1)
//          ? (StringSet.powerOptions
//          .where((option) => option.title == _nbLight[1].title)
//          .toList()[0]
//          .isChecked
//          ? 1
//          : 0)
//          : 0,
      powerRateTwo: (loopId >= 1)
          ? (StringSet.powerOptions
              .where((option) => option.title == _nbLight[1].title)
              .toList()[0]
              .id)
          : 0,
      autoLightThree: (loopId >= 2) ? (_nbLight[2].isChecked ? 1 : 0) : 0,
      reverseDimmingThree: (loopId >= 2) ? (_nbLight[2].isReverse ? 1 : 0) : 0,

//      autoLightThree: (loopId >= 2)
//          ? (StringSet.powerOptions
//          .where((option) => option.title == _nbLight[2].title)
//          .toList()[0]
//          .isChecked
//          ? 1
//          : 0)
//          : 0,
      powerRateThree: (loopId >= 2)
          ? (StringSet.powerOptions
              .where((option) => option.title == _nbLight[2].title)
              .toList()[0]
              .id)
          : 0,
      autoLightFour: (loopId >= 3) ? (_nbLight[3].isChecked ? 1 : 0) : 0,
      reverseDimmingFour: (loopId >= 3) ? (_nbLight[3].isReverse ? 1 : 0) : 0,
//      autoLightFour: (loopId >= 3)
//          ? (StringSet.powerOptions
//          .where((option) => option.title == _nbLight[3].title)
//          .toList()[0]
//          .isChecked
//          ? 1
//          : 0)
//          : 0,
      powerRateFour: (loopId >= 3)
          ? (StringSet.powerOptions
              .where((option) => option.title == _nbLight[3].title)
              .toList()[0]
              .id)
          : 0,
      reportReply: _switchReply ? 1 : 0,
      paths: _paths,
      iccid: icccid,
      reportCycle: _recycle,
      protocolVersion: _version,
      providerId: _providerId,
      provider: _provider,
    );

    if (!result.isSuccess) {
      return;
    }
    assetId = result.data;
    await LocalStorage.set(Config.DEVICE_PLACE, _addressController.text.trim());

    _isClick = true;
    setState(() {});
    showCustomDialog(assetId == StringSet.ZERO
        ? StringSet.NB_REPORT_SUCCESS
        : StringSet.NB_UPDATE_SUCCESS);
  }

  Future<void> _showProgress(BuildContext context) async {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    pr.style(message: '请求加载中...');
  }

  Future<void> _sendNb() async {
    DaoResult daoResult =
        await NbDao.sendNb(assetId: assetId, jpushId: jpushId);
    if (!daoResult.isSuccess) {
      return;
    }
    pr.show();
    toastMessage(message: StringSet.NB_SEND_OVERTIME);
  }

  Future<void> toastMessage({
    String message,
  }) async {
    Future.delayed(Duration(seconds: Config.SECONDS_TIMEOUT)).then((onValue) {
      if (pr.isShowing())
        pr.hide().then((isHidden) {
          Fluttertoast.showToast(msg: message);
          isOvertime = true;
          setState(() {});
        });
    });
  }

  Future<void> _resetNb() async {
    DaoResult daoResult =
        await NbDao.resetNb(assetId: assetId, jpushId: jpushId);
    if (!daoResult.isSuccess) {
      return;
    }
    pr.show();
    toastMessage(message: StringSet.NB_REST_OVERTIME);
  }

  Future<void> _readNb() async {
    DaoResult daoResult =
        await NbDao.readNb(assetId: assetId, jpushId: jpushId);
    if (!daoResult.isSuccess) {
      return;
    }
    pr.show();
    toastMessage(message: StringSet.NB_READ_OVERTIME);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _showProgress(_context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: NeumorphicAppBar(
        color: ThemeDataSet.tabColor,
        buttonStyle: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
        title: Text(
          StringSet.NB_LAMP,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          NeumorphicButton(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.stadium(),
            ),
            child: Align(alignment: Alignment.center, child: Icon(Icons.save)),
            onPressed: () {
              FocusScope.of(context).requestFocus(blankNode);
              if (_nameController.text.trim() == StringSet.EMPTY) {
                Fluttertoast.showToast(msg: '请填写资产名称');
                return;
              }
              if (_lightingCodeController.text.trim() == StringSet.EMPTY) {
                Fluttertoast.showToast(msg: '请填写灯杆编号');
                return;
              }
              if (_addressController.text.trim() == StringSet.EMPTY) {
                Fluttertoast.showToast(msg: '请填写道路名称');
                return;
              }
              _updateAsset(context);
            },
          ),
        ],
      ),
//      BasePage(
//      hasAppBar: true,
//      color: ThemeDataSet.tabColor,
//      title: StringSet.NB_LAMP,
//      leadingIconData: Icons.arrow_back_ios,
//      leadingOnTap: () => Navigator.pop(context),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white70,
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
          isOvertime = false;
          switch (index) {
            case 0:
              _readNb();
              break;
            case 1:
              op = '调光';
              showDimming();
              break;
            case 2:
              op = '复位';
              _resetNb();
              break;
            case 3:
              op = '下发参数';
              _sendNb();

              break;
          }

          setState(() {});
        },
      ),
//      actions: <Widget>[
//        GestureDetector(
//          onTap: () {
//            FocusScope.of(context).requestFocus(blankNode);
//            if (_nameController.text.trim() != StringSet.EMPTY) {
//              _updateAsset(context);
//            }
//          },
//          child: Align(
//            alignment: Alignment.center,
//            child: Text(
//              StringSet.SAVE,
//              style: TextStyle(color: Colors.white, fontSize: 18),
//            ),
//          ),
//        )
//      ],
      body: SingleChildScrollView(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: Neumorphic(
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          ),
//            Container(
//              color: Color.fromRGBO(239, 239, 244, 1),
          child: Column(
            children: <Widget>[
              NbTextFieldWidget(
                labelText: StringSet.ROAD_NAME,
                required: true,
                controller: _addressController,
              ),
              NbTextFieldWidget(
                labelText: StringSet.LAMP_CODE,
                required: true,
                controller: _lightingCodeController,
              ),
              NbTextFieldWidget(
                labelText: StringSet.NB_NAME,
                required: true,
                controller: _nameController,
              ),
//                  NbTextFieldNewWidget(
//                    labelText: StringSet.NB_NAME,
//                    required: true,
//                    controller: _nameController,
//                  ),
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
                ],
              ),
              NbTextWidget(
                labelText: StringSet.NB_LONGITUDE,
                backgroundColor: Color.fromRGBO(229, 229, 234, 1.0),
                value: _longitude.length > 10
                    ? _longitude.substring(0, 9)
                    : _longitude,
              ),
              NbTextWidget(
                labelText: StringSet.NB_LATITUDE,
                backgroundColor: Color.fromRGBO(229, 229, 234, 1.0),
                value: _latitude.length > 9
                    ? _latitude.substring(0, 8)
                    : _latitude,
              ),
              NbTextWidget(
                labelText: StringSet.NB_ICCID,
                backgroundColor: Color.fromRGBO(229, 229, 234, 1.0),
                value: icccid,
              ),
              SizedBox(
                height: 20,
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),

              Container(
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

                    NeumorphicSwitch(
                      value: _switchUsed,
                      style: NeumorphicSwitchStyle(
                        activeTrackColor: ThemeDataSet.tabColor,
                      ),
                      onChanged: (value) {
                        _switchUsed = value;
                        setState(() {});
                      },
                    ),
//                    CupertinoSwitch(
//                      value: _switchUsed,
//                      onChanged: (bool value) {
//                        _switchUsed = value;
//                        setState(() {});
//                      },
//                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),

              Container(
//                    color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 1.0),
                padding: EdgeInsets.fromLTRB(16, 6, 10, 6),
                child: Row(
                  children: <Widget>[
                    Text(
                      StringSet.NB_ALARM,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    NeumorphicSwitch(
                      value: _switchAlarm,
                      style: NeumorphicSwitchStyle(
                        activeTrackColor: ThemeDataSet.tabColor,
                      ),
                      onChanged: (value) {
                        _switchAlarm = value;
                        if (!_switchAlarm) {
                          _recycle = Config.ZERO;
                          _recycleController.value =
                              TextEditingValue(text: StringSet.ZERO);
                        }
                        setState(() {});
                      },
                    ),
//                    CupertinoSwitch(
//                      value: _switchAlarm,
//                      onChanged: (bool value) {
//                        _switchAlarm = value;
//                        setState(() {});
//                      },
//                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),

              Container(
//                    color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 6, 10, 6),
                child: Row(
                  children: <Widget>[
                    Text(
                      StringSet.NB_REPLY,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    NeumorphicSwitch(
                      value: _switchReply,
                      style: NeumorphicSwitchStyle(
                        activeTrackColor: ThemeDataSet.tabColor,
                      ),
                      onChanged: (value) {
                        _switchReply = value;
                        setState(() {});
                      },
                    ),
//                    CupertinoSwitch(
//                      value: _switchReply,
//                      onChanged: (bool value) {
//                        _switchReply = value;
//                        setState(() {});
//                      },
//                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              _switchAlarm
                  ? NbTextFieldWidget(
                      labelText: StringSet.NB_CYCLE,
                      required: false,
                      keyboardType: TextInputType.number,
                      controller: _recycleController,
                    )
                  : NbTextWidget(
                      labelText: StringSet.NB_CYCLE,
                      backgroundColor: Color.fromRGBO(229, 229, 234, 1.0),
                      value: _recycle.toString(),
                    ),

              SizedBox(
                height: 10,
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              CustomPickerCell(
                title: StringSet.NB_VERSION,
                isNecessary: true,
                content: _versionOptions.length > 0
                    ? _versionOptions[_version].title
                    : StringSet.EMPTY,
                options: _versionOptions,
                isMultiple: false,
                okButtonCanDisabled: true,
                onConfirm: (options) {
                  _version = options.indexWhere((option) => option.isChecked);
                  for (int index = 0; index < _versionOptions.length; index++) {
                    _versionOptions[index].isChecked = (_version == index);
                  }

                  setState(() {});
                },
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              CustomPickerCell(
                title: StringSet.NB_PROVIDER,
                isNecessary: true,
                content: _provider,
                options: _providerOptions,
                isMultiple: false,
                okButtonCanDisabled: true,
                onConfirm: (options) {
                  int position =
                      options.indexWhere((option) => option.isChecked);
                  for (int index = 0;
                      index < _providerOptions.length;
                      index++) {
                    _providerOptions[index].isChecked = (position == index);
                    if (_providerOptions[index].isChecked) {
                      _provider = _providerOptions[index].title;
                      _providerId = _providerOptions[index].id;
                    }
                  }

                  setState(() {});
                },
              ),
              Divider(
                height: 1,
                color: Colors.grey,
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
                        isReverse: false,
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
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 1),
                              padding: EdgeInsets.fromLTRB(16, 2, 10, 2),
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

                                  NeumorphicSwitch(
                                    value: _nbLight[index].isChecked,
                                    style: NeumorphicSwitchStyle(
                                      activeTrackColor: ThemeDataSet.tabColor,
                                    ),
                                    onChanged: (value) {
                                      _nbLight[index].isChecked = value;
                                      setState(() {});
                                    },
                                  ),

//                                  CupertinoSwitch(
//                                    value: _nbLight[index].isChecked,
//                                    onChanged: (bool value) {
//                                      _nbLight[index].isChecked = value;
//                                      setState(() {});
//                                    },
//                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 1, bottom: 1),
                              padding: EdgeInsets.fromLTRB(16, 2, 10, 2),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    StringSet.NB_REVERSE + '${index + 1}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  NeumorphicSwitch(
                                    value: _nbLight[index].isReverse,
                                    style: NeumorphicSwitchStyle(
                                      activeTrackColor: ThemeDataSet.tabColor,
                                    ),
                                    onChanged: (value) {
                                      _nbLight[index].isReverse = value;
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
              Divider(
                height: 1,
                color: Colors.grey,
              ),

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

  void showCustomDialog(String title) {
    showDialog(
        context: _context,
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
