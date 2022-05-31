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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDk5Y3mmV377FvCfF3Q6CdzEkZrHdYlRC4',
    appId: '1:280771982457:web:282bc0c1e6e5d6cf9690a8',
    messagingSenderId: '280771982457',
    projectId: 'fir-storage-app-757ea',
    authDomain: 'fir-storage-app-757ea.firebaseapp.com',
    storageBucket: 'fir-storage-app-757ea.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_IiaFp6fo6dFwqZ5iwfT3XgTqn1j1xV4',
    appId: '1:280771982457:android:730c26648acc479e9690a8',
    messagingSenderId: '280771982457',
    projectId: 'fir-storage-app-757ea',
    storageBucket: 'fir-storage-app-757ea.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyvBzG2IfgwK5tPPPD0GiWeE5pAV3A83M',
    appId: '1:280771982457:ios:65aa0eb02823b9b89690a8',
    messagingSenderId: '280771982457',
    projectId: 'fir-storage-app-757ea',
    storageBucket: 'fir-storage-app-757ea.appspot.com',
    iosClientId: '280771982457-f5sj8o5h5h39gea64j78k17aoh80dkso.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseStorageFlutter',
  );
}