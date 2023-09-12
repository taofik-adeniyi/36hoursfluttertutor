import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:thenotes/enums/menu_action.dart';
import 'package:thenotes/services/auth/auth_service.dart';
import 'package:thenotes/views/constants/routes.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes View'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              // log(value.toString());
              log(value.toString());
              switch (value) {
                case MenuActions.logout:
                  final shouldlogout = await showLogOutDialog(context);
                  log(shouldlogout.toString());
                  if (shouldlogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuActions>(
                    value: MenuActions.logout, child: Text('Log out')),
              ];
            },
          )
        ],
      ),
      body: const Text('Hello World!'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out'))
          ],
        );
      }).then((value) => value ?? false);
}
