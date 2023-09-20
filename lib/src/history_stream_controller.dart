import 'dart:async';

class HistoryStreamController<T> with Stream<T>, _HistoryStream<T> {
  final _eventController = StreamController<T>.broadcast();
  // final _streams = <Type, Stream>{};

  HistoryStreamController({List<T>? initialHistory}) {
    if (initialHistory != null) history = initialHistory;
  }

  @override
  void add(T event) {
    _eventController.add(event);
    super.add(event);
  }

  @override
  void close() {
    _eventController.close();
    history.clear();
  }

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _eventController.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  StreamSubscription<R> listenType<R extends T>(
    void Function(R event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    bool emitLast = false,
  }) {
    return whereType<R>(emitLast: emitLast).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Stream<R> whereType<R extends T>({bool emitLast = false}) {
    // final streamNotExists = !_streams.containsKey(R);
    // if (streamNotExists) _streams[R] = _filterByType<R>(emitLast);
    // return _streams[R]!.cast<R>().asBroadcastStream();
    return _filterByType<R>(emitLast);
  }

  Stream<R> _filterByType<R extends T>(bool emitLast) {
    return Stream.multi((controller) {
      if (emitLast && history.isNotEmpty) {
        final typeItems = history.whereType<R>();
        if (typeItems.isNotEmpty) controller.add(typeItems.last);
      }
      controller.addStream(where((event) => event is R).cast<R>());
    }, isBroadcast: true);
  }

  Stream<T> filter(
    bool Function(T event) validation, {
    bool emitLast = false,
  }) {
    return Stream.multi((controller) {
      if (emitLast && history.isNotEmpty) {
        final filteredItems = history.where(validation);
        if (filteredItems.isNotEmpty) controller.add(filteredItems.last);
      }
      controller.addStream(where(validation));
    }, isBroadcast: true);
  }

  R? lastTypeSync<R extends T>([bool Function(T)? validation]) {
    if (history.isEmpty) return null;

    final typeHistory = history.whereType<R>();
    if (typeHistory.isEmpty) return null;

    //"validation" returns true case null
    validation ??= (_) => true;

    return typeHistory //
        .cast<R?>()
        .lastWhere(
          (event) => event is R && validation!(event),
          orElse: () => null,
        );
  }

  Future<R> lastType<R extends T>() => whereType<R>(emitLast: true).first;
}

mixin class _HistoryStream<T> implements Sink<T> {
  List<T> _history = [];
  List<T> get history => _history;
  set history(List<T> value) {
    _history = value;
    _historyController.add(history);
  }

  final _historyController = StreamController<List<T>>.broadcast();

  Stream<List<R>> onHistoryUpdate<R extends T>({bool emitCurrent = true}) {
    return Stream.multi((controller) {
      if (emitCurrent) {
        final items = history.whereType<R>().toList();
        controller.add(items);
      }
      controller.addStream(
        _historyController.stream.map((event) => event.whereType<R>().toList()),
      );
    }, isBroadcast: true);
  }

  @override
  void add(T event) {
    history = [...history, event];
  }

  @override
  void close() {
    _historyController.close();
  }

  void removeFromHistoryByType<R extends T>() {
    final newHistory = history //
        .whereType<T>()
        .where((event) => event is! R);
    history = newHistory.toList();
  }

  void removeFromHistoryWhere<R extends T>(bool Function(R event) removeWhere) {
    final newHistory = history //
        .whereType<R>()
        .where((event) => !removeWhere(event));
    history = newHistory.toList();
  }
}
