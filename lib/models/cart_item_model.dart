class CartItemModel {
  final String id; // Unique identifier for the cart item
  final String productId; // The ID of the product being ordered
  int quantity; // How many of this product
  final String userId; // The user who added the item
  final String status; // Status of the order: waiting, delivering, etc.
  final double price; // Price of the product

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.userId,
    this.status = 'waiting', // Default status is waiting
    required this.price, // Price of the product
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'userId': userId,
      'status': status,
      'price': price, // Include price in the Firestore document
    };
  }
}
