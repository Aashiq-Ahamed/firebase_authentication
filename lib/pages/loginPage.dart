import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/components/MyButton.dart';
import 'package:firebase_authentication/components/MySquareTile.dart';
import 'package:firebase_authentication/components/MyTextField.dart';
import 'package:firebase_authentication/pages/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginpage extends StatelessWidget {
  Loginpage({super.key});

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onRegister() {
      Navigator.pushNamed(context, '/registerPage');
    }

    void onLogin() {
      Navigator.pushNamed(context, '/explorePage');
    }

    void onGoogleSignIn() async {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("google login success ==================================");
      print(userCredential.user?.displayName);

      Navigator.pushNamed(context, '/explorePage');
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            const SizedBox(height: 50),
            //logo
            const Icon(
              Icons.lock,
              size: 100,
            ),
            const SizedBox(height: 50),

            //welcome back
            Text(
              'Welcome back! you\'ve been missed!',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),

            const SizedBox(height: 50),

            //username

            MyTextfield(
              controller: userNameController,
              hinttext: 'Username',
              isPassword: false,
            ),
            const SizedBox(height: 15),

            //Password field

            MyTextfield(
              controller: passwordController,
              hinttext: 'Password',
              isPassword: true,
            ),
            const SizedBox(height: 15),

            //forgot password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),

            //SignIn button
            Mybutton(
              onTap: onLogin,
            ),

            const SizedBox(height: 10),

            const Text('or continue with'),

            //Sign in options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onGoogleSignIn,
                  child: const Mysquaretile(
                      imagePath: 'assets/googleLogo.png', height: 40),
                ),
                const SizedBox(width: 35),
                const Mysquaretile(
                    imagePath: 'assets/appleLogo.png', height: 40),
                const SizedBox(width: 32),
                const Mysquaretile(
                    imagePath: 'assets/facebookLogo.png', height: 55),
              ],
            ),

            const SizedBox(
              height: 5,
            ),

            //Register now options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a member?'),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    // Call your method here
                    onRegister();
                  },
                  child: const Text(
                    'Register Now',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
