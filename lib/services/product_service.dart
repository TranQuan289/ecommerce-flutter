import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

// Example of adding a new product
  Future<void> createProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').add({
        'name': product.name,
        'category': product.category,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'favoriteUserIds': [], // Initialize with an empty list
      });
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toJson());
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductModel(
          id: doc.id,
          name: data['name'],
          category: data['category'],
          description: data['description'],
          price: data['price'],
          imageUrl: data['imageUrl'],
          favoriteUserIds: List<String>.from(
              data['favoriteUserIds'] ?? []), // Use empty list if not found
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Toggle favorite for a specific user
  Future<void> toggleFavorite(String productId, String userId) async {
    try {
      DocumentReference productRef =
          _firestore.collection('products').doc(productId);
      DocumentSnapshot productSnapshot = await productRef.get();

      if (productSnapshot.exists) {
        List<String> favoriteUserIds =
            List<String>.from(productSnapshot['favoriteUserIds'] ?? []);

        // Toggle the user's favorite status
        if (favoriteUserIds.contains(userId)) {
          favoriteUserIds.remove(userId); // Remove from favorites
        } else {
          favoriteUserIds.add(userId); // Add to favorites
        }

        // Update the product document in Firestore
        await productRef.update({'favoriteUserIds': favoriteUserIds});
      }
    } catch (e) {
      throw Exception('Error toggling favorite: $e');
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      Reference storageRef = _storage.ref().child('product_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
  Future<ProductModel?> fetchProductDetails(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductModel(
          id: doc.id,
          name: data['name'],
          category: data['category'],
          description: data['description'],
          price: data['price'],
          imageUrl: data['imageUrl'],
          favoriteUserIds: List<String>.from(data['favoriteUserIds'] ?? []),
        );
      }
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
    return null; // Return null if the product does not exist
  }
}
