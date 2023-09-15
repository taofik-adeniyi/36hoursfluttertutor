import 'package:flutter/material.dart';
import 'package:thenotes/services/auth/auth_service.dart';
import 'package:thenotes/views/constants/routes.dart';
import 'package:thenotes/views/login_view.dart';
import 'package:thenotes/views/notes/new_notes_view.dart';
import 'package:thenotes/views/notes/notes_view.dart';
import 'package:thenotes/views/register_view.dart';
import 'package:thenotes/views/verify_email_view.dart';
// import 'dart:developer' as devtools show log; used a sdevtools.log()

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
      registerRoute: (context) => const RegisterView(),
      loginRoute: (context) => const LoginView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView(),
      newNoteRoute: (context) => const NewNoteView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const RegisterView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
