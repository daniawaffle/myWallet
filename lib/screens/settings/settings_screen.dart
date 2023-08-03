import 'package:expenses_app/screens/settings/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/theme_mode_option_model.dart';
import '../expenses/expenses_bloc.dart';
import 'categories_screen.dart';

class SettingsScreen extends StatelessWidget {
  final List<ThemeModeOptionModel> themeModeOptionList;
  final ExpensesBloc expensesBloc;

  const SettingsScreen(
      {super.key,
      required this.themeModeOptionList,
      required this.expensesBloc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Change Theme'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ThemeModeBottomSheet(
                      themeModeOptionList: themeModeOptionList,
                      expensesBloc: expensesBloc);
                },
              );
            },
          ),
          ListTile(
            title: const Text('Change Language'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const LanguageBottomSheet();
                },
              );
            },
          ),
          ListTile(
            title: const Text('Categories'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategoriesScreen(
                        expensesBloc: expensesBloc,
                      )));
            },
          ),
        ],
      ),
    );
  }
}

class ThemeModeBottomSheet extends StatefulWidget {
  final List<ThemeModeOptionModel> themeModeOptionList;
  final ExpensesBloc expensesBloc;
  const ThemeModeBottomSheet(
      {super.key,
      required this.themeModeOptionList,
      required this.expensesBloc});

  @override
  State<ThemeModeBottomSheet> createState() => _ThemeModeBottomSheetState();
}

class _ThemeModeBottomSheetState extends State<ThemeModeBottomSheet> {
  late String? savedColorValue = "#000000";
  SettingsBloc bloc = SettingsBloc();
  @override
  void initState() {
    super.initState();
    _initSavedColorValue();
  }

  Future<void> _initSavedColorValue() async {
    Box<String> settingsBox = await bloc.settingsBox;
    setState(() {
      savedColorValue = settingsBox.get('appColorTheme') ?? "#000000";
    });
  }

  @override
  Widget build(BuildContext context) {
    String appColorTheme = savedColorValue ?? "#000000";
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.themeModeOptionList.length,
          itemBuilder: (context, index) {
            return RadioListTile<String>(
              title: Text(widget.themeModeOptionList[index].colorName),
              value: widget.themeModeOptionList[index].colorValue,
              groupValue: appColorTheme,
              onChanged: (value) async {
                appColorTheme = value!;
                Box<String> settingsBox = await bloc.settingsBox;

                settingsBox.put("appColorTheme", value);
                widget.expensesBloc.appColorTheme = value;
                widget.expensesBloc.colorStreamController.sink.add(value);
                Navigator.pop(context);
                setState(() {});
              },
            );
          },
        ));
  }
}

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late String? savedLanguageValue = "English";
  SettingsBloc bloc = SettingsBloc();
  List<String> languageList = ["English", "Arabic"];

  @override
  void initState() {
    super.initState();
    _initSavedLanguageValue();
  }

  Future<void> _initSavedLanguageValue() async {
    Box<String> settingsBox = await bloc.settingsBox;

    setState(() {
      savedLanguageValue = settingsBox.get('appLanguage') ?? "English";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (savedLanguageValue == null) {
      return const Center(
        child: Text("Loading..."),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Language'),
            DropdownButton<String>(
              value: savedLanguageValue ?? "English",
              onChanged: (value) async {
                savedLanguageValue = value;
                Box<String> settingsBox = await bloc.settingsBox;
                settingsBox.put("appLanguage", value!);

                Navigator.pop(context);
                setState(() {});
              },
              items: languageList.map<DropdownMenuItem<String>>(
                (String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option), // Display the language as the label
                  );
                },
              ).toList(),
            ),
          ],
        ),
      );
    }
  }
}
