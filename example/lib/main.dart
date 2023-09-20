import 'package:eventbus/eventbus.dart';
import 'package:example/pages/events_page.dart';
import 'package:example/pages/product_page.dart';
import 'package:flutter/material.dart';

import 'dependencies.dart';
import 'pages/counter_page.dart';
import 'pages/counter_stressed_page.dart';
import 'reactions/internet_connection_reactions.dart';
import 'services/navigator_service.dart';
import 'services/scaffold_messenger_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final scaffoldMessengerService = Dependencies.get<ScaffoldMessengerService>();

  final navigatorService = Dependencies.get<NavigatorService>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ReactionsWidget(
      reactionsList: [Dependencies.get<InternetConnectionReactions>()],
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerService.scaffoldMessengerKey,
        navigatorKey: navigatorService.navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Stress'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CounterStressedPage(),
                ));
              },
            ),
            ElevatedButton(
              child: const Text('Counter'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CounterPage(),
                ));
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              child: const Text('Product Page'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProductPage(),
                ));
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              child: const Text('Events History'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EventsPage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
