import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAiwVCJEBL2h6ivBLQ7yHE0dzhBX7UVNpo',
      appId: '1:296438891585:android:1a20a86cfc634388e9b2c0',
      messagingSenderId: '296438891585',
      projectId: 'teste-7b5d6',
      databaseURL:
          'https://teste-7b5d6-default-rtdb.europe-west1.firebasedatabase.app',
      authDomain: 'teste-7b5d6.firebaseapp.com',
      storageBucket: 'teste-7b5d6.appspot.com',
    ),
  );

  runApp(const MyApp());
}
