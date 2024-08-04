import 'package:firebase_authentication/pages/explorePage.dart';
import 'package:firebase_authentication/pages/loginPage.dart';
import 'package:firebase_authentication/pages/registerPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loginpage(),
      routes: {
        '/registerPage': (context)=> const Registerpage(),
        '/explorePage': (context)=> const Explorepage(),
      },
    );
  }
}

