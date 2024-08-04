import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new category
  Future<void> createCategory(CategoryModel category) async {
    try {
      await _firestore.collection('categories').add(category.toJson());
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  // Fetch all categories
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('categories').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CategoryModel(
          id: doc.id,
          name: data['name'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Update an existing category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toJson());
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
      fetchCategories();
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }
}
