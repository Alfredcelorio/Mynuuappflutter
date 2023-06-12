class BuyProduct {
  final String id;
  final int quantity;
  final bool status;
  final String name;
  final dynamic price;

  BuyProduct({
    required this.id,
    required this.quantity,
    required this.status,
    required this.name,
    required this.price,
  });

  factory BuyProduct.fromMap(Map<String, dynamic> data) {
// var parsedPrice = (data["price"] != null && data["price"] != "")
// ? data["price"].runtimeType == int
// ? data["price"]
// : int.parse(data["price"])
// : 0;

    return BuyProduct(
      id: data["id"],
      quantity: data["quantity"],
      status: data["status"],
      name: data["name"],
      price: data["price"],
    );
  }
}
