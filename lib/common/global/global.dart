import 'package:flutter/widgets.dart';
import 'package:nbassetentry/common/model/user.dart';
import '../local/network_storage.dart';
import '../model/network.dart';

class Global {
  static User _user;
  static GlobalKey<NavigatorState> navigatorState = new GlobalKey();
  static Future<Network> get network async {
    return await NetworkStorage.getCheckedNetwork();
  }

  static User get user {
    if (_user != null) {
      return _user;
    }
    _user = User();
    return _user;
  }
  static void resetUser(){
    _user.userName = null;
    _user.uuid = null;
  }
}
