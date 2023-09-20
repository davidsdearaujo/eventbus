import 'package:eventbus/eventbus.dart';

class Log {
  final String message;
  const Log(this.message);

  @override
  String toString() => 'Message: $message';

  void emit() => EventBus.instance.emit(this);
}
