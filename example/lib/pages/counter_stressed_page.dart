import 'dart:async';

import 'package:eventbus/eventbus.dart';
import 'package:example/dependencies.dart';
import 'package:example/states/counter_stressed_state.dart';
import 'package:flutter/material.dart';

import '../reactions/counter_reactions_stressed.dart';

class Benchmark {
  DateTime? _lastCall;
  Duration called() {
    final lastCall = _lastCall;
    final currentCall = DateTime.now();
    _lastCall = currentCall;
    if (lastCall == null) return Duration.zero;
    return currentCall.difference(lastCall);
  }
}

class CounterStressedPage extends StatelessWidget {
  CounterStressedPage({super.key});
  final bench1seg = Benchmark();
  final bench500milli = Benchmark();
  final bench100milli = Benchmark();
  final bench10milli = Benchmark();

  final timers = <Timer>[];

  @override
  Widget build(BuildContext context) {
    return ReactionsWidget(
      reactionsList: [Dependencies.get<CounterReactionsStressed>()],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Counter Stressed'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              EventBusBuilder<CounterState1Seg>(
                emitLast: true,
                builder: (context, state) {
                  final taps = state?.tapsCount ?? 0;
                  return Text('1 second: $taps - ${bench1seg.called()}');
                },
              ),
              EventBusBuilder<CounterState500Milli>(
                emitLast: true,
                builder: (context, state) {
                  final taps = state?.tapsCount ?? 0;
                  return Text('500 milli: $taps - ${bench500milli.called()}');
                },
              ),
              EventBusBuilder<CounterState100Milli>(
                emitLast: true,
                builder: (context, state) {
                  final taps = state?.tapsCount ?? 0;
                  return Text('100 milli: $taps - ${bench100milli.called()}');
                },
              ),
              EventBusBuilder<CounterState10Milli>(
                emitLast: true,
                builder: (context, state) {
                  final taps = state?.tapsCount ?? 0;
                  return Text('10 milli: $taps - ${bench10milli.called()}');
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              tooltip: 'Cancel',
              heroTag: 'cancel-button',
              child: const Icon(Icons.cancel),
              onPressed: () => timers.forEach((timer) => timer.cancel()),
            ),
            const SizedBox(width: 30),
            FloatingActionButton(
              tooltip: 'Start',
              heroTag: 'start-button',
              child: const Icon(Icons.start),
              onPressed: () {
                timers.add(Timer.periodic(const Duration(seconds: 1), (timer) {
                  if (timer.isActive) {
                    EventBus.instance.emit(CounterIncrement1Seg());
                  }
                }));
                timers.add(
                    Timer.periodic(const Duration(milliseconds: 500), (timer) {
                  if (timer.isActive)
                    EventBus.instance.emit(CounterIncrement500Milli());
                }));
                timers.add(
                    Timer.periodic(const Duration(milliseconds: 100), (timer) {
                  if (timer.isActive)
                    EventBus.instance.emit(CounterIncrement100Milli());
                }));
                timers.add(
                    Timer.periodic(const Duration(milliseconds: 10), (timer) {
                  if (timer.isActive)
                    EventBus.instance.emit(CounterIncrement10Milli());
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
