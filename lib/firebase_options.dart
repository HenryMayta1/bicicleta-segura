import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDVj4PiPub1Vws4ImbIWxyc8XF0ZVKNd-4",
    authDomain: "bicicletas-seguras-9bdf1.firebaseapp.com",
    projectId: "bicicletas-seguras-9bdf1",
    storageBucket: "bicicletas-seguras-9bdf1.firebasestorage.app",
    messagingSenderId: "697573443999",
    appId: "1:697573443999:web:cc10f2fa28bebd553915aa",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDVj4PiPub1Vws4ImbIWxyc8XF0ZVKNd-4",
    appId: "1:697573443999:web:cc10f2fa28bebd553915aa",
    messagingSenderId: "697573443999",
    projectId: "bicicletas-seguras-9bdf1",
    storageBucket: "bicicletas-seguras-9bdf1.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyDVj4PiPub1Vws4ImbIWxyc8XF0ZVKNd-4",
    appId: "1:697573443999:web:cc10f2fa28bebd553915aa",
    messagingSenderId: "697573443999",
    projectId: "bicicletas-seguras-9bdf1",
    storageBucket: "bicicletas-seguras-9bdf1.firebasestorage.app",
    iosClientId: '',
    iosBundleId: '',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyDVj4PiPub1Vws4ImbIWxyc8XF0ZVKNd-4",
    appId: "1:697573443999:web:cc10f2fa28bebd553915aa",
    messagingSenderId: "697573443999",
    projectId: "bicicletas-seguras-9bdf1",
    storageBucket: "bicicletas-seguras-9bdf1.firebasestorage.app",
  );
}
