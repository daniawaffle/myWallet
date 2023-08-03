import 'package:hive/hive.dart';

mixin CommonHiveVarsMixin {
  Future<String> returnAppColorTheme() async {
    var settingsBox = await Hive.openBox('SettingsHive');
    var appColorTheme =
        settingsBox.get('appColorTheme', defaultValue: 'default_color');
    settingsBox.close();
    return appColorTheme;
  }
}
