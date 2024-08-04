import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/cart_item_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a product to the cart
  Future<void> addToCart(CartItemModel cartItem) async {
    try {
      await _firestore.collection('cart').add(cartItem.toJson());
    } catch (e) {
      throw Exception('Error adding to cart: $e');
    }
  }

  // Fetch all cart items for a specific user
  Future<List<CartItemModel>> fetchCartItems(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('cart')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CartItemModel(
          id: doc.id,
          productId: data['productId'],
          quantity: data['quantity'],
          userId: data['userId'],
          status: data['status'],
          price: data['price'], // Fetch price from the document
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching cart items: $e');
    }
  }

  // Remove an item from the cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _firestore.collection('cart').doc(cartItemId).delete();
    } catch (e) {
      throw Exception('Error removing item from cart: $e');
    }
  }

  // Add items to waiting cart (or orders)
  Future<void> addToWaitingCart(CartItemModel cartItem) async {
    try {
      // Create a new entry in the orders or waiting cart collection
      await _firestore.collection('waiting_cart').add(cartItem.toJson());
    } catch (e) {
      throw Exception('Error adding to waiting cart: $e');
    }
  }
}
