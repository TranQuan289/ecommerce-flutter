import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final String status;
  final DateTime createdAt;
  final double totalAmount;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List).map((item) => CartItemModel.fromJson(item)).toList(),
      status: json['status'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'totalAmount': totalAmount,
    };
  }
}