import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class FirebaseService extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> writeToDatabase(String path, Map<String, dynamic> data) async {
    await _database.child(path).set(data);
  }

  Future<void> updateDatabase(String path, Map<String, dynamic> data) async {
    await _database.child(path).update(data);
  }

  Future<void> deleteFromDatabase(String path) async {
    await _database.child(path).remove();
  }

  Stream<DatabaseEvent> readFromDatabase(String path) {
    return _database.child(path).onValue;
  }
}
