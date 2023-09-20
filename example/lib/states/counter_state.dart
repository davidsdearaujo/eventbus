import 'package:eventbus/helpers.dart';

class CounterState extends State {
  final int tapsCount;
  CounterState(this.tapsCount);

  @override
  String toString() => 'tapsCount: $tapsCount';
}

class CounterIncrement extends Action {
  @override
  String toString() => '';
}

class CounterDecrement extends Action {
  @override
  String toString() => '';
}
