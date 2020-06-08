import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../common/dao/dao_result.dart';
import '../common/http/http.dart';

class BasePage extends StatefulWidget {
  /// 标题
  final String title;

  /// 抽屉，drawer != null 时 leadingIconData 和 leadingOnTap 无效
  final Widget drawer;

  /// 是否包含导航栏
  final bool hasAppBar;

  /// 导航栏左侧图标
  final IconData leadingIconData;

  /// 导航栏左侧按钮回调
  final GestureTapCallback leadingOnTap;

  /// 导航栏右侧图标数组
  final List<Widget> actions;

  /// 主页面
  final Widget body;

  /// 自动适应底部间距
  final bool resizeToAvoidBottomInset;
  final Color color;
  final BottomNavigationBar bottomNavigationBar;


  BasePage({
    Key key,
    this.title,
    this.leadingIconData,
    this.leadingOnTap,
    this.drawer,
    this.hasAppBar = true,
    this.body,
    this.actions,
    this.color= Colors.white,
    this.resizeToAvoidBottomInset = true,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {

  @override
  void initState() {
    super.initState();
    HttpLoading.context = context;
    DaoResult.context = context;
  }

  @override
  Widget build(BuildContext context) {
    HttpLoading.context = context;
    DaoResult.context = context;
    if (widget.actions != null && (widget.actions.last is! SizedBox)) {
      widget.actions.add(SizedBox(width: 19));
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      backgroundColor: Colors.white,
      drawer: widget.drawer,
      bottomNavigationBar:  widget.bottomNavigationBar,
      appBar: widget.hasAppBar
          ? AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:widget.color,
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: false,
        leading: null,
        title: Container(
          height: 50,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: widget.drawer != null
                        ? () => Scaffold.of(context).openDrawer()
                        : widget.leadingOnTap,
                    child: Container(
//                      color: Colors.white,
                      height: double.infinity,
                      alignment: Alignment.centerLeft,
                      width: 50,
                      child: Icon(
                        widget.drawer != null
                            ? Icons.menu
                            : widget.leadingIconData,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              widget.title != null
                  ? MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaleFactor: 1),
                child: Expanded(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              )
                  : Container()
            ],
          ),
        ),
        actions: widget.actions,
      )
          : null,
      body: Builder(builder: (context) {
        return SafeArea(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: widget.body,
          ),
        );
      }),
    );
  }
}
