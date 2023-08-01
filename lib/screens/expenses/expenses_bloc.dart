import 'package:expenses_app/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/categories.dart';

final transactionsBox = Hive.box<Transactions>('wallet_data');

class ExpensesBloc {
  final List<Transactions> myExpenses = transactionsBox.values.toList();

  double calculateIncomeOutcome(TransactionType type) {
    double totalMoney = 0;

    for (var expense in myExpenses) {
      if (expense.type == type) {
        totalMoney += expense.price;
      }
    }

    return totalMoney;
  }

  String selectedCategory = 'All';

  List<Categories> categoryList = [
    Categories(
      category: 'All',
      categoryIcon: Icons.view_module,
    ),
    Categories(
      category: 'Food',
      categoryIcon: Icons.fastfood,
    ),
    Categories(
      category: 'Transportation',
      categoryIcon: Icons.emoji_transportation,
    ),
    Categories(
      category: 'Family',
      categoryIcon: Icons.people,
    ),
    Categories(
      category: 'Personal Care',
      categoryIcon: Icons.self_improvement,
    ),
    Categories(
      category: 'Bills',
      categoryIcon: Icons.local_atm,
    ),
    Categories(
      category: 'Medical',
      categoryIcon: Icons.medical_services,
    ),
    Categories(
      category: 'Loans',
      categoryIcon: Icons.real_estate_agent,
    ),
  ];

  List<Transactions> filteredList = [];

  fillFilterdList() {
    filteredList = [];
    if (selectedCategory == "All") {
      filteredList = myExpenses;
    } else {
      filteredList = myExpenses
          .where((element) => element.category.contains(selectedCategory))
          .toList();
    }
  }
}
