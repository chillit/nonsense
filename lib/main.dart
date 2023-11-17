import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nonsense/Login_page.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCbzuhWcyuvbGg5tLE01P6Zbi1AL2XP5y0",
          authDomain: "nonsense-378e9.firebaseapp.com",
          projectId: "nonsense-378e9",
          storageBucket: "nonsense-378e9.appspot.com",
          messagingSenderId: "767035250430",
          appId: "1:767035250430:web:098b4d8a8660fa67bc77af",
          measurementId: "G-9LN8KYQ05P")
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "NIS Security",
    theme: ThemeData(
      fontFamily: 'Futura',
    ),
    home: LoginPage(),
    // Login()
  ));
}


