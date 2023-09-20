import 'package:eventbus/eventbus.dart';
import 'package:eventbus/helpers.dart';
import 'package:example/log.dart';
import 'package:example/services/scaffold_messenger_service.dart';
import 'package:example/states/internet_state.dart';
import 'package:example/states/product_state.dart';
import 'package:flutter/material.dart';

import '../services/navigator_service.dart';

class EditProductReactions extends Reactions {
  final ScaffoldMessengerService _scaffoldMessenger;
  final NavigatorService _navigatorService;
  EditProductReactions(this._scaffoldMessenger, this._navigatorService);
  @override
  void init() {
    if (eventbus.lastSync<ProductState>() == null) {
      eventbus.emit(const ProductState(description: '', name: '', price: 0));
    }
    onEvent<InternetState>(onInternetStateHandler);
    onEvent<PriceProductUpdate>(onPriceProductUpdateHandler);
    onEvent<NameProductUpdate>(onNameProductUpdateHandler);
    onEvent<DescriptionProductUpdate>(onDescriptionProductUpdateHandler);
  }

  void onInternetStateHandler(InternetState event) {
    if (event.isConnected) {
      Log('[$EditProductReactions] onInternetStateHandler').emit();
      _scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("You are disconnected, so you can't edit the product."),
      ));
    }
    _navigatorService.pop();
  }

  void onNameProductUpdateHandler(NameProductUpdate event) {
    Log('[$EditProductReactions] onNameProductUpdateHandler').emit();
    final lastProductState = eventbus.lastSync<ProductState>();
    if (lastProductState == null) return;
    EventBus.instance.emit(lastProductState.copyWith(name: event.name));
  }

  void onDescriptionProductUpdateHandler(DescriptionProductUpdate event) {
    Log('[$EditProductReactions] descriptionProductUpdate').emit();
    final lastProductState = eventbus.lastSync<ProductState>();
    if (lastProductState == null) return;
    EventBus.instance.emit(lastProductState.copyWith(description: event.description));
  }

  void onPriceProductUpdateHandler(PriceProductUpdate event) {
    Log('[$EditProductReactions] onPriceProductUpdateHandler').emit();
    final lastProductState = eventbus.lastSync<ProductState>();
    if (lastProductState == null) return;
    EventBus.instance.emit(lastProductState.copyWith(price: event.price));
  }
}
