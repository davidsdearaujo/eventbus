import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

import '../../eventbus.dart';

abstract class Reactions {
  @protected
  EventBus get eventbus => EventBus.instance;
  final _subscriptions = <StreamSubscription>[];

  void onEvent<T extends Object>(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    bool emitLast = false,
  }) {
    _subscriptions.add(eventbus.listen<T>(
      (data) {
        // debugPrint('[$runtimeType] on"$T"');
        onData?.call(data);
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
      emitLast: emitLast,
    ));
  }

  void onEventList({
    required List<EventBusListener> listenersList,
    required void Function(List events)? onData,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final stream =
        StreamZip(listenersList.map((listener) => listener.onEvent()));
    _subscriptions.add(stream.listen(
      (data) => onData?.call(data),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    ));
  }

  void init();

  @mustCallSuper
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
  }
}
