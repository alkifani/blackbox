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
    apiKey: 'AIzaSyD92NRa9D-Un19Byf4ROmngWLw5786eN0w',
    appId: '1:935758614244:web:9498915244b8168aa766f1',
    messagingSenderId: '935758614244',
    projectId: 'black-box-29696',
    authDomain: 'black-box-29696.firebaseapp.com',
    storageBucket: 'black-box-29696.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBr-yY2jDpqbJuFbmT310TgJ0YPjdqzfHE',
    appId: '1:935758614244:android:d0842dd73ad62fa4a766f1',
    messagingSenderId: '935758614244',
    projectId: 'black-box-29696',
    storageBucket: 'black-box-29696.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCdcUljgtusWqyYHaXhLk4jRgTHToyqEM',
    appId: '1:935758614244:ios:f81141f057f481eca766f1',
    messagingSenderId: '935758614244',
    projectId: 'black-box-29696',
    storageBucket: 'black-box-29696.appspot.com',
    iosClientId: '935758614244-3bclkj8qhphp8ighcgacmf33tdrneua5.apps.googleusercontent.com',
    iosBundleId: 'com.example.bb',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCCdcUljgtusWqyYHaXhLk4jRgTHToyqEM',
    appId: '1:935758614244:ios:9219732a0fb8feeca766f1',
    messagingSenderId: '935758614244',
    projectId: 'black-box-29696',
    storageBucket: 'black-box-29696.appspot.com',
    iosClientId: '935758614244-cmvs49ef2cc6ifp632ueip5n33d9hfkn.apps.googleusercontent.com',
    iosBundleId: 'com.example.bb.RunnerTests',
  );
}