import 'package:eventbus/helpers.dart';

class InternetState extends State {
  final bool isConnected;
  final InternetConnectionType internetConnectionType;
  const InternetState({
    required this.isConnected,
    required this.internetConnectionType,
  });

  InternetState copyWith({
    bool? isConnected,
    InternetConnectionType? internetConnectionType,
  }) {
    return InternetState(
      isConnected: isConnected ?? this.isConnected,
      internetConnectionType:
          internetConnectionType ?? this.internetConnectionType,
    );
  }

  @override
  String toString() => 'isConnected: $isConnected\ninternetConnectionType: $internetConnectionType';
}

enum InternetConnectionType { wifi, remote3g, remote4g, remote5g }

// Actions
class ToggleInternetConnectionStatus extends Action {}

class ChangeInternetConnectionType extends Action {
  final InternetConnectionType connectionType;
  const ChangeInternetConnectionType(this.connectionType);
}
