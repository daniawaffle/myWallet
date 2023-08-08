class CategoriesFirebase {
  final String category;
  final int categoryIconCode;

  CategoriesFirebase({
    required this.category,
    required this.categoryIconCode,
  });

  factory CategoriesFirebase.fromJson(Map<String, dynamic> json) {
    return CategoriesFirebase(
      category: json['category'] as String,
      categoryIconCode: json['categoryIconCode'] as int,
    );
  }
}
