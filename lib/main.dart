// import 'package:firebase_authentication/pages/explorePage.dart';
// import 'package:firebase_authentication/pages/loginPage.dart';
// import 'package:firebase_authentication/pages/registerPage.dart';
import 'package:firebase_authentication/pages/explorePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: 'AIzaSyBBQSYedQDKsYZt85GbZ_Y7hDPcHJuczx0',
    appId: '1:920630965284:android:bdefffcba1f40e4c64d4b1',
    messagingSenderId: '920630965284',
    projectId: 'simple-69490',
    storageBucket: "simple-69490.firebasestorage.app",
  )
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExplorePage()
      // routes: {
      //   '/registerPage': (context)=> const Registerpage(),
      //   '/explorePage': (context)=> const Explorepage(),
      // },
    );
  }
}

