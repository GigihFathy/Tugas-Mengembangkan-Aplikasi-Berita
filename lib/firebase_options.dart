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
    apiKey: 'AIzaSyCuelNP9ZmqRn2gz4jhQNLxU0gjpWFbybM',
    appId: '1:375645684829:web:56683031b14daceacd39b4',
    messagingSenderId: '375645684829',
    projectId: 'newsapp-97662',
    authDomain: 'newsapp-97662.firebaseapp.com',
    storageBucket: 'newsapp-97662.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBO0n897HLKcRBn5SBIX0oPcZQhbLgjfHA',
    appId: '1:375645684829:android:ada74b53713bb235cd39b4',
    messagingSenderId: '375645684829',
    projectId: 'newsapp-97662',
    storageBucket: 'newsapp-97662.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrxJIgVwI1piSy0dRvAyaJR7_Vkrwbgac',
    appId: '1:375645684829:ios:4c81fb43848ba1f2cd39b4',
    messagingSenderId: '375645684829',
    projectId: 'newsapp-97662',
    storageBucket: 'newsapp-97662.appspot.com',
    iosClientId:
        '375645684829-q8uqadca8mbbm5212lmo0e1lmsvb7ecb.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsApp',
  );
}
