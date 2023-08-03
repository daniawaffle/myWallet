import 'package:hive/hive.dart';

// HiveProvider class to manage Hive operations
class HiveProvider {
  late Box<String> settingsHiveBox;

  Future<void> initHive() async {
    settingsHiveBox = await Hive.openBox<String>("SettingsHive");
  }

  String? getSavedLanguageValue() {
    return settingsHiveBox.get('appLanguage');
  }

  void saveLanguageValue(String value) {
    settingsHiveBox.put("appLanguage", value);
  }
}
