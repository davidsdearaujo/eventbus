import 'package:eventbus/helpers.dart';

class ProductState extends State {
  final String name;
  final String description;
  final double price;
  const ProductState({
    required this.name,
    required this.description,
    required this.price,
  });

  ProductState copyWith({
    String? name,
    String? description,
    double? price,
  }) {
    return ProductState(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  @override
  String toString() => 'name: $name\ndescription: $description\nprice: $price';
}

// Actions
class DescriptionProductUpdate extends Action {
  final String description;
  DescriptionProductUpdate(this.description);

  @override
  String toString() => 'description: $description';
}

class NameProductUpdate extends Action {
  final String name;
  NameProductUpdate(this.name);

  @override
  String toString() => 'name: $name';
}

class PriceProductUpdate extends Action {
  final double price;
  PriceProductUpdate(this.price);
  
  @override
  String toString() => 'price: $price';
}
