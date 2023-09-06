import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thenotes/firebase_options.dart';
import 'package:thenotes/views/login_view.dart';
import 'package:thenotes/views/register_view.dart';
import 'package:thenotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        // colorSchemsse: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: tsrue,
        primarySwatch: Colors.blue),
    home: const HomePage(),
    routes: {
      '/register/': (context) => const RegisterView(),
      '/login/': (context) => const LoginView(),
      '/verify_email/': (context) => const VerifyEmailView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print('email is verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const RegisterView();
            }
            return const Text('DONE');
            // print(user);
            // if (user?.emailVerified ?? false) {
            //   // print('You are a verified user');
            //   // return const LoginView();
            // } else {
            //   return const VerifyEmailView();
            //   // print('You need to verify your email');
            //   // Navigator.of(context).push(
            //   // MaterialPageRoute(builder: (context) => VerifyEmailView()));
            // }
            return const LoginView();
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
