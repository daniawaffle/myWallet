import 'dart:async';

import 'package:hive/hive.dart';

import '../../models/categories.dart';

class CategoriesBloc {
  final categoriesBox = Hive.box<Categories>('CategoriesHive');
  StreamController<List<Categories>> _categoriesStreamController =
      StreamController<List<Categories>>();

  Stream<List<Categories>> get categoriessStream =>
      _categoriesStreamController.stream;

  List<Categories> myCategories = [];
  String selectedCategory = 'All';
  List<Categories> filteredList = [];
  fillFilterdList() {
    filteredList = [];
    myCategories = categoriesBox.values.toList();

    if (selectedCategory == "All") {
      filteredList = myCategories;
    } else {
      filteredList = myCategories
          .where((element) => element.category.contains(selectedCategory))
          .toList();
    }
    _categoriesStreamController.sink.add(filteredList);
  }
}
