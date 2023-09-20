import 'package:eventbus/eventbus.dart';
import 'package:example/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../reactions/product_on_sale_reaction.dart';
import '../states/internet_state.dart';
import '../states/product_state.dart';
import 'edit_product_page.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactionsWidget(
      reactionsList: [Dependencies.get<ProductOnSaleReactions>()],
      child: EventBusBuilder<InternetState>(
        emitLast: true,
        builder: (context, internetState) {
          final hasInternet = internetState?.isConnected ?? false;
          return EventBusBuilder<ProductState>(
            emitLast: true,
            builder: (context, productState) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Product Page'),
                  actions: [
                    const Text('Is Connected:'),
                    CupertinoSwitch(
                      value: hasInternet,
                      onChanged: (_) => EventBus.instance.emit(ToggleInternetConnectionStatus()),
                      activeColor: Colors.green,
                      trackColor: Colors.red,
                    ),
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Name: ${productState?.name ?? 'not defined'}'),
                    Text(
                        'Description: ${productState?.description ?? 'not defined'}'),
                    Text('Price: ${productState?.price ?? 'not defined'}'),
                  ],
                ),
                floatingActionButton: hasInternet
                    ? FloatingActionButton(
                        disabledElevation: 0,
                        tooltip: "Edit product",
                        child: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => const EditProductPage(),
                          ));
                        },
                      )
                    : FloatingActionButton(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[400],
                        disabledElevation: 0,
                        onPressed: null,
                        tooltip:
                            "No internet connection for editing the product",
                        child: const Icon(Icons.edit),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
