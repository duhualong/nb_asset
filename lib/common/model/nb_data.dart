class NbData {
  int status;
  int autoAlarm;
  int ctrlState;
  String longitude;
  String latitude;
  int reportReply;
  int lampCount;
  String detail;
  List<LampStatus> lampStatus;

  NbData(
      {this.status,
      this.autoAlarm,
      this.ctrlState,
      this.longitude,
      this.latitude,
      this.reportReply,
      this.lampCount,
      this.detail,
      this.lampStatus});

  factory NbData.fromJson(Map<String, dynamic> nbData) {
    final originList = nbData['run_param']['lamp_status'] as List;
    List<LampStatus> lampStatusList =
        originList.map((value) => LampStatus.fromJson(value)).toList();
    return NbData(
        status: nbData['status'],
        autoAlarm: nbData['run_param']['auto_alarm'],
        detail: nbData["detail"]?.toString(),
        ctrlState: nbData['run_param']['ctrl_state'],
        longitude: nbData['run_param']['longitude'].toString(),
        latitude: nbData['run_param']['latitude'].toString(),
        reportReply: nbData['run_param']['report_reply'],
        lampCount: nbData['run_param']['lamp_count'],
        lampStatus: lampStatusList);
  }
}

class LampStatus {
  int autoLight;
  int lampVector;
  int powerRate;

  LampStatus({this.autoLight, this.lampVector, this.powerRate});

  factory LampStatus.fromJson(Map<String, dynamic> lampData) {
    return LampStatus(
        autoLight: lampData['auto_light'],
        lampVector: lampData['lamp_vector'],
        powerRate: lampData['power_rate']);
  }
}
