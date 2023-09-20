import 'package:flutter/material.dart';

class NavigatorService {
  final navigatorKey = GlobalKey<NavigatorState>();

  void pop<T>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }
}
