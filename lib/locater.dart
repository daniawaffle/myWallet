import 'package:expenses_app/services/firebase_auth.dart';
import 'package:expenses_app/services/hive_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => HiveService());
  locator.registerLazySingleton(() => FirebaseAuthService());
}
