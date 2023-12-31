import 'package:expenses_app/constants.dart';
import 'package:expenses_app/locater.dart';
import 'package:expenses_app/services/hive_service.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    _initSavedColorValue();
  }

  Future<void> _initSavedColorValue() async {
    savedColorValue = await locator<HiveService>()
        .getBoxValueByKey(boxName: settingsHive, key: hiveKeyAppColorTheme);
    if (savedColorValue == null || savedColorValue!.isEmpty) {
      savedColorValue = "#000000";
    }
    setState(() {});
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
                await locator<HiveService>().setBoxValueByKey<String>(
                    boxName: settingsHive,
                    key: hiveKeyAppColorTheme,
                    value: value);
                widget.expensesBloc.appColorTheme = value;
                widget.expensesBloc.colorStreamController.sink.add(value);
                if (context.mounted) Navigator.of(context).pop();
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
  List<String> languageList = ["English", "Arabic"];

  @override
  void initState() {
    super.initState();
    _initSavedLanguageValue();
  }

  Future<void> _initSavedLanguageValue() async {
    savedLanguageValue = await locator<HiveService>()
        .getBoxValueByKey(boxName: settingsHive, key: hiveKeyAppLanguage);
    if (savedLanguageValue == null || savedLanguageValue!.isEmpty) {
      savedLanguageValue = "English";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (savedLanguageValue == null) {
      return const Center(
        child: Text("Loading..."),
      );
    } else {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Language'),
              DropdownButton<String>(
                value: savedLanguageValue ?? "English",
                onChanged: (value) async {
                  savedLanguageValue = value;
                  await locator<HiveService>().setBoxValueByKey<String>(
                      boxName: settingsHive,
                      key: hiveKeyAppLanguage,
                      value: value!);
                  if (context.mounted) Navigator.of(context).pop();
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
        ),
      );
    }
  }
}
