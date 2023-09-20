import 'package:eventbus/helpers.dart';
import 'package:example/states/counter_state.dart';
import 'package:example/states/counter_stressed_state.dart';

class CounterReactionsStressed extends Reactions {
  @override
  void init() {
    {
      final lastState = eventbus.lastSync<CounterState1Seg>();
      if (lastState == null) eventbus.emit(CounterState1Seg(0));
    }
    {
      final lastState = eventbus.lastSync<CounterState500Milli>();
      if (lastState == null) eventbus.emit(CounterState500Milli(0));
    }
    {
      final lastState = eventbus.lastSync<CounterState100Milli>();
      if (lastState == null) eventbus.emit(CounterState100Milli(0));
    }
    {
      final lastState = eventbus.lastSync<CounterState10Milli>();
      if (lastState == null) eventbus.emit(CounterState10Milli(0));
    }
    onEvent<CounterIncrement1Seg>((event) {
      final lastState = eventbus.lastSync<CounterState1Seg>();
      if (lastState == null) return;
      eventbus.emit(CounterState1Seg(lastState.tapsCount + 1));
    });
    onEvent<CounterIncrement500Milli>((event) {
      final lastState = eventbus.lastSync<CounterState500Milli>();
      if (lastState == null) return;
      eventbus.emit(CounterState500Milli(lastState.tapsCount + 1));
    });
    onEvent<CounterIncrement100Milli>((event) {
      final lastState = eventbus.lastSync<CounterState100Milli>();
      if (lastState == null) return;
      eventbus.emit(CounterState100Milli(lastState.tapsCount + 1));
    });
    onEvent<CounterIncrement10Milli>((event) {
      final lastState = eventbus.lastSync<CounterState10Milli>();
      if (lastState == null) return;
      eventbus.emit(CounterState10Milli(lastState.tapsCount + 1));
    });
  }
}
