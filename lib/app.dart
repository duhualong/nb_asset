import 'package:flutter/material.dart';
import 'common/global/global.dart';
import 'common/redux/redux.dart';
import 'common/redux/redux_state.dart';
import 'common/style/style_set.dart';
import 'page/home_page.dart';
import 'page/image_gallery_page.dart';
import 'page/login_page.dart';
import 'page/nb_scan_page.dart';
import 'page/network_edit_page.dart';
import 'page/network_setting_page.dart';
import 'page/splash_page.dart';
import 'widget/error_handle.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final store = Store<ReduxState>(
    appReducer,
    initialState: ReduxState(
      themeData: ThemeDataSet.themeData,
    ),
  );

  void _setupThemeData() async {
    ThemeData themeData = ThemeDataSet.themeData;
    store.dispatch(RefreshThemeDataAction(themeData));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _setupThemeData();
  }

  @override
  Widget build(BuildContext context) {

    return StoreProvider(
      store: store,
      child: StoreBuilder<ReduxState>(
        builder: (context, store) {
          return MaterialApp(
            navigatorKey: Global.navigatorState,
            debugShowCheckedModeBanner: false,
            theme:ThemeData(
              backgroundColor: Colors.white,
              primaryColor:  ThemeDataSet.tabColor,
              scaffoldBackgroundColor: Colors.white,
            ),
            routes: {
              SplashPage.routeName: (context) =>
                  ErrorHandle(child: SplashPage()),
              LoginPage.routeName: (context) => ErrorHandle(child: LoginPage()),
              HomePage.routeName: (context) => ErrorHandle(child: HomePage()),
              NbScanPage.routeName: (context) => ErrorHandle(
                    child: NbScanPage(),
                  ),

              ImageGalleryPage.routeName: (context) => ImageGalleryPage(),
              NetworkSettingPage.routeName: (context) =>
                  ErrorHandle(child: NetworkSettingPage()),
              NetworkEditPage.routeName: (context) =>
                  ErrorHandle(child: NetworkEditPage()),
            },
          );
        },
      ),
    );
  }
}
