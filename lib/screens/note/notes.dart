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
                        print(notes);
                        // return ListView.builder(
                        //   itemCount: notes.length,
                        //   itemBuilder: (context, i) {
                        //     return Card(
                        //       child: Text(
                        //         i.toString(),
                        //       ),
                        //     );
                        //   },
                        // );
                        return Wrap(
                          children: List.generate(
                            notes.length,
                            (index) => SizedBox(
                              width: 200,
                              height: 200,
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        notes[index].title,
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Expanded(
                                        child: Text(notes[index].text),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
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
}
