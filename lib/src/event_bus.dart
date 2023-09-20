import 'dart:async';

import '../eventbus.dart';

class EventBus {
  EventBus._();
  static final instance = EventBus._();

  final _eventController = HistoryStreamController<Event>();
  late final Stream any = _eventController.map((event) => event.data);

  void dispose() {
    _eventController.close();
  }

  /// Emit new event with [data]
  void emit<T extends Object>(T data) {
    _eventController.add(Event<T>(data));
  }

  Stream<T> onEvent<T extends Object>({bool emitLast = false}) =>
      _eventController
          .whereType<Event<T>>(emitLast: emitLast)
          .map((event) => event.data);

  Stream onEventWhere(bool Function(Event<dynamic> event) validation) {
    return _eventController //
        .filter(validation)
        .map((event) => event.data);
  }

  T? lastSync<T extends Object>([bool Function(T)? validation]) {
    return _eventController
        .lastTypeSync<Event<T>>((e) => validation?.call(e.data) ?? true)
        ?.data;
  }

  T? lastWhereSync<T extends Object>(bool Function(T) validation) {
    if (_eventController.history.isEmpty) return null;

    final typeHistory = _eventController.history.whereType<T>();
    if (typeHistory.isEmpty) return null;

    return typeHistory //
        .cast<T?>()
        .lastWhere((event) => event is T && validation(event),
            orElse: () => null);
  }

  Future<T> last<T extends Object>() {
    return _eventController.lastType<Event<T>>().then((event) => event.data);
  }

  StreamSubscription<Event<T>> listen<T extends Object>(
    void Function(T event) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    bool emitLast = false,
  }) {
    return _eventController.listenType<Event<T>>(
      (event) => onData(event.data),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
      emitLast: emitLast,
    );
  }

  Stream<List> onHistoryUpdate({bool emitCurrent = true}) =>
      _eventController.onHistoryUpdate(emitCurrent: emitCurrent);

  Stream<List<T>> onReplay<T>(
      {bool emitLast = false, bool Function(T)? where}) {
    return Stream.multi((controller) {
      final startIndex = emitLast ? 0 : _eventController.history.length;
      final stream = _eventController //
          .whereType<Event<T>>()
          .where((e) => where?.call(e.data) ?? true)
          .map((event) {
        final history = _eventController.history //
            .sublist(startIndex)
            .whereType<Event<T>>()
            .where((e) => where?.call(e.data) ?? true)
            .map((e) => e.data);
        return [...history, event.data];
      });
      controller.addStream(stream);
    }, isBroadcast: true);
  }
}
