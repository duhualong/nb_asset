import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:core';
import 'dart:io';
import 'http.dart';
import '../config/config.dart';
import '../event/error_event.dart';
import '../global/global.dart';
import '../style/string_set.dart';

class HttpManager {
  static Dio _dio;
  static const String CONTENT_TYPE_JSON = 'application/json';
  static const String CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static const String CONTENT_TYPE_FORM_DATA = 'multipart/form-data';

  static Dio _getDio() {
    if (_dio == null) {
      _dio = Dio();
      // 请求超时
      _dio.options.connectTimeout = Config.NETWORK_TIMEOUT * 1000;
      // Headers
      _dio.options.headers.addAll({'source': 'mobile'});
      // 禁止重定向，自己在 Error 回调中处理
      _dio.options.followRedirects = false;
      // CA 证书
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          return true;
        };
      };
      // 增加加载动画
      _dio.interceptors.add(InterceptorsWrapper(onRequest: (requestOptions) {
        if (requestOptions.uri.path == '/flow/getAsset') {
          return requestOptions;
        }
        HttpLoading.before(uri: requestOptions.uri);
        return requestOptions;
      }, onResponse: (response) {
        HttpLoading.complete(uri: response.request.uri);
        return response;
      }, onError: (error) {
        HttpLoading.complete(uri: error.request.uri);
        return error;
      }));
      return _dio;
    }
    return _dio;
  }

  static Future<HttpResult> fetch(
    String url,
    dynamic queryParameters, {
    String method = HttpMethod.POST,
    bool isUploadFile = false,
    bool isJson = true,
  }) async {
    queryParameters ??= Map<String, dynamic>();
    if (isUploadFile) {
      method = HttpMethod.POST;
    }
    // 无网络连接
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return HttpResult(
          ErrorEvent.errorMessageToast(
              StringSet.NETWORK_NOT_CONNECTED + StringSet.PERIOD),
          false);
    }
    Options options = Options(
      method: method,
      responseType: ResponseType.plain,
      connectTimeout: Config.NETWORK_TIMEOUT * 1000,
    );
//    if (!isUploadFile && (Global.user.uuid ?? StringSet.EMPTY).isNotEmpty) {
//      options.headers.addAll({'User-Token': Global.user.uuid});
//    }
    Response response = Response();
    try {
      response = isUploadFile || isJson
          ? await _getDio()
              .request(url, data: queryParameters, options: options)
          : await _getDio()
              .request(url, queryParameters: queryParameters, options: options);
    } on DioError catch (error) {
      // 重定向
      const redirectCodes = [302, 303, 307];
      if (redirectCodes.contains(error.response?.statusCode ?? 0)) {
        String location = error.response.headers.value('location') ?? '';
        if (location.isNotEmpty && location != url) {
          return fetch(location, queryParameters,
              method: method, isUploadFile: isUploadFile, isJson: isJson);
        }
      }
      if (Config.DEBUG) {
        print('请求异常：${error.toString()}');
        print('请求路径：$url');
        print('请求参数：${queryParameters.toString()}');
      }
      switch (error.type) {
        case DioErrorType.DEFAULT:
          return HttpResult(
              ErrorEvent.errorMessageToast(
                  StringSet.NETWORK_DEFAULT_ERROR + StringSet.PERIOD),
              false,
              statusCode: error.response?.statusCode ?? 0);
        case DioErrorType.CONNECT_TIMEOUT:
          return HttpResult(
              ErrorEvent.errorMessageToast(
                  StringSet.NETWORK_CONNECT_TIMEOUT + StringSet.PERIOD),
              false,
              statusCode: error.response?.statusCode ?? 0);
        case DioErrorType.CANCEL:
          return HttpResult(
              ErrorEvent.errorMessageToast(
                  StringSet.OPERATION_CANCELLED + StringSet.PERIOD),
              false,
              statusCode: error.response?.statusCode ?? 0);
        case DioErrorType.RECEIVE_TIMEOUT:
          return HttpResult(
              ErrorEvent.errorMessageToast(
                  StringSet.NETWORK_RECEIVE_TIMEOUT + StringSet.PERIOD),
              false,
              statusCode: error.response?.statusCode ?? 0);
        case DioErrorType.RESPONSE:
          return HttpResult(
              ErrorEvent.errorMessageToast(StringSet.NETWORK_STATUS_CODE_ERROR +
                  StringSet.COLON +
                  error.response?.statusCode.toString() +
                  StringSet.PERIOD),
              false,
              statusCode: error.response?.statusCode ?? 0);
        default:
          return HttpResult(
              ErrorEvent.errorMessageToast(
                  StringSet.UNKNOWN_ERROR + StringSet.PERIOD),
              false,
              statusCode: error.response?.statusCode ?? 0);
      }
    }

    if (Config.DEBUG) {
      print('请求成功');
      print('请求路径：$url');
      if (queryParameters != null) {
        print('请求参数：${queryParameters.toString()}');
      }
      if (response != null) {
        print('响应参数：${response.toString()}');
      }
    }
    print('HttpResult: ${response.data}');
    return HttpResult(response.data, true, statusCode: response.statusCode);
  }
}
