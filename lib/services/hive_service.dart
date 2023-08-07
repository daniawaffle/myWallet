import 'package:expenses_app/models/categories.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../models/transactions.dart';

class HiveService {
  //  Already open box
  late Box transactionBox;
  late Box categoriesBox;

  Future<void> openBoxes() async {
    transactionBox = await Hive.openBox<Transactions>(transactionsHive);
    categoriesBox = await Hive.openBox<Categories>(categoriesHive);
  }

  Future<void> setValue<T>(
      {required String boxName, required String key, required T value}) async {
    switch (boxName) {
      case transactionsHive:
        await transactionBox.put(key, value);
        break;
      case categoriesHive:
        await categoriesBox.put(key, value);
        break;
    }
  }

  T? getValue<T>({required String boxName, required String key}) {
    switch (boxName) {
      case transactionsHive:
        return transactionBox.get(key);

      case categoriesHive:
        return categoriesBox.get(key);

      default:
        return null;
    }
  }

  Future<void> deleteValue(
      {required String boxName, required String key}) async {
    switch (boxName) {
      case transactionsHive:
        await transactionBox.delete(key);
        break;
      case categoriesHive:
        await categoriesBox.delete(key);
        break;
    }
  }

  Future<void> deleteValueByKey<T>({
    required String boxName,
    required String key,
  }) async {
    final box = await Hive.openBox<T>(boxName);
    await box.delete(key);
    await box.close();
  }

  Future<List<T>> getAllValues<T>({required String boxName}) async {
    final box = await Hive.openBox<T>(boxName);
    final List<T> allValues = box.values.toList();
    await box.close();

    return allValues;
  }

  Future<T?> getBoxValueByKey<T>(
      {required String boxName, required String key}) async {
    T value;
    final box = await Hive.openBox<T>(boxName);
    value = box.get(key) as T;
    await box.close();

    return value;
  }

  Future<void> setBoxValueByKey<T>({
    required String boxName,
    required String key,
    required T value,
  }) async {
    final box = await Hive.openBox<T>(boxName);
    await box.put(key, value);
    await box.close();
  }
}
