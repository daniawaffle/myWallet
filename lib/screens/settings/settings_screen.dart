import 'package:expenses_app/locator.dart';
import 'package:expenses_app/models/settings.dart';
import 'package:expenses_app/models/transactions.dart';
import 'package:expenses_app/screens/expenses/expenses_screen.dart';
import 'package:expenses_app/screens/settings/settings_bloc.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsBloc settingsBloc = SettingsBloc();
  String language = 'English';
  String theme = 'Red';
  List<String> categories = ['All', 'Bills'];
  var settingsBox = locator<Box<Settings>>();
  var transactionsBox = locator<Box<Transactions>>();

  @override
  void initState() {
    super.initState();
    settingsBox = locator<Box<Settings>>();
  }

  void _updateSettings() {
    var updatedSettings =
        Settings(categories: categories, language: language, theme: theme);

    settingsBox.put('settingsKey', updatedSettings);
    updatedSettings.save();
    print(updatedSettings.categories);
    print(updatedSettings.language);
    print(updatedSettings.theme);
  }

  void _loadSettings() {
    Settings? settings = settingsBox.get('settingsKey');
    if (settings == null || settings.theme.isEmpty) {
      // Create the default Settings object
      settings =
          Settings(categories: ['All'], language: 'English', theme: 'Red');

      // Put the default Settings object in the settingsBox
      settingsBox.put('settingsKey', settings);
      settings.save();
    }

    // Update the state variables
    setState(() {
      language = settings!.language;
      theme = settings.theme;
      categories = settings.categories;
      settings.save();
    });
  }

  @override
  void dispose() {
    _updateSettings(); // Save the settings when the screen is disposed
    super.dispose();
  }

  List<String> _getCategories() {
    final Settings? settings = settingsBox.get(
      'settingsKey',
    );

    if (settings != null) {
      settings.save();
      return settings.categories;
    } else {
      return []; // Return an empty list if settings are not available or haven't been initialized
    }
  }

  void _addCategory() {
    final String categoryName = _categoryController.text.trim();
    if (categoryName.isNotEmpty) {
      final List<String> categories =
          _getCategories(); // Remove '!' to handle nullability properly
      categories.add(categoryName);
      settingsBox.put(
          'settingsKey',
          Settings(
              categories: categories,
              language: language,
              theme:
                  theme)); // Update the 'categories' property in Settings object
      _categoryController.clear();
    }
  }

  _deleteCategory(int index) {
    final List<String> categories = _getCategories();
    final categoryDelete = categories.removeAt(index);

    settingsBox.put('settingsKey',
        Settings(categories: categories, language: language, theme: theme));
    final List<Transactions> transactionsToDelete = transactionsBox.values
        .where((transaction) => transaction.category == categoryDelete)
        .toList();

    for (final transaction in transactionsToDelete) {
      transaction.delete();
    }
  }

  final TextEditingController _categoryController = TextEditingController();
  void _showCategoriesBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Wrap(
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _getCategories().length,
                  itemBuilder: (context, index) {
                    final category = _getCategories()[index];
                    return ListTile(
                        title: Text(category),
                        trailing:
                            category != 'All' ? const Icon(Icons.delete) : null,
                        onTap: () {
                          if (category != 'All') {
                            _deleteCategory(index);
                          } else {}
                        });
                  }),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Add new category',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addCategory,
                  ),
                ),
              )
            ],
          );
        });
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Wrap(
            children: <Widget>[
              RadioListTile(
                activeColor: Colors.teal,
                title: const Text('English'),
                value: 'English', // Corrected value here
                groupValue: language,
                onChanged: (value) {
                  setState(() {
                    language = value!; // Assign the string value directly
                  });
                  _updateSettings();
                },
              ),
              RadioListTile(
                activeColor: Colors.teal,
                title: const Text('Arabic'),
                value: 'Arabic',
                groupValue: language,
                onChanged: (value) {
                  setState(() {
                    language = value!;
                  });
                  _updateSettings();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Wrap(
            children: <Widget>[
              RadioListTile(
                activeColor: Colors.teal,
                title: const Text('Red'),
                value: 'Red',
                groupValue: theme,
                onChanged: (value) {
                  setState(() {
                    theme = value!;
                  });
                  _updateSettings();

                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                activeColor: Colors.teal,
                title: const Text('Green'),
                value: 'Green',
                groupValue: theme,
                onChanged: (value) {
                  setState(() {
                    theme = value!;
                  });
                  _updateSettings();
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                activeColor: Colors.teal,
                title: const Text('Blue'),
                value: 'Blue',
                groupValue: theme,
                onChanged: (value) {
                  setState(() {
                    theme = value!;
                  });

                  _updateSettings();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadSettings();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: settingsBloc.getThemeColor(),
        elevation: 10,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ExpensesScreen()),
                );
              },
              icon: Icon(Icons.arrow_back_ios_new))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _showLanguageBottomSheet(context);
              },
              child: const Text(
                'Change language',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                _showThemeBottomSheet(context);
              },
              child: const Text(
                'Change theme',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                _showCategoriesBottomSheet(context);
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
