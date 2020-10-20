import 'package:nbassetentry/common/model/nb_param_entity.dart';

nbParamEntityFromJson(NbParamEntity data, Map<String, dynamic> json) {
	if (json['device_param'] != null) {
		data.deviceParam = new NbParamDeviceParam().fromJson(json['device_param']);
	}
	if (json['candidate_items'] != null) {
		data.candidateItems = new NbParamCandidateItems().fromJson(json['candidate_items']);
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['detail'] != null) {
		data.detail = json['detail']?.toString();
	}
	return data;
}

Map<String, dynamic> nbParamEntityToJson(NbParamEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.deviceParam != null) {
		data['device_param'] = entity.deviceParam.toJson();
	}
	if (entity.candidateItems != null) {
		data['candidate_items'] = entity.candidateItems.toJson();
	}
	data['status'] = entity.status;
	data['detail'] = entity.detail;
	return data;
}

nbParamDeviceParamFromJson(NbParamDeviceParam data, Map<String, dynamic> json) {
	if (json['asset_id'] != null) {
		data.assetId = json['asset_id']?.toString();
	}
	if (json['phy_id'] != null) {
		data.phyId = json['phy_id']?.toInt();
	}
	if (json['light_pole_code'] != null) {
		data.lightPoleCode = json['light_pole_code']?.toString();
	}
	if (json['group_id'] != null) {
		data.groupId = json['group_id']?.toInt();
	}
	if (json['group_name'] != null) {
		data.groupName = json['group_name']?.toString();
	}
	if (json['carrier_id'] != null) {
		data.carrierId = json['carrier_id']?.toInt();
	}
	if (json['carrier_name'] != null) {
		data.carrierName = json['carrier_name']?.toString();
	}
	if (json['barcode_id'] != null) {
		data.barcodeId = json['barcode_id']?.toString();
	}
	if (json['provider_id'] != null) {
		data.providerId = json['provider_id']?.toInt();
	}
	if (json['provider'] != null) {
		data.provider = json['provider']?.toString();
	}
	if (json['protocol_version'] != null) {
		data.protocolVersion = json['protocol_version']?.toInt();
	}
	if (json['iccid'] != null) {
		data.iccid = json['iccid']?.toString();
	}
	if (json['imei'] != null) {
		data.imei = json['imei']?.toString();
	}
	if (json['imsi'] != null) {
		data.imsi = json['imsi']?.toString();
	}
	if (json['longitude'] != null) {
		data.longitude = json['longitude']?.toDouble();
	}
	if (json['latitude'] != null) {
		data.latitude = json['latitude']?.toDouble();
	}
	if (json['date_create'] != null) {
		data.dateCreate = json['date_create']?.toInt();
	}
	if (json['ctrl_state'] != null) {
		data.ctrlState = json['ctrl_state']?.toInt();
	}
	if (json['auto_alarm'] != null) {
		data.autoAlarm = json['auto_alarm']?.toInt();
	}
	if (json['lamp_count'] != null) {
		data.lampCount = json['lamp_count']?.toInt();
	}
	if (json['lamp_status'] != null) {
		data.lampStatus = new List<NbParamDeviceParamLampStatu>();
		(json['lamp_status'] as List).forEach((v) {
			data.lampStatus.add(new NbParamDeviceParamLampStatu().fromJson(v));
		});
	}
	if (json['power_upper'] != null) {
		data.powerUpper = json['power_upper']?.toInt();
	}
	if (json['power_lower'] != null) {
		data.powerLower = json['power_lower']?.toInt();
	}
	if (json['report_reply'] != null) {
		data.reportReply = json['report_reply']?.toInt();
	}
	if (json['report_cycle'] != null) {
		data.reportCycle = json['report_cycle']?.toInt();
	}
	if (json['image_count'] != null) {
		data.imageCount = json['image_count']?.toInt();
	}
	if (json['carrier_registered'] != null) {
		data.carrierRegistered = json['carrier_registered']?.toInt();
	}
	return data;
}

