import 'package:eventbus/helpers.dart';
import 'package:example/states/counter_state.dart';

class CounterReactions extends Reactions {
  @override
  void init() {
    final lastState = eventbus.lastSync<CounterState>();
    if (lastState == null) eventbus.emit(CounterState(0));
    onEvent<CounterIncrement>((event) {
      // Log('[$CounterReactions] on$CounterIncrement').emit();
      final lastState = eventbus.lastSync<CounterState>();
      if (lastState == null) return;
      eventbus.emit(CounterState(lastState.tapsCount + 1));
    });

    onEvent<CounterDecrement>((event) {
      // Log('[$CounterReactions] on${event.runtimeType}').emit();
      final lastState = eventbus.lastSync<CounterState>();
      if (lastState == null) return;
      eventbus.emit(CounterState(lastState.tapsCount - 1));
    });
  }
}
