import '../global/global.dart';
import '../model/network.dart';
import '../style/string_set.dart';

class HttpAddress {
  static Future<String> baseUrl() async {
    Network network = await Global.network;
    return network is Network
        ? 'https://${network.address}/nbctrlinstallation/v1/'
        : StringSet.EMPTY;
  }

  /// 网址验证
  static String connect(String address) => 'https://$address/';
  ///用户登录
static Future<String> userLogin()async=>
    '${await baseUrl()}login';
///退出登录
static Future<String> loginOut()async=>'${await baseUrl()}logout';
}
