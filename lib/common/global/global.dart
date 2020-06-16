import 'package:flutter/widgets.dart';
import '../local/network_storage.dart';
import '../model/network.dart';

class Global {
  static GlobalKey<NavigatorState> navigatorState = new GlobalKey();

  static Future<Network> get network async {
    return await NetworkStorage.getCheckedNetwork();
  }
}
