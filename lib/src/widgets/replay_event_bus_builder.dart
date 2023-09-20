import 'package:flutter/material.dart';

import '../../eventbus.dart';

typedef ReplayEventBusBuilderCallback<T> = Widget Function(
  BuildContext context,
  List<T>? event,
);

class ReplayEventBusBuilder<T extends Object> extends StatelessWidget {
  final bool emitLast;
  final ReplayEventBusBuilderCallback<T> builder;
  final bool Function(T)? where;
  ReplayEventBusBuilder({
    Key? key,
    required this.builder,
    this.emitLast = false,
    this.where,
  }) : super(key: key);

  late final stream = EventBus.instance.onReplay<T>(
    emitLast: emitLast,
    where: where,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (context, snapshot) => builder(context, snapshot.data),
    );
  }
}
