import 'package:project1/common/models/product.dart';

class SelectedItem {
  final String id;
  final String name;
  final String image;
  final String description;
  final String price;
  final int quantity;

  SelectedItem({
    required this.quantity,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required,
    required this.image,
  });

  factory SelectedItem.fromProduct(int quantity, Product product) {
    var price = product.price != null
        ? product.price is int
            ? product.price
            : product.price
        : '';

    if (price.toString().contains('.0')) {
      price = price.toString().replaceAll('.0', '');
    }

    return SelectedItem(
      id: product.id,
      name: product.name,
      image: product.image,
      description: product.description,
      price: price!,
      quantity: quantity,
    );
  }
}
