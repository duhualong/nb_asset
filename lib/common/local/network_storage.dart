import 'dart:convert' show json;
import 'local_storage.dart';
import '../config/config.dart';
import '../event/network_event.dart';
import '../model/network.dart';

class NetworkStorage {
  static Future<List<Network>> getNetworks() async {
    String networksJson = await LocalStorage.get(Config.NETWORKS_KEY) ??
        json.encode([Network.defaultNetwork()]);
    List<dynamic> networkList = json.decode(networksJson);
    List<Map<String, dynamic>> maps =
        networkList.map((value) => value as Map<String, dynamic>).toList();
    List<Network> networks = maps.map((map) => Network.fromJson(map)).toList();
    return networks;
  }

  static Future<Network> getCheckedNetwork() async {
    List<Network> networks = await getNetworks();
    if (networks.any((network) => network.isChecked)) {
      return networks.firstWhere((network) => network.isChecked);
    }
    return null;
  }

  static Future<void> updateNetworks(List<Network> networks) async {
    await LocalStorage.set(Config.NETWORKS_KEY, json.encode(networks));
    NetworkEvent.eventBus.fire(NetworkEvent.ON_UPDATED);
  }

  static void removeAllNetworks() {
    updateNetworks([]);
  }
}
