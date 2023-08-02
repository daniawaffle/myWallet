import '/screens/expenses/expenses_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/transactions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TransactionsAdapter());
  Hive.registerAdapter<TransactionType>(TransactionTypeAdapter());
  await Hive.openBox<Transactions>('wallet_data');

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
