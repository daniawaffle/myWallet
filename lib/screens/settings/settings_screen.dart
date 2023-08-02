import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/theme_mode_option_model.dart';

class SettingsScreen extends StatelessWidget {
  final List<ThemeModeOptionModel> themeModeOptionList;
  const SettingsScreen({super.key, required this.themeModeOptionList});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Change Theme'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ThemeModeBottomSheet(
                        themeModeOptionList: themeModeOptionList);
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
                    return LanguageBottomSheet();
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Categories'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return CategoriesBottomSheet();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeModeBottomSheet extends StatefulWidget {
  final List<ThemeModeOptionModel> themeModeOptionList;
  const ThemeModeBottomSheet({super.key, required this.themeModeOptionList});

  @override
  State<ThemeModeBottomSheet> createState() => _ThemeModeBottomSheetState();
}

class _ThemeModeBottomSheetState extends State<ThemeModeBottomSheet> {
  late Box<String> settingsHiveBox;
  late String? savedColorValue;
  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    settingsHiveBox = await Hive.openBox<String>("SettingsHive");
    savedColorValue = settingsHiveBox.get('appColorTheme');
  }

  @override
  Widget build(BuildContext context) {
    String appColorTheme = savedColorValue ?? "0xFFFF0000";
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
                settingsHiveBox.put("appColorTheme", value);
                Navigator.pop(context);
                setState(() {});
              },
            );
          },
        ));
  }
}

class LanguageBottomSheet extends StatefulWidget {
  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late String? savedLanguageValue;

  List<String> languageList = ["English", "Arabic"];
  late Box<String> settingsHiveBox;
  @override
  void initState() async {
    super.initState();
    await _initHive();
  }

  Future<void> _initHive() async {
    settingsHiveBox = await Hive.openBox<String>("SettingsHive");
    savedLanguageValue = settingsHiveBox.get('appLanguage');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Language'),
          DropdownButton<String>(
            value: savedLanguageValue ?? "English",
            onChanged: (value) {
              savedLanguageValue = value!;
              settingsHiveBox.put("appLanguage", value);
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

class CategoriesBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Manage Categories'),
          // Add your category management UI here
        ],
      ),
    );
  }
}
