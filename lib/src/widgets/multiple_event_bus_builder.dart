import 'package:async/async.dart' show StreamZip;
import 'package:flutter/material.dart';

import '../helpers/event_bus_listener.dart';

typedef MultipleEventBusBuilderCallback<T> = Widget Function(
  BuildContext context,
  T event,
);

class MultipleEventBusBuilder extends StatelessWidget {
  final List<EventBusListener> listenersList;
  final MultipleEventBusBuilderCallback<List> builder;
  MultipleEventBusBuilder({
    super.key,
    required this.listenersList,
    required this.builder,
  });

  late final stream =
      StreamZip(listenersList.map((listener) => listener.onEvent()));
  // Stream.multi((controller) {
  //   for (var listener in listenersList) {
  //     controller.addStream(listener.onEvent());
  //   }
  // });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
      stream: stream,
      builder: (context, snapshot) => builder(context, snapshot.data ?? []),
    );
  }
}
