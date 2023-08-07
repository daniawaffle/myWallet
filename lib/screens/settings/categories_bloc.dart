import 'dart:async';

import 'package:expenses_app/locater.dart';
import 'package:expenses_app/services/hive_service.dart';

import '../../constants.dart';
import '../../models/categories.dart';

class CategoriesBloc {
  // final categoriesBox = Hive.box<Categories>('CategoriesHive');
  StreamController<List<Categories>> categoriesStreamController =
      StreamController<List<Categories>>();

  Stream<List<Categories>> get categoriessStream =>
      categoriesStreamController.stream;

  List<Categories> myCategories = [];
  get getCategries {
    // final transactionsBox = Hive.box<Categories>('CategoriesHive');
    // myCategories = transactionsBox.values.toList();
    myCategories = locator<HiveService>()
        .getAllValues<Categories>(boxName: categoriesHive) as List<Categories>;

    return myCategories;
  }

  String selectedCategory = 'All';
  List<Categories> filteredList = [];
  fillFilterdList() {
    filteredList = [];
    // myCategories = categoriesBox.values.toList();
    myCategories = locator<HiveService>()
        .categoriesBox
        .values
        .map((dynamic item) => item as Categories)
        .toList();
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
