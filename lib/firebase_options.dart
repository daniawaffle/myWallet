// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA28cyR5yUvOICyxeThu_e6a6Kh1f7GM3k',
    appId: '1:555858453445:web:15f59979f3b1cc3aa6e1ac',
    messagingSenderId: '555858453445',
    projectId: 'my-wallet-firebase',
    authDomain: 'my-wallet-firebase.firebaseapp.com',
    storageBucket: 'my-wallet-firebase.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBioxOVSrQwIP0psYVq7zc-lsz5oPFsgPo',
    appId: '1:555858453445:android:adac54ff85d8d60da6e1ac',
    messagingSenderId: '555858453445',
    projectId: 'my-wallet-firebase',
    storageBucket: 'my-wallet-firebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArkD7ZlKwJLkQ4VLO58RGP5GZbDxmJiOA',
    appId: '1:555858453445:ios:722eca8ed56baf75a6e1ac',
    messagingSenderId: '555858453445',
    projectId: 'my-wallet-firebase',
    storageBucket: 'my-wallet-firebase.appspot.com',
    iosClientId: '555858453445-rfha5apckitrie82db12p50r1j42scaf.apps.googleusercontent.com',
    iosBundleId: 'com.example.expensesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArkD7ZlKwJLkQ4VLO58RGP5GZbDxmJiOA',
    appId: '1:555858453445:ios:3375dde4f7456d55a6e1ac',
    messagingSenderId: '555858453445',
    projectId: 'my-wallet-firebase',
    storageBucket: 'my-wallet-firebase.appspot.com',
    iosClientId: '555858453445-olc4rl1egjmk3v9vgqij4fpi5ec8ai7k.apps.googleusercontent.com',
    iosBundleId: 'com.example.expensesApp.RunnerTests',
  );
}
