import 'package:eventbus/helpers.dart' hide State;

import 'package:flutter/widgets.dart';

class ReactionsWidget extends StatefulWidget {
  final Widget child;
  final List<Reactions> reactionsList;
  const ReactionsWidget({
    super.key,
    required this.child,
    required this.reactionsList,
  });

  @override
  State<ReactionsWidget> createState() => _ReactionsWidgetState();
}

class _ReactionsWidgetState extends State<ReactionsWidget> {
  @override
  void initState() {
    super.initState();
    for (final reactions in widget.reactionsList) {
      reactions.init();
    }
  }

  @override
  void dispose() {
    for (final reactions in widget.reactionsList) {
      reactions.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ReactionsWidget oldWidget) {
    if (widget.child != oldWidget.child) setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
