import 'package:expenses_app/models/transactions.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../models/categories.dart';
import '../../models/theme_mode_option_model.dart';

class ExpensesBloc {
  final transactionsBox = Hive.box<Transactions>('wallet_data');

  List<Transactions> myExpenses = [];

  double calculateIncomeOutcome(TransactionType type) {
    double totalMoney = 0;

    final transactionsBox = Hive.box<Transactions>('wallet_data');
    final List<Transactions> myExpenses = transactionsBox.values.toList();

    for (var expense in myExpenses) {
      if (expense.type == type) {
        totalMoney += expense.price;
      }
    }

    return totalMoney;
  }

  String selectedCategory = 'All';

  List<Categories> categoryList = [];

  fillCategoryList() async {
    var categoriesBox = await Hive.openBox<Categories>("CategoriesHive");
    categoryList = categoriesBox.values.toList();
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
    ThemeModeOptionModel(colorName: "Red", colorValue: "0xFFFF0000"),
    ThemeModeOptionModel(colorName: "Blue", colorValue: "0xFF0000FF"),
    ThemeModeOptionModel(colorName: "Green", colorValue: "0xFF008000"),
  ];

  fillFilterdList() {
    filteredList = [];
    myExpenses = transactionsBox.values.toList();

    if (selectedCategory == "All") {
      filteredList = myExpenses;
    } else {
      filteredList = myExpenses
          .where((element) => element.category.contains(selectedCategory))
          .toList();
    }
  }
}
