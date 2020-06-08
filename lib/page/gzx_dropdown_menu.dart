import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';

class SortCondition {
  String name;
  bool isSelected;

  SortCondition({this.name, this.isSelected});
}

class GZXDropDownMenuTestPage extends StatefulWidget {
  static final String routeName = '/gzxss';

  @override
  _GZXDropDownMenuTestPageState createState() =>
      _GZXDropDownMenuTestPageState();
}

class _GZXDropDownMenuTestPageState extends State<GZXDropDownMenuTestPage> {
  List<String> _dropDownHeaderItemStrings = ['品牌', '距离近'];
  List<SortCondition> _brandSortConditions = [];
  List<SortCondition> _distanceSortConditions = [];
  SortCondition _selectBrandSortCondition;
  SortCondition _selectDistanceSortCondition;
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  String _dropdownMenuChange = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _brandSortConditions.add(SortCondition(name: '全部', isSelected: true));
    _brandSortConditions.add(SortCondition(name: '金逸影城', isSelected: false));
    _brandSortConditions
        .add(SortCondition(name: '中影国际城我比较长，你看我选择后是怎么显示的', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '星美国际城', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '博纳国际城', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '大地影院', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '嘉禾影城', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '太平洋影城', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城1', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城2', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城3', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城4', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城5', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城6', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城7', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城8', isSelected: false));
    _brandSortConditions.add(SortCondition(name: '万达影城9', isSelected: false));
    _selectBrandSortCondition = _brandSortConditions[0];

    _distanceSortConditions.add(SortCondition(name: '距离近', isSelected: true));
    _distanceSortConditions.add(SortCondition(name: '价格低', isSelected: false));
    _distanceSortConditions.add(SortCondition(name: '价格高', isSelected: false));

    _selectDistanceSortCondition = _distanceSortConditions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          child: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      backgroundColor: Colors.white,
      endDrawer: Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 4, top: 0),
        color: Colors.white,
//        child: Container(color: Colors.red,child: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: TextField(),
//        ),),
        child: ListView(
          children: <Widget>[TextField()],
        ),
      ),
      body: Stack(
        key: _stackKey,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 44,
                color: Theme.of(context).primaryColor,
                alignment: Alignment.center,
                child: Text(
                  '仿美团电影下拉筛选菜单$_dropdownMenuChange',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
//              SizedBox(height: 20,),
              // 下拉菜单头部
              GZXDropDownHeader(
                // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
                items: [
                  GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0]),
                  GZXDropDownHeaderItem(
                    _dropDownHeaderItemStrings[1],
                  ),
                ],
                // GZXDropDownHeader对应第一父级Stack的key
                stackKey: _stackKey,
                // controller用于控制menu的显示或隐藏
                controller: _dropdownMenuController,
                // 当点击头部项的事件，在这里可以进行页面跳转或openEndDrawer
                onItemTap: (index) {
//                  if (index == 3) {
//                    _dropdownMenuController.hide();
//                    _scaffoldKey.currentState.openEndDrawer();
//                  }
                },
                style: TextStyle(color: Color(0xFF666666), fontSize: 14),
//                // 下拉时文字样式
                dropDownStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
//                // 图标大小
//                iconSize: 20,
//                // 图标颜色
//                iconColor: Color(0xFFafada7),
//                // 下拉时图标颜色
//                iconDropDownColor: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: ListView.separated(
                    itemCount: 100,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 1.0),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: ListTile(
                          leading: Text('test$index'),
                        ),
                        onTap: () {},
                      );
                    }),
              ),
            ],
          ),
          // 下拉菜单
          GZXDropDownMenu(
            // controller用于控制menu的显示或隐藏
            controller: _dropdownMenuController,
            // 下拉菜单显示或隐藏动画时长
            animationMilliseconds: 100,
            // 下拉后遮罩颜色
//          maskColor: Theme.of(context).primaryColor.withOpacity(0.5),
//          maskColor: Colors.red.withOpacity(0.5),
            dropdownMenuChanging: (isShow, index) {
              setState(() {
                _dropdownMenuChange = '(正在${isShow ? '显示' : '隐藏'}$index)';
                print(_dropdownMenuChange);
              });
            },
            dropdownMenuChanged: (isShow, index) {
              setState(() {
                _dropdownMenuChange = '(已经${isShow ? '显示' : '隐藏'}$index)';
                print(_dropdownMenuChange);
              });
            },
            // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
            menus: [
              GZXDropdownMenuBuilder(
                  dropDownHeight: 48 * 8.0,
                  dropDownWidget:
                      _buildConditionListWidget(_brandSortConditions, (value) {
                    _selectBrandSortCondition = value;
                    _dropDownHeaderItemStrings[0] =
                        _selectBrandSortCondition.name == '全部'
                            ? '品牌'
                            : _selectBrandSortCondition.name;
                    _dropdownMenuController.hide();
                    setState(() {});
                  })),
              GZXDropdownMenuBuilder(
                  dropDownHeight: 48.0 * _distanceSortConditions.length,
                  dropDownWidget: _buildConditionListWidget(
                      _distanceSortConditions, (value) {
                    _selectDistanceSortCondition = value;
                    _dropDownHeaderItemStrings[1] =
                        _selectDistanceSortCondition.name;
                    _dropdownMenuController.hide();
                    setState(() {});
                  })),
            ],
          ),
        ],
      ),
    );
  }



  _buildConditionListWidget(
      items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      // item 的个数
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0),
      // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        SortCondition goodsSortCondition = items[index];
        return GestureDetector(
          onTap: () {
            for (var value in items) {
              value.isSelected = false;
            }
            goodsSortCondition.isSelected = true;

            itemOnTap(goodsSortCondition);
          },
          child: Container(
//            color: Colors.blue,
            height: 48,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    goodsSortCondition.name,
                    style: TextStyle(
                      color: goodsSortCondition.isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                ),
                goodsSortCondition.isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      )
                    : SizedBox(),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
