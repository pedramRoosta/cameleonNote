import 'package:cameleon_note/helpers/dialog.dart';
import 'package:cameleon_note/helpers/popup_menu.dart';
import 'package:cameleon_note/services/auth/auth_service.dart';
import 'package:cameleon_note/services/repository/repository_service.dart';
import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:cameleon_note/services/router/routes.dart';
import 'package:cameleon_note/setup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({
    int? noteId,
    Key? key,
  })  : _noteId = noteId,
        super(key: key);
  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
  final int? _noteId;
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _navService = locateService<INavService>();
  final _authService = locateService<IAuthService>();
  final _repoService = locateService<Repository>();
  final _titleCtrl = TextEditingController();
  final _textCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit your note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await saveNote();
            },
          ),
          createPopupMenuButton(
            {
              'Save': () async {
                await saveNote();
              },
              'Logout': () async {
                await _authService.logout();
                _navService.pushAndPopUntil(
                  route: const LoginRoute(),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              {
                return Column(
                  children: [
                    TextField(
                      controller: _titleCtrl,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        contentPadding: const EdgeInsets.all(15),
                        fillColor: Colors.amber.withOpacity(0.1),
                        filled: true,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textCtrl,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          hintText: 'Your text',
                          contentPadding: EdgeInsets.all(15),
                        ),
                      ),
                    ),
                  ],
                );
              }
            default:
              {
                return const CircularProgressIndicator();
              }
          }
        },
      ),
    );
  }

  Future<void> loadNote() async {
    if (widget._noteId != null) {
      final note = await _repoService.getNote(noteId: widget._noteId!);
      _titleCtrl.text = note.title;
      _textCtrl.text = note.text;
    }
  }

  Future<void> saveNote() async {
    final user = _authService.currentUser!;
    final dbUser = await _repoService.getUser(email: user.email);
    try {
      if (widget._noteId == null) {
        await _repoService.createNote(
          owner: dbUser,
          title: _titleCtrl.text,
          text: _textCtrl.text,
        );
      } else {
        await _repoService.updateNote(
          noteId: widget._noteId!,
          title: _titleCtrl.text,
          text: _textCtrl.text,
        );
      }
      Fluttertoast.showToast(msg: 'Note is saved successfully.');
      _navService.pop();
    } on Exception catch (_) {
      showAppDialog(message: 'Error in creating the note, try again later.');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textCtrl.dispose();
    _titleCtrl.dispose();
  }
}
