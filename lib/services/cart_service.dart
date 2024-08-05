import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/cart_item_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add or update a product in the cart
  Future<void> addOrUpdateCartItem(String userId, CartItemModel cartItem) async {
    try {
      DocumentReference cartRef = _firestore.collection('carts').doc(userId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot cartSnapshot = await transaction.get(cartRef);
        
        if (!cartSnapshot.exists) {
          transaction.set(cartRef, {'items': {cartItem.productId: cartItem.toJson()}});
        } else {
          Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> items = Map<String, dynamic>.from(cartData['items'] ?? {});
          
          if (items.containsKey(cartItem.productId)) {
            CartItemModel existingItem = CartItemModel.fromJson(items[cartItem.productId]);
            existingItem.quantity += cartItem.quantity;
            items[cartItem.productId] = existingItem.toJson();
          } else {
            items[cartItem.productId] = cartItem.toJson();
          }
          
          transaction.update(cartRef, {'items': items});
        }
      });
    } catch (e) {
      throw Exception('Error adding/updating cart item: $e');
    }
  }

  // Fetch cart items for a specific user
  Future<List<CartItemModel>> fetchCartItems(String userId) async {
    try {
      DocumentSnapshot cartSnapshot = await _firestore.collection('carts').doc(userId).get();
      
      if (!cartSnapshot.exists) {
        return [];
      }
      
      Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> items = Map<String, dynamic>.from(cartData['items'] ?? {});
      
      return items.entries.map((entry) => CartItemModel.fromJson(entry.value)).toList();
    } catch (e) {
      throw Exception('Error fetching cart items: $e');
    }
  }

  // Remove an item from the cart
  Future<void> removeFromCart(String userId, String productId) async {
    try {
      DocumentReference cartRef = _firestore.collection('carts').doc(userId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot cartSnapshot = await transaction.get(cartRef);
        
        if (cartSnapshot.exists) {
          Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> items = Map<String, dynamic>.from(cartData['items'] ?? {});
          
          items.remove(productId);
          
          transaction.update(cartRef, {'items': items});
        }
      });
    } catch (e) {
      throw Exception('Error removing item from cart: $e');
    }
  }


  Future<void> updateCartItemQuantity(String userId, String productId, int newQuantity) async {
    try {
      DocumentReference cartRef = _firestore.collection('carts').doc(userId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot cartSnapshot = await transaction.get(cartRef);
        
        if (cartSnapshot.exists) {
          Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> items = Map<String, dynamic>.from(cartData['items'] ?? {});
          
          if (items.containsKey(productId)) {
            CartItemModel item = CartItemModel.fromJson(items[productId]);
            item.quantity = newQuantity;
            items[productId] = item.toJson();
            
            transaction.update(cartRef, {'items': items});
          }
        }
      });
    } catch (e) {
      throw Exception('Error updating cart item quantity: $e');
    }
  }

  // Clear the entire cart
  Future<void> clearCart(String userId) async {
    try {
      await _firestore.collection('carts').doc(userId).delete();
    } catch (e) {
      throw Exception('Error clearing cart: $e');
    }
  }
}