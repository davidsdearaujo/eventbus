import 'package:auto_injector/auto_injector.dart';
import 'package:flutter/foundation.dart';

// import 'reducers/product_on_sale_reducer.dart';
import 'reactions/counter_reactions.dart';
import 'reactions/counter_reactions_stressed.dart';
import 'reactions/edit_product_reactions.dart';
import 'reactions/internet_connection_reactions.dart';
import 'reactions/product_on_sale_reaction.dart';
import 'services/navigator_service.dart';
import 'services/scaffold_messenger_service.dart';

class Dependencies {
  static T get<T>() {
    debugPrint('[$Dependencies] GET $T');
    return _injector.get<T>();
  }
  static T? dispose<T>() => _injector.disposeSingleton<T>();

  static final _injector = AutoInjector(on: (i) {
    //Reactions
    i.add(CounterReactionsStressed.new);
    i.add(CounterReactions.new);
    i.add(EditProductReactions.new);
    i.add(InternetConnectionReactions.new);
    i.add(ProductOnSaleReactions.new);

    //Services
    i.addLazySingleton(ScaffoldMessengerService.new);
    i.addLazySingleton(NavigatorService.new);

    i.commit();
  });
}

// extension AutoInjectorExtension on AutoInjector {
//   // void addReducer(Function constructor) {
//   //   addSingleton<dynamic>(constructor, onDispose: (value) => value.dispose());
//   // }

//   void addReactions(Function constructor) {
//     addLazySingleton<dynamic>(constructor,
//         onDispose: (value) => value.dispose());
//   }
// }
