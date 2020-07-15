import 'package:nbassetentry/generated/json/base/json_convert_content.dart';
import 'package:nbassetentry/generated/json/base/json_filed.dart';

class NbParamEntity with JsonConvert<NbParamEntity> {
	@JSONField(name: "device_param")
	NbParamDeviceParam deviceParam;
	@JSONField(name: "candidate_items")
	NbParamCandidateItems candidateItems;
	int status;
	String detail;
}

class NbParamDeviceParam with JsonConvert<NbParamDeviceParam> {
	@JSONField(name: "asset_id")
	String assetId;
	@JSONField(name: "phy_id")
	int phyId;
	@JSONField(name: "light_pole_code")
	String lightPoleCode;
	@JSONField(name: "group_id")
	int groupId;
	@JSONField(name: "group_name")
	String groupName;
	@JSONField(name: "carrier_id")
	int carrierId;
	@JSONField(name: "carrier_name")
	String carrierName;
	@JSONField(name: "barcode_id")
	String barcodeId;
	@JSONField(name: "provider_id")
	int providerId;
	String provider;
	@JSONField(name: "protocol_version")
	int protocolVersion;
	String iccid;
	String imei;
	String imsi;
	double longitude;
	double latitude;
	@JSONField(name: "date_create")
	int dateCreate;
	@JSONField(name: "ctrl_state")
	int ctrlState;
	@JSONField(name: "auto_alarm")
	int autoAlarm;
	@JSONField(name: "lamp_count")
	int lampCount;
	@JSONField(name: "lamp_status")
	List<NbParamDeviceParamLampStatu> lampStatus;
	@JSONField(name: "power_upper")
	int powerUpper;
	@JSONField(name: "power_lower")
	int powerLower;
	@JSONField(name: "report_reply")
	int reportReply;
	@JSONField(name: "report_cycle")
	int reportCycle;
	@JSONField(name: "image_count")
	int imageCount;
	@JSONField(name: "carrier_registered")
	int carrierRegistered;
}

class NbParamDeviceParamLampStatu with JsonConvert<NbParamDeviceParamLampStatu> {
	@JSONField(name: "auto_light")
	int autoLight;
	@JSONField(name: "lamp_vector")
	int lampVector;
	@JSONField(name: "power_rate")
	int powerRate;
}

class NbParamCandidateItems with JsonConvert<NbParamCandidateItems> {
	@JSONField(name: "group_list")
	List<NbParamCandidateItemsGroupList> groupList;
	@JSONField(name: "carrier_list")
	List<NbParamCandidateItemsCarrierList> carrierList;
	@JSONField(name: "provider_list")
	List<NbParamCandidateItemsProviderList> providerList;
}

class NbParamCandidateItemsGroupList with JsonConvert<NbParamCandidateItemsGroupList> {
	@JSONField(name: "group_id")
	int groupId;
	@JSONField(name: "group_name")
	String groupName;
}

class NbParamCandidateItemsCarrierList with JsonConvert<NbParamCandidateItemsCarrierList> {
	@JSONField(name: "carrier_id")
	int carrierId;
	@JSONField(name: "carrier_name")
	String carrierName;
}

class NbParamCandidateItemsProviderList with JsonConvert<NbParamCandidateItemsProviderList> {
	@JSONField(name: "provider_id")
	int providerId;
	String provider;
}
