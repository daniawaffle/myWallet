import 'package:expenses_app/constants.dart';
import 'package:expenses_app/firebase_options.dart';
import 'package:expenses_app/screens/login/login_screen.dart';
import 'package:expenses_app/services/hive_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:localization/localization.dart';
import 'locater.dart';
import 'models/categories.dart';
import 'models/transactions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // LocalJsonLocalization.delegate.directories = ['lib/i18n'];

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionsAdapter());
  Hive.registerAdapter<TransactionType>(TransactionTypeAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  setupLocator();
  await locator<HiveService>().openBoxes();
  if (locator<HiveService>().categoriesBox.isEmpty) {
    List<Categories> categoryList = [
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
      locator<HiveService>().setValue(
          boxName: categoriesHive, key: category.uniqueId!, value: category);
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
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,

      //   LocalJsonLocalization.delegate,
      // ],
      home: LoginScreen(),
    );
  }
}
