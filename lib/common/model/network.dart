import 'package:json_annotation/json_annotation.dart';
import '../style/string_set.dart';

part 'network.g.dart';

@JsonSerializable()
class Network {
  String name;
  String ip;
  String port;
  bool isChecked;

  String get address => '$ip:$port';

  Network({
    this.name,
    this.ip,
    this.port,
    this.isChecked,
  });

  Network.defaultNetwork() {
    this.name = StringSet.NETWORK_DEMO_NAME;
    this.ip = StringSet.NETWORK_DEMO_IP;
    this.port = StringSet.NETWORK_DEMO_PORT;
    this.isChecked = true;
  }

  Network.empty() {
    this.name = StringSet.EMPTY;
    this.ip = StringSet.EMPTY;
    this.port = StringSet.EMPTY;
    this.isChecked = false;
  }

  String get debugDescription =>
      'name: $name, address: $address, isChecked: $isChecked';

  factory Network.fromJson(Map<String, dynamic> json) =>
      _$NetworkFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkToJson(this);
}
