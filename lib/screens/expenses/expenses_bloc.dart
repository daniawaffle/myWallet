import 'dart:async';
import 'package:expenses_app/constants.dart';
import 'package:expenses_app/models/transactions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../locater.dart';
import '../../models/categories.dart';
import '../../models/theme_mode_option_model.dart';
import '../../services/hive_service.dart';

class ExpensesBloc {
  // final transactionsBox = Hive.box<Transactions>(TRANSACTIONS_HIVE);

  List<Transactions> myExpenses = [];

  StreamController<List<Categories>> categoriesStreamController =
      StreamController<List<Categories>>();
  Stream<List<Categories>> get categoriesStream =>
      categoriesStreamController.stream;

  StreamController<String> colorStreamController = StreamController<String>();
  Stream<String> get colorsStream => colorStreamController.stream;

  double calculateIncomeOutcome(TransactionType type) {
    double totalMoney = 0;

    // final transactionsBox = Hive.box<Transactions>('wallet_data');
    // final List<Transactions> myExpenses = transactionsBox.values.toList();
    final List<Transactions> myExpenses = locator<HiveService>()
        .transactionBox
        .values
        .map((dynamic item) => item as Transactions)
        .toList();
    for (var expense in myExpenses) {
      if (expense.type == type) {
        totalMoney += expense.price;
      }
    }

    return totalMoney;
  }

  String selectedCategory = 'All';
  String appColorTheme = "#000000";

  List<Categories> categoryList = [];

  refreshColorStream() async {
    // final settingsLocator = SettingsLocater();
    // await settingsLocator.init();
    // appColorTheme = settingsLocator.readSetting('appColorTheme') ?? "#000000";

    appColorTheme = await locator<HiveService>().getBoxValueByKey(
            boxName: settingsHive, key: hiveKeyAppColorTheme) ??
        "#000000";

    colorStreamController.sink.add(appColorTheme);
  }

  fillCategoryList() async {
    var categoriesBox = await Hive.openBox<Categories>("CategoriesHive");
    categoryList = categoriesBox.values.toList();
    categoriesStreamController.sink.add(categoryList);
  }

  void notifyUpdate() {
    colorStreamController.sink.add("");
  }
  // List<Categories> categoryList = [
  //   Categories(
  //     category: 'All',
  //     categoryIcon: Icons.view_module,
  //   ),
  //   Categories(
  //     category: 'Food',
  //     categoryIcon: Icons.fastfood,
  //   ),
  //   Categories(
  //     category: 'Transportation',
  //     categoryIcon: Icons.emoji_transportation,
  //   ),
  //   Categories(
  //     category: 'Family',
  //     categoryIcon: Icons.people,
  //   ),
  //   Categories(
  //     category: 'Personal Care',
  //     categoryIcon: Icons.self_improvement,
  //   ),
  //   Categories(
  //     category: 'Bills',
  //     categoryIcon: Icons.local_atm,
  //   ),
  //   Categories(
  //     category: 'Medical',
  //     categoryIcon: Icons.medical_services,
  //   ),
  //   Categories(
  //     category: 'Loans',
  //     categoryIcon: Icons.real_estate_agent,
  //   ),
  // ];

  List<Transactions> filteredList = [];

  List<ThemeModeOptionModel> themeModeOptionList = [
    ThemeModeOptionModel(colorName: "Black", colorValue: "#000000"),
    ThemeModeOptionModel(colorName: "Red", colorValue: "#FF0000"),
    ThemeModeOptionModel(colorName: "Blue", colorValue: "#0000FF"),
    ThemeModeOptionModel(colorName: "Green", colorValue: "#008000"),
  ];

  fillFilterdList() {
    filteredList = [];
    myExpenses = locator<HiveService>()
        .transactionBox
        .values
        .map((dynamic item) => item as Transactions)
        .toList();

    if (selectedCategory == "All") {
      filteredList = myExpenses;
    } else {
      filteredList = myExpenses
          .where((element) => element.category.contains(selectedCategory))
          .toList();
    }
  }
}
