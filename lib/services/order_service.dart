import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo đơn hàng mới
  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add(order.toJson());
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  // Lấy tất cả đơn hàng của một người dùng
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    });
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }

  // Xóa đơn hàng
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw Exception('Error deleting order: $e');
    }
  }
}