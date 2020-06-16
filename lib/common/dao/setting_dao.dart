import '../http/http_address.dart';
import '../model/network.dart';

import '../http/http.dart';
import 'dao_result.dart';
export 'dao_result.dart';

class SettingDao {
  static Future<DaoResult> connect(Network network) async {
    HttpResult result = await HttpManager.fetch(
      HttpAddress.connect(network.address),
      null,
      method: HttpMethod.GET,
    );
    if (result == null || !result.isSuccess) {
      return DaoResult(result.data, false);
    }
    return DaoResult(null, true);
  }
}
