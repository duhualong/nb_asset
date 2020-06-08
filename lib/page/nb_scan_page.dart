import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:nbassetentry/common/style/string_set.dart';
import 'package:nbassetentry/common/style/style_set.dart';
import 'package:nbassetentry/common/util/screen_utils.dart';
import 'package:nbassetentry/page/base_page.dart';
import 'package:nbassetentry/widget/text_field_nb_input.dart';
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
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();
  SortCondition _selectDistanceSortCondition;

  List<DropdownMenuItem<String>> sortItems = [];
  String _selectedSort = '排序';

  @override
  void initState() {
    super.initState();
    initData();
  }

  List<SortCondition> _distanceSortConditions = [];

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
          print('_currentIndex:$_currentIndex');
          setState(() {});
        },
      ),
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
      body: Container(
        child: Column(
          children: <Widget>[
            NbTextFieldWidget(
              labelText: StringSet.NB_NAME,
              required: true,
            ),
            NbTextFieldWidget(
              labelText: StringSet.NB_GROUP,
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
              child: Container(
                alignment: Alignment.center,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _selectedSort,
                    items: sortItems,
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedSort = newValue;
                      });
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initData() {
    sortItems.add(DropdownMenuItem(value: '排序', child: Text('排序')));
    sortItems.add(DropdownMenuItem(value: '价格降序', child: Text('价格降序')));
    sortItems.add(DropdownMenuItem(value: '价格升序', child: Text('价格升序')));
  }
}
