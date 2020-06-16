import '../global/global.dart';
import '../model/network.dart';
import '../style/string_set.dart';

class HttpAddress {
  static Future<String> baseUrl() async {
    Network network = await Global.network;
    return network is Network
        ? 'https://${network.address}/proxy/'
        : StringSet.EMPTY;
  }

  /// 网址验证
  static String connect(String address) => 'http://$address/';
}
