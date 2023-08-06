import 'package:hive_flutter/hive_flutter.dart';

class HiveLocator {
  static final HiveLocator _instance = HiveLocator._internal();

  factory HiveLocator() {
    return _instance;
  }

  HiveLocator._internal();

  Box<String>? _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox<String>('SettingsHive');
  }

  Future<void> closeBox() async {
    if (_settingsBox != null && _settingsBox!.isOpen) {
      await _settingsBox!.close();
    }
  }

  Box<String>? get settingsBox => _settingsBox;

  // CRUD Operations

  Future<void> createSetting(String key, String value) async {
    await _settingsBox?.put(key, value);
  }

  String? readSetting(String key) {
    return _settingsBox?.get(key);
  }

  Future<void> updateSetting(String key, String newValue) async {
    if (_settingsBox?.containsKey(key) == true) {
      await _settingsBox?.put(key, newValue);
    }
  }

  Future<void> deleteSetting(String key) async {
    await _settingsBox?.delete(key);
  }
}
