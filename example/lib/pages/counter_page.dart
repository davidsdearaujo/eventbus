import 'package:eventbus/eventbus.dart';
import 'package:example/dependencies.dart';
import 'package:flutter/material.dart';

import '../reactions/counter_reactions.dart';
import '../states/counter_state.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  a() {
    EventBus.instance.emit(2);
  }

  @override
  Widget build(BuildContext context) {
    return ReactionsWidget(
      reactionsList: [Dependencies.get<CounterReactions>()],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Counter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              EventBusBuilder<CounterState>(
                emitLast: true,
                builder: (context, state) {
                  final taps = state?.tapsCount ?? 0;
                  return Text(
                    '$taps',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              tooltip: 'Decrement',
              heroTag: 'decrement-button',
              child: const Icon(Icons.remove),
              onPressed: () => EventBus.instance.emit(CounterDecrement()),
            ),
            const SizedBox(width: 30),
            FloatingActionButton(
              tooltip: 'Increment',
              heroTag: 'increment-button',
              child: const Icon(Icons.add),
              onPressed: () => EventBus.instance.emit(CounterIncrement()),
            ),
          ],
        ),
      ),
    );
  }
}
