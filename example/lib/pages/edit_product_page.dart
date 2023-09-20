import 'package:eventbus/eventbus.dart';
import 'package:example/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../reactions/edit_product_reactions.dart';
import '../states/internet_state.dart';
import '../states/product_state.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactionsWidget(
      reactionsList: [Dependencies.get<EditProductReactions>()],
      child: MultipleEventBusBuilder(
        listenersList: const [
          EventBusListener<InternetState>(emitLast: true),
          EventBusListener<ProductState>(emitLast: true),
        ],
        builder: (context, statesList) {
          if (statesList.isEmpty) return Container();
          final [
            InternetState internetState,
            ProductState productState,
          ] = statesList;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Product'),
              actions: [
                const Text('Is Connected:'),
                CupertinoSwitch(
                  value: internetState.isConnected,
                  onChanged: (_) =>
                      EventBus.instance.emit(ToggleInternetConnectionStatus()),
                ),
              ],
            ),
            body: Column(children: [
              TextFormField(
                decoration: const InputDecoration(label: Text('Name')),
                initialValue: productState.name,
                onChanged: (value) {
                  EventBus.instance.emit(NameProductUpdate(value));
                },
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Description')),
                initialValue: productState.description,
                onChanged: (value) {
                  EventBus.instance.emit(DescriptionProductUpdate(value));
                },
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Price')),
                initialValue: productState.price.toString(),
                onChanged: (value) {
                  EventBus.instance
                      .emit(PriceProductUpdate(double.tryParse(value) ?? 0));
                },
              ),
            ]),
          );
        },
      ),
    );
  }
}
