import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:thenotes/enums/menu_action.dart';
import 'package:thenotes/services/auth/auth_service.dart';
import 'package:thenotes/services/crud/notes_service.dart';
import 'package:thenotes/views/constants/routes.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: const Icon(Icons.add)),
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const Text('Waiting for all notes');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
                stream: _notesService.allNotes,
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
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
