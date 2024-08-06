class CartItemModel {
  final String productId;
  int quantity;
  final double price;
  final String productName; 
  final String imageUrl; 

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName, 
    required this.imageUrl,   
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'productName': productName, 
      'imageUrl': imageUrl,       
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
      productName: json['productName'], 
      imageUrl: json['imageUrl'],      
    );
  }
}
