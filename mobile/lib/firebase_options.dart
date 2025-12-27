// File generated manually for Firebase configuration
// This file contains Firebase configuration for iOS and Android platforms

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqheUoyvh6PMuYaQeOfhGMo9yIhL4wmXs',
    appId: '1:356409230876:ios:e9ce859fda6e6ac95e01d9',
    messagingSenderId: '356409230876',
    projectId: 'astro-app-4dc35',
    storageBucket: 'astro-app-4dc35.firebasestorage.app',
    iosBundleId: 'com.innerwisdom.astroapp',
    iosClientId: '356409230876-d5bgkv0l43gd20sae2ggga9h17ct4t71.apps.googleusercontent.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2wVM2eTaRNEkoTv1Q4UP_n7AUb8OS53c',
    appId: '1:356409230876:android:e0d807acf042d74b5e01d9',
    messagingSenderId: '356409230876',
    projectId: 'astro-app-4dc35',
    storageBucket: 'astro-app-4dc35.firebasestorage.app',
  );
}

