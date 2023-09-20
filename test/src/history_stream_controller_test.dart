// ignore_for_file: camel_case_types

import 'package:eventbus/src/history_stream_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('listen new updates', () {
    final controller = HistoryStreamController<BaseEvent>();
    controller.add(Event2_SubEvent1());

    final stream = controller.whereType<Event2>(emitLast: false);
    expect(
      stream,
      emitsInOrder([isA<Event2_SubEvent2>()]),
    );

    controller.add(Event2_SubEvent2());
  });

  test('listen updates starting with the last one', () {
    final controller = HistoryStreamController<BaseEvent>();
    controller.add(Event2_SubEvent1());

    final stream = controller.whereType<Event2>(emitLast: true);
    expect(
      stream,
      emitsInOrder([
        isA<Event2_SubEvent1>(),
        isA<Event2_SubEvent2>(),
      ]),
    );

    controller.add(Event2_SubEvent2());
  });

  test('listen history list new updates', () {
    final controller = HistoryStreamController<BaseEvent>();
    controller.add(Event1_SubEvent1());
    controller.add(Event1_SubEvent2());
    controller.add(Event2_SubEvent1());
    controller.add(Event2_SubEvent1());

    final stream = controller.onHistoryUpdate<Event2>(emitCurrent: false);
    expect(
      stream,
      emitsInOrder([
        [
          isA<Event2_SubEvent1>(),
          isA<Event2_SubEvent1>(),
          isA<Event2_SubEvent2>()
        ],
      ]),
    );

    controller.add(Event2_SubEvent2());
  });

  test('listen history list with the current one', () {
    final controller = HistoryStreamController<BaseEvent>();
    controller.add(Event1_SubEvent1());
    controller.add(Event1_SubEvent2());
    controller.add(Event2_SubEvent1());
    controller.add(Event2_SubEvent1());

    final stream = controller.onHistoryUpdate<Event2>();
    expect(
      stream,
      emitsInOrder([
        [isA<Event2_SubEvent1>(), isA<Event2_SubEvent1>()],
        [
          isA<Event2_SubEvent1>(),
          isA<Event2_SubEvent1>(),
          isA<Event2_SubEvent2>()
        ],
      ]),
    );

    controller.add(Event2_SubEvent2());
  });

  test('remove from history list by type', () {
    final controller = HistoryStreamController<BaseEvent>();
    controller.add(Event1_SubEvent1());
    controller.add(Event1_SubEvent2());
    controller.add(Event2_SubEvent1());
    controller.add(Event2_SubEvent2());

    final stream = controller.onHistoryUpdate<Event2>();
    expect(
      stream,
      emitsInOrder([
        [isA<Event2_SubEvent1>(), isA<Event2_SubEvent2>()],
        [isA<Event2_SubEvent2>()],
      ]),
    );
    controller.removeFromHistoryByType<Event2_SubEvent1>();
  });

  test('remove from history list where', () {
    final controller = HistoryStreamController<BaseEvent>();
    controller.add(Event1_SubEvent1());
    controller.add(Event1_SubEvent2());
    controller.add(Event2_SubEvent1());
    controller.add(Event2_SubEvent1());

    final stream = controller.onHistoryUpdate<Event2>();
    expect(
      stream,
      emitsInOrder([
        [isA<Event2_SubEvent1>(), isA<Event2_SubEvent1>()],
        [isA<Event2_SubEvent1>()],
      ]),
    );
    controller.removeFromHistoryWhere<Event2_SubEvent1>(
      (event) => event == controller.history.last,
    );
  });

  test('get last event by type async (from history)', () async {
    final controller = HistoryStreamController<BaseEvent>();
    controller.add(Event1_SubEvent1());
    controller.add(Event1_SubEvent2());
    controller.add(Event2_SubEvent1());
    controller.add(Event2_SubEvent1());

    final last = controller.lastType<Event1>();
    expect(last, completion(isA<Event1_SubEvent2>()));
  });

  test('get last event by type async (from stream)', () async {
    final controller = HistoryStreamController<BaseEvent>();
    controller.add(Event2_SubEvent1());
    controller.add(Event2_SubEvent1());

    final last = controller.lastType<Event1>();
    controller.add(Event1_SubEvent1());
    expect(last, completion(isA<Event1_SubEvent1>()));
  });

  test('get last event by type sync', () {
    final controller = HistoryStreamController<BaseEvent>();
    controller.add(Event1_SubEvent1());
    controller.add(Event1_SubEvent2());
    controller.add(Event2_SubEvent1());
    controller.add(Event2_SubEvent1());

    final last = controller.lastTypeSync<Event1>();
    expect(last, isA<Event1_SubEvent2>());
  });
}

sealed class BaseEvent {}

sealed class Event1 implements BaseEvent {}

class Event1_SubEvent1 implements Event1 {}

class Event1_SubEvent2 implements Event1 {}

class Event2 implements BaseEvent {}

class Event2_SubEvent1 implements Event2 {
  final int? id;
  Event2_SubEvent1({this.id});
}

class Event2_SubEvent2 implements Event2 {}

class Event3 implements BaseEvent {}

class Event3_SubEvent1 implements Event3 {}

class Event3_SubEvent2 implements Event3 {}
