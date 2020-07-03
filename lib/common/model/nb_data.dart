

class NbData{
  int status;
  int autoAlarm;
  int ctrlState;
  String longitude;
  String latitude;
  int reportReply;
  int lampCount;
  String detail;
  List<LampStatus> lampStatus;
  NbData({this.status,this.autoAlarm,this.ctrlState,this.longitude,this.latitude,
  this.reportReply,this.lampCount,this.detail,this.lampStatus});
  factory NbData.fromJson(Map<String, dynamic> nbData) {
    final originList = nbData['lamp_status'] as List;
    List<LampStatus> lampStatusList =
    originList.map((value) => LampStatus.fromJson(value)).toList();
    return NbData(
        status: nbData['status'], autoAlarm: nbData['auto_alarm'],
        detail : nbData["detail"]?.toString(),
        ctrlState: nbData['ctrl_state'],longitude:nbData['longitude'].toString(),
        latitude: nbData['latitude'].toString(),reportReply: nbData['report_reply'],
        lampCount: nbData['lamp_count'],lampStatus: lampStatusList);
  }


}

class LampStatus{
  int autoLight;
  int lampVector;
  int powerRate;
  LampStatus({this.autoLight,this.lampVector,this.powerRate});
  factory LampStatus.fromJson(Map<String, dynamic> lampData) {
    return LampStatus(autoLight: lampData['auto_light'],
        lampVector: lampData['lamp_vector'],powerRate: lampData['power_rate']);
  }
}