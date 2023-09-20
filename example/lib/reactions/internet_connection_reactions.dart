import 'package:eventbus/helpers.dart';
import 'package:example/log.dart';

import '../states/internet_state.dart';

class InternetConnectionReactions extends Reactions {
  @override
  void init() {
    eventbus.emit(const InternetState(
      internetConnectionType: InternetConnectionType.wifi,
      isConnected: true,
    ));
    onEvent<ToggleInternetConnectionStatus>(
      (event) => toggleInternetConnectionStatus(),
    );
  }

  void toggleInternetConnectionStatus() {
    Log('[$InternetConnectionReactions] onConnectionChange').emit();
    final internetState = eventbus.lastSync<InternetState>();
    if (internetState == null) return;
    eventbus.emit(internetState.copyWith(
      isConnected: !internetState.isConnected,
    ));
  }
}
