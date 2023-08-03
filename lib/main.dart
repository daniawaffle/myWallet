import '/screens/expenses/expenses_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/categories.dart';
import 'models/transactions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionsAdapter());
  Hive.registerAdapter<TransactionType>(TransactionTypeAdapter());

  Hive.registerAdapter(CategoriesAdapter());

  await Hive.openBox<Transactions>('wallet_data');
  await Hive.openBox<String>("SettingsHive");
  await Hive.openBox<Categories>("CategoriesHive");

  var categoriesBox = await Hive.openBox<Categories>("CategoriesHive");
  if (categoriesBox.isEmpty) {
    List<Categories> categoryList = [
      // Categories(
      //   category: 'All',
      // ),
      Categories(
        category: 'Food',
      ),
      Categories(
        category: 'Transportation',
      ),
      Categories(
        category: 'Family',
      ),
      Categories(
        category: 'Personal Care',
      ),
      Categories(
        category: 'Bills',
      ),
      Categories(
        category: 'Medical',
      ),
      Categories(
        category: 'Loans',
      ),
    ];

    for (var category in categoryList) {
      categoriesBox.put(category.uniqueId, category);
    }
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpensesScreen(),
    );
  }
}
