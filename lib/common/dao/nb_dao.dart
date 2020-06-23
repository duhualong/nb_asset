import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:nbassetentry/common/config/config.dart';
import 'package:nbassetentry/common/event/error_event.dart';
import 'package:nbassetentry/common/global/global.dart';
import 'package:nbassetentry/common/http/http.dart';
import 'package:nbassetentry/common/http/http_address.dart';
import 'package:nbassetentry/common/local/local_storage.dart';
import 'package:nbassetentry/common/model/scan.dart';
import 'package:nbassetentry/common/style/string_set.dart';

import 'dao_result.dart';

class NbDao {
  static Future<DaoResult> userLogin({String userName, String pwd}) async {
    FormData formData = FormData.fromMap({
      "user_name": userName,
      "passwd": EncryptUtil.encodeMd5(pwd),
    });
    HttpResult result =
        await HttpManager.fetch(await HttpAddress.userLogin(), formData);

    if (result == null || !result.isSuccess) {
      return DaoResult(result?.data ?? StringSet.EMPTY, false);
    }
    Map<String, dynamic> map =
        json.decode(result.data as String ?? StringSet.EMPTY);
    bool success = map['status'] as int == 1;
    String detail = map['detail'] as String ?? StringSet.UNKNOWN_ERROR;
    if (!success) {
      return DaoResult(
          ErrorEvent.errorMessageToast(detail + StringSet.PERIOD), false);
    }
    Global.user.userName = userName;
    Global.user.uuid = map['uuid'] as String;
    await LocalStorage.set(Config.USER_NAME_KEY, userName);
    await LocalStorage.set(Config.USER_PWD, pwd);
    return DaoResult(true, true);
  }
  static Future<DaoResult> loginOut()async{
    HttpResult result =
    await HttpManager.fetch(await HttpAddress.loginOut(),{});

    if (result == null || !result.isSuccess) {
      return DaoResult(result?.data ?? StringSet.EMPTY, false);
    }
    return DaoResult(true, true);
  }
  static Future<DaoResult>scan({String data})async{
    FormData formData = FormData.fromMap({
      "data": data,
    });
    HttpResult result =
    await HttpManager.fetch(await HttpAddress.scan(),formData);
    if (result == null || !result.isSuccess) {
      return DaoResult(result?.data ?? StringSet.EMPTY, false);
    }
    Map<String, dynamic> map =
    json.decode(result.data as String ?? StringSet.EMPTY);
    ScanResult scanResult=ScanResult.fromJson(map);
    bool success = scanResult.status == 1;
    String detail =scanResult.detail ?? StringSet.UNKNOWN_ERROR;
    if (!success) {
      return DaoResult(
          ErrorEvent.errorMessageToast(detail + StringSet.PERIOD), false);
    }
    return DaoResult(scanResult, true);
  }
}
