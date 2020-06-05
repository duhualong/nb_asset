// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Network _$NetworkFromJson(Map<String, dynamic> json) {
  return Network(
    name: json['name'] as String,
    ip: json['ip'] as String,
    port: json['port'] as String,
    isChecked: json['isChecked'] as bool,
  );
}

Map<String, dynamic> _$NetworkToJson(Network instance) => <String, dynamic>{
      'name': instance.name,
      'ip': instance.ip,
      'port': instance.port,
      'isChecked': instance.isChecked,
    };
