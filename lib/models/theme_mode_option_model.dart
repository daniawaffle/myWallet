import 'package:hive/hive.dart';

class ThemeModeOptionModel extends HiveObject {
  final String colorName;

  final String colorValue;

  ThemeModeOptionModel({required this.colorName, required this.colorValue});
}
