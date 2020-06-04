class HttpResult {
  dynamic data;
  bool isSuccess;
  int statusCode;

  HttpResult(
    this.data,
    this.isSuccess, {
    this.statusCode,
  });
}
