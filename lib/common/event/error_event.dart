import 'package:event_bus/event_bus.dart';

class ErrorEvent {
  ErrorEvent(this.message);

  final String message;

  static final EventBus eventBus = EventBus();

  static errorMessageToast(String message, {bool toast = true}) {
    if (toast) {
      eventBus.fire(ErrorEvent(message));
    }
    return message;
  }
}
