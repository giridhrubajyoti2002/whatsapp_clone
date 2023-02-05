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
    apiKey: 'AIzaSyCK-d_9Aq9R7pDmdhh-KaFKowjHUIoYqwA',
    appId: '1:754263213803:web:2385bf230bb09d18cf20ae',
    messagingSenderId: '754263213803',
    projectId: 'whatsapp-clone-ed1e2',
    authDomain: 'whatsapp-clone-ed1e2.firebaseapp.com',
    storageBucket: 'whatsapp-clone-ed1e2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9n_GwsDmYvwAI5cL6IHEn8-oQvB_o8r8',
    appId: '1:754263213803:android:cd223264e9be5adfcf20ae',
    messagingSenderId: '754263213803',
    projectId: 'whatsapp-clone-ed1e2',
    storageBucket: 'whatsapp-clone-ed1e2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCpyQ_tVaC4lVpnOLxFEPOKDnW2ISy1XM',
    appId: '1:754263213803:ios:f4d57ab463b4b259cf20ae',
    messagingSenderId: '754263213803',
    projectId: 'whatsapp-clone-ed1e2',
    storageBucket: 'whatsapp-clone-ed1e2.appspot.com',
    iosClientId: '754263213803-43m73ldfm1371t8hbdotl5isuu9rg5lv.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCCpyQ_tVaC4lVpnOLxFEPOKDnW2ISy1XM',
    appId: '1:754263213803:ios:f4d57ab463b4b259cf20ae',
    messagingSenderId: '754263213803',
    projectId: 'whatsapp-clone-ed1e2',
    storageBucket: 'whatsapp-clone-ed1e2.appspot.com',
    iosClientId: '754263213803-43m73ldfm1371t8hbdotl5isuu9rg5lv.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );
}