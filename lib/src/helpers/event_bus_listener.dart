import '../event_bus.dart';

class EventBusListener<T extends Object> {
  final bool emitLast;
  const EventBusListener({this.emitLast = false});
  Stream<T> onEvent() => EventBus.instance.onEvent<T>(emitLast: emitLast);
}
