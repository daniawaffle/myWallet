import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'categories.g.dart';

@HiveType(typeId: 4)
class Categories extends HiveObject {
  @HiveField(0)
  String category;
  @HiveField(1)
  IconData? categoryIcon;
  @HiveField(2)
  String? uniqueId;

  Categories({
    required this.category,
    this.categoryIcon,
    this.uniqueId,
  }) {
    uniqueId ??= const Uuid().v4();
  }
}
