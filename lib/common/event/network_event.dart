import 'package:event_bus/event_bus.dart';

class NetworkEvent {
  static const String ON_UPDATED = 'network/onUpdated';
  static final EventBus eventBus = EventBus();
}
