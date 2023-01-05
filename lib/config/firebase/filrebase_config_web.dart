// ignore: deprecated_member_use
import 'package:firebase/firebase.dart' as fb;

class FirebaseConfigs {
  FirebaseConfigs._();

  static void configuration() {
    // Break if the app is already initialized.
    if (fb.apps.isNotEmpty) return;
    // Checking environment to get the config.
    fb.initializeApp(
        apiKey: "AIzaSyC-ABb-5SHB7-S7-sD__KF2uYGCnRkrLDk",
        authDomain: "cp-smart-building-dev.firebaseapp.com",
        projectId: "cp-smart-building-dev",
        storageBucket: "cp-smart-building-dev.appspot.com",
        messagingSenderId: "898842009983",
        appId: "1:898842009983:web:d1b34f85d50d7624ea3a4a",
        measurementId: "G-262YJGBYY9");
  }
}
