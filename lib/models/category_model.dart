class CategoryModel {
  final String id;
  final String name;

  CategoryModel({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}