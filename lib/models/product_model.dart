class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> favoriteUserIds; // List of user IDs who favorited this product

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.favoriteUserIds = const [], // Default to an empty list
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'favoriteUserIds': favoriteUserIds, // Store the list in Firestore
    };
  }
}