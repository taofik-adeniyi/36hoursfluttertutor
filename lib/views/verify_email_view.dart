import 'package:flutter/material.dart';
import 'package:thenotes/services/auth/auth_service.dart';

import 'package:thenotes/views/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text('Verify email'),
        ),
        body: Column(
          children: [
            const Text(
                'We\'ve sent you an email verification, Please open it to verify your account'),
            const Text(
                "If you have't received a verification email yet, press the button below"),
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                  // devtools.log(vvv);
                },
                child: const Text('Send email verification')),
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text('Restart'))
          ],
        ));
  }
}
