
import 'package:flutter/material.dart';

import '../../eventbus.dart';

typedef EventBusBuilderCallback<T> = Widget Function(
  BuildContext context,
  T? event,
);

class EventBusBuilder<T extends Object> extends StatelessWidget {
  final bool emitLast;
  final EventBusBuilderCallback<T> builder;
  EventBusBuilder({
    Key? key,
    required this.builder,
    this.emitLast = false,
  }) : super(key: key);

  late final stream = EventBus.instance.onEvent<T>(emitLast: emitLast);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) => builder(context, snapshot.data),
    );
  }
}
