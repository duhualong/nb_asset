import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nbassetentry/common/config/config.dart';
import 'package:nbassetentry/common/event/error_event.dart';
import 'package:nbassetentry/common/global/global.dart';
import 'package:nbassetentry/common/http/http.dart';
import 'package:nbassetentry/common/http/http_address.dart';
import 'package:nbassetentry/common/local/local_storage.dart';
import 'package:nbassetentry/common/model/nb_param_entity.dart';
import 'package:nbassetentry/common/model/scan.dart';
import 'package:nbassetentry/common/style/string_set.dart';
import 'package:nbassetentry/generated/json/base/json_convert_content.dart';

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

  static Future<DaoResult> loginOut() async {
    HttpResult result =
        await HttpManager.fetch(await HttpAddress.loginOut(), {});

    if (result == null || !result.isSuccess) {
      return DaoResult(result?.data ?? StringSet.EMPTY, false);
    }
    return DaoResult(true, true);
  }

  static Future<DaoResult> scan({String data}) async {
    FormData formData = FormData.fromMap({
      "data": data,
    });
    HttpResult result =
        await HttpManager.fetch(await HttpAddress.scan(), formData);

    if (result == null || !result.isSuccess) {
      return DaoResult(result?.data ?? StringSet.EMPTY, false);
    }
    Map<String, dynamic> map =
        json.decode(result.data as String ?? StringSet.EMPTY);
    ScanResult scanResult = ScanResult.fromJson(map);
    bool success = scanResult.status == 1;
    String detail = scanResult.detail ?? StringSet.UNKNOWN_ERROR;

    NbParamEntity nbParamEntity = NbParamEntity().fromJson(map);
    if (!success) {
      return DaoResult(
          ErrorEvent.errorMessageToast(detail + StringSet.PERIOD), false);
    }
    return DaoResult(nbParamEntity, true);
  }

  static Future<DaoResult> updateAssetInfo({
    String assetId,
    String assetName,
    String devicePlace,
    String lightPoleCode,
    int groupId,
    int carrierId,
    String barCode,
    String imei,
    String imsi,
    double lat,
    double lng,
    int ctrlState,
    int autoAlarm,
    int lampCount,
    int autoLightOne,
    int reverseDimmingOne,
    int powerRateOne,
    int autoLightTwo,
    int reverseDimmingTwo,
    int powerRateTwo,
    int autoLightThree,
    int reverseDimmingThree,
    int powerRateThree,
    int autoLightFour,
    int reverseDimmingFour,
    int powerRateFour,
    int reportReply,
    List<String> paths,
    String iccid,
    int protocolVersion,
    int providerId,
    int reportCycle,
    String provider,
  }) async {
    FormData formData = FormData.fromMap({
      "asset_id": assetId,
      "asset_name":assetName,
      "device_place":devicePlace,
      "light_pole_code": lightPoleCode,
      "group_id": groupId,
      "carrier_id": carrierId,
      "barcode_id": barCode,
      "provider": provider,
      "iccid": iccid,
      "imei": imei,
      "imsi": imsi,
      "longitude": lng,
      "latitude": lat,
      "ctrl_state": ctrlState,
      "auto_alarm": autoAlarm,
      "lamp_count": lampCount,
      "auto_light_1": autoLightOne.toString(),
      "reverse_dimming_1":reverseDimmingOne.toString(),
      "lamp_vector_1": 1,
      "power_rate_1": powerRateOne,
      "auto_light_2": autoLightTwo.toString(),
      "reverse_dimming_2":reverseDimmingTwo.toString(),
      "lamp_vector_2": 2,
      "power_rate_2": powerRateTwo,
      "auto_light_3": autoLightThree.toString(),
      "reverse_dimming_3":reverseDimmingThree.toString(),
      "lamp_vector_3": 3,
      "power_rate_3": powerRateThree,
      "auto_light_4": autoLightFour.toString(),
      "reverse_dimming_4":reverseDimmingFour.toString(),
      "lamp_vector_4": 4,
      "power_rate_4": powerRateFour,
      "power_upper": 0,
      "power_lower": 0,
      "report_reply": reportReply,
      "report_cycle": reportCycle,
      "protocol_version":protocolVersion??0,
     // "provider_id":providerId??0,
      "provider_id":providerId.toString(),
      "image": paths.length == 0
          ? []
          : paths.map((path) {
              return MultipartFile.fromFileSync(
                path,
                filename: path,
              );
            }).toList(),
    });

    print('formData:${formData.fields.toString()}');
    HttpResult result =
        await HttpManager.fetch(await HttpAddress.updateNbAsset(), formData);
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
    return DaoResult(map['asset_id'] as String ?? StringSet.ZERO, true);
  }

  static Future<DaoResult> readNb({String assetId, String jpushId}) async {
    FormData formData = FormData.fromMap({
      'asset_id': assetId,
      'jpush_id': jpushId,
    });
    HttpResult result =
        await HttpManager.fetch(await HttpAddress.readNb(), formData);
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
    return DaoResult(true, true);
  }

  static Future<DaoResult> dimmingNb(
      {String assetId, String jpushId, List<int> lampId, int op}) async {
    FormData formData = FormData.fromMap({
      'asset_id': assetId,
      'lamp_id': lampId,
      'op': op,
      'jpush_id': jpushId,
    });
    print('data:${formData.toString()}');
    HttpResult result =
        await HttpManager.fetch(await HttpAddress.dimmingNb(), formData);
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
    return DaoResult(true, true);
  }

  static Future<DaoResult> resetNb({String assetId, String jpushId}) async {
    FormData formData = FormData.fromMap({
      'asset_id': assetId,
      'jpush_id': jpushId,
    });
    HttpResult result =
        await HttpManager.fetch(await HttpAddress.resetNb(), formData);
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
    return DaoResult(true, true);
  }

  static Future<DaoResult> sendNb({String assetId, String jpushId}) async {
    FormData formData = FormData.fromMap({
      'asset_id': assetId,
      'jpush_id': jpushId,
    });
    HttpResult result =
        await HttpManager.fetch(await HttpAddress.sendNb(), formData);
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
    return DaoResult(true, true);
  }
}
