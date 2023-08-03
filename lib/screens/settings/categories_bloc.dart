import 'dart:async';

import 'package:hive/hive.dart';

import '../../models/categories.dart';

class CategoriesBloc {
  final categoriesBox = Hive.box<Categories>('CategoriesHive');
  StreamController<List<Categories>> categoriesStreamController =
      StreamController<List<Categories>>();

  Stream<List<Categories>> get categoriessStream =>
      categoriesStreamController.stream;

  List<Categories> myCategories = [];
  get getCategries {
    final transactionsBox = Hive.box<Categories>('CategoriesHive');
    myCategories = transactionsBox.values.toList();

    return myCategories;
  }

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
    categoriesStreamController.sink.add(filteredList);
  }
}
