import 'package:cameleon_note/helpers/dialog.dart';
import 'package:cameleon_note/helpers/popup_menu.dart';
import 'package:cameleon_note/services/auth/auth_service.dart';
import 'package:cameleon_note/services/repository/models/db_note.dart';
import 'package:cameleon_note/services/repository/repository_service.dart';
import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:cameleon_note/services/router/routes.dart';
import 'package:cameleon_note/setup.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _navService = locateService<INavService>();
  final _authService = locateService<IAuthService>();
  final _repoService = locateService<Repository>();
  @override
  Widget build(BuildContext context) {
    final userEmail = _authService.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _navService.push(route: EditNoteRoute());
            },
            icon: const Icon(Icons.add),
          ),
          createPopupMenuButton(
            {
              'Logout': () async {
                await _authService.logout();
                _navService.pushAndPopUntil(route: const LoginRoute());
              }
            },
          ),
        ],
        title: const Text('Home page'),
      ),
      body: FutureBuilder(
        future: _repoService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _repoService.allNotes,
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final notes = snapshot.data as List<DBNote>;
                        if (notes.isNotEmpty) {
                          return _createNoteList(notes: notes);
                        } else {
                          return const Center(
                            child: Text('Currently no text exists...'),
                          );
                        }
                      }
                      return const CircularProgressIndicator();
                    default:
                      return const CircularProgressIndicator();
                  }
                }),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _createNoteList({required List<DBNote> notes}) {
    return Wrap(
      children: List.generate(notes.length, (index) {
        final note = notes[index];
        return SizedBox(
          width: 200,
          height: 200,
          child: GestureDetector(
            onTap: () {
              _navService.push(route: EditNoteRoute(noteId: note.id));
            },
            child: Card(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      note.title,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        note.text,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    color: Colors.amber.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          note.time,
                          style: const TextStyle(
                            color: Colors.purple,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.purple,
                          ),
                          onPressed: () {
                            showAppDialog(
                              message:
                                  'Are you sure you want to delete this item?',
                              hasOk: true,
                              okButton: () {
                                _repoService.deleteNote(note: note);
                              },
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
