import 'package:eventbus/helpers.dart';
import 'package:example/log.dart';
import 'package:flutter/material.dart';

import '../services/scaffold_messenger_service.dart';
import '../states/internet_state.dart';
import '../states/product_state.dart';

class ProductOnSaleReactions extends Reactions {
  final ScaffoldMessengerService _scaffoldMessengerService;
  ProductOnSaleReactions(this._scaffoldMessengerService);

  @override
  void init() {
    onEventList(
      listenersList: [
        const EventBusListener<InternetState>(),
        const EventBusListener<ProductState>(),
      ],
      onData: onConnectionAndPriceChange,
    );
  }

  void onConnectionAndPriceChange(List data) {
    Log('[$ProductOnSaleReactions] onConnectionAndPriceChange').emit();
    print(data);
    var [InternetState internetState, ProductState productState] = data;

    if (!internetState.isConnected && productState.price > 100) {
      _scaffoldMessengerService.showSnackBar(const SnackBar(
        duration: Duration(seconds: 6),
        content: Text(
          "Maybe this product is in sale. Enable your internet connection to see the updated price",
        ),
      ));
    }
  }
}
