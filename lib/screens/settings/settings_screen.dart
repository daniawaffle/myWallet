import 'package:expenses_app/locator.dart';
import 'package:expenses_app/models/settings.dart';

import 'package:expenses_app/screens/expenses/expenses_screen.dart';
import 'package:expenses_app/mixins/bottom_sheet_settings_mixin.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with BottomSheetSettings {
  @override
  void initState() {
    super.initState();
    settingsBox = locator<Box<Settings>>();
    settingsBox.get('settingsKey');
  }

  void _loadSettings() {
    Settings? settings = settingsBox.get('settingsKey');
    if (settings == null || settings.theme.isEmpty) {
      settings =
          Settings(categories: ['All'], language: 'English', theme: 'Red');

      settingsBox.put('settingsKey', settings);
      settings.save();
    }

    setState(() {
      language = settings!.language;
      theme = settings.theme;
      categories = settings.categories;
      settings.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadSettings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: settingsBloc.getThemeColor(),
        elevation: 10,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ExpensesScreen()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showSettingsBottomSheet(context, ['English', 'Arabic']);
                setState(() {});
              },
              child: const Text(
                'Change language',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                showSettingsBottomSheet(context, ['Red', 'Green', 'Blue']);
                setState(() {});
              },
              child: const Text(
                'Change theme',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                showCategoriesBottomSheet(context);
                setState(() {});
              },
              child: const Text(
                'Categories',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