Map<String, dynamic> nbParamDeviceParamToJson(NbParamDeviceParam entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['asset_id'] = entity.assetId;
	data['phy_id'] = entity.phyId;
	data['light_pole_code'] = entity.lightPoleCode;
	data['group_id'] = entity.groupId;
	data['group_name'] = entity.groupName;
	data['carrier_id'] = entity.carrierId;
	data['carrier_name'] = entity.carrierName;
	data['barcode_id'] = entity.barcodeId;
	data['provider_id'] = entity.providerId;
	data['provider'] = entity.provider;
	data['protocol_version'] = entity.protocolVersion;
	data['iccid'] = entity.iccid;
	data['imei'] = entity.imei;
	data['imsi'] = entity.imsi;
	data['longitude'] = entity.longitude;
	data['latitude'] = entity.latitude;
	data['date_create'] = entity.dateCreate;
	data['ctrl_state'] = entity.ctrlState;
	data['auto_alarm'] = entity.autoAlarm;
	data['lamp_count'] = entity.lampCount;
	if (entity.lampStatus != null) {
		data['lamp_status'] =  entity.lampStatus.map((v) => v.toJson()).toList();
	}
	data['power_upper'] = entity.powerUpper;
	data['power_lower'] = entity.powerLower;
	data['report_reply'] = entity.reportReply;
	data['report_cycle'] = entity.reportCycle;
	data['image_count'] = entity.imageCount;
	data['carrier_registered'] = entity.carrierRegistered;
	return data;
}

nbParamDeviceParamLampStatuFromJson(NbParamDeviceParamLampStatu data, Map<String, dynamic> json) {
	if (json['auto_light'] != null) {
		data.autoLight = json['auto_light']?.toInt();
	}
	if (json['lamp_vector'] != null) {
		data.lampVector = json['lamp_vector']?.toInt();
	}
	if (json['power_rate'] != null) {
		data.powerRate = json['power_rate']?.toInt();
	}
	return data;
}

Map<String, dynamic> nbParamDeviceParamLampStatuToJson(NbParamDeviceParamLampStatu entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['auto_light'] = entity.autoLight;
	data['lamp_vector'] = entity.lampVector;
	data['power_rate'] = entity.powerRate;
	return data;
}

nbParamCandidateItemsFromJson(NbParamCandidateItems data, Map<String, dynamic> json) {
	if (json['group_list'] != null) {
		data.groupList = new List<NbParamCandidateItemsGroupList>();
		(json['group_list'] as List).forEach((v) {
			data.groupList.add(new NbParamCandidateItemsGroupList().fromJson(v));
		});
	}
	if (json['carrier_list'] != null) {
		data.carrierList = new List<NbParamCandidateItemsCarrierList>();
		(json['carrier_list'] as List).forEach((v) {
			data.carrierList.add(new NbParamCandidateItemsCarrierList().fromJson(v));
		});
	}
	if (json['provider_list'] != null) {
		data.providerList = new List<NbParamCandidateItemsProviderList>();
		(json['provider_list'] as List).forEach((v) {
			data.providerList.add(new NbParamCandidateItemsProviderList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> nbParamCandidateItemsToJson(NbParamCandidateItems entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.groupList != null) {
		data['group_list'] =  entity.groupList.map((v) => v.toJson()).toList();
	}
	if (entity.carrierList != null) {
		data['carrier_list'] =  entity.carrierList.map((v) => v.toJson()).toList();
	}
	if (entity.providerList != null) {
		data['provider_list'] =  entity.providerList.map((v) => v.toJson()).toList();
	}
	return data;
}

nbParamCandidateItemsGroupListFromJson(NbParamCandidateItemsGroupList data, Map<String, dynamic> json) {
	if (json['group_id'] != null) {
		data.groupId = json['group_id']?.toInt();
	}
	if (json['group_name'] != null) {
		data.groupName = json['group_name']?.toString();
	}
	return data;
}

Map<String, dynamic> nbParamCandidateItemsGroupListToJson(NbParamCandidateItemsGroupList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['group_id'] = entity.groupId;
	data['group_name'] = entity.groupName;
	return data;
}

nbParamCandidateItemsCarrierListFromJson(NbParamCandidateItemsCarrierList data, Map<String, dynamic> json) {
	if (json['carrier_id'] != null) {
		data.carrierId = json['carrier_id']?.toInt();
	}
	if (json['carrier_name'] != null) {
		data.carrierName = json['carrier_name']?.toString();
	}
	return data;
}

Map<String, dynamic> nbParamCandidateItemsCarrierListToJson(NbParamCandidateItemsCarrierList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['carrier_id'] = entity.carrierId;
	data['carrier_name'] = entity.carrierName;
	return data;
}

nbParamCandidateItemsProviderListFromJson(NbParamCandidateItemsProviderList data, Map<String, dynamic> json) {
	if (json['provider_id'] != null) {
		data.providerId = json['provider_id']?.toInt();
	}
	if (json['provider'] != null) {
		data.provider = json['provider']?.toString();
	}
	return data;
}

Map<String, dynamic> nbParamCandidateItemsProviderListToJson(NbParamCandidateItemsProviderList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['provider_id'] = entity.providerId;
	data['provider'] = entity.provider;
	return data;
}