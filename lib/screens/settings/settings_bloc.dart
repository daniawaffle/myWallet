import 'package:hive/hive.dart';

class SettingsBloc {
  final settingsBox = Hive.openBox<String>("SettingsHive");
}
