class CartItemModel {
  final String productId;
  int quantity;
  final double price;

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}