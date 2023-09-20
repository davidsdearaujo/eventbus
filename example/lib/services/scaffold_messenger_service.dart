import 'package:flutter/material.dart';

class ScaffoldMessengerService {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
    SnackBar snackBar,
  ) {
    return scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
