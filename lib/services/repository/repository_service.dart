import 'dart:async';
import 'dart:developer';

import 'package:cameleon_note/helpers/date_time.dart';
import 'package:cameleon_note/services/repository/constants/constants.dart';
import 'package:cameleon_note/services/repository/extensions/list_filter.dart';
import 'package:cameleon_note/services/repository/models/db_note.dart';
import 'package:cameleon_note/services/repository/models/db_user.dart';
import 'package:cameleon_note/services/repository/models/exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart';

class Repository {
  Repository() {
    _noteCtrl = StreamController<List<DBNote>>.broadcast(
      onListen: () {
        _noteCtrl.sink.add(_notes);
      },
    );
  }

  Database? _database;
  DBUser? _dbUser;
  List<DBNote> _notes = [];
  late final StreamController<List<DBNote>> _noteCtrl;
  Stream<List<DBNote>> get allNotes => _noteCtrl.stream.filter((note) {
        if (_dbUser != null) {
          return note.userId == _dbUser!.id;
        } else {
          throw DBUserShouldBeSetBeforeReadingNotesException();
        }
      });

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNote();
    _notes = allNotes.toList();
    _noteCtrl.add(_notes);
  }

  String get dbName => 'Notes.db';

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DBAlreadyOpenedException {
      // Empty
    }
  }

  Future<void> open() async {
    if (_database != null) {
      throw DBAlreadyOpenedException();
    }
    try {
      final docPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docPath.path, dbName);
      final db = await openDatabase(dbPath);
      _database = db;

      await db.execute(RepoConstants.createUserTable);
      await db.execute(RepoConstants.createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException catch (_) {
      throw DBUnableToGetDocumentDirectoryException();
    } catch (e) {
      log(e.toString());
    }
  }

  Database _getDatabaseOrThrow() {
    if (_database == null) {
      throw DBIsNotOpenException();
    } else {
      return _database!;
    }
  }

  Future<void> close() async {
    if (_database == null) {
      throw DBIsNotOpenException();
    } else {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      RepoConstants.userTableName,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw DBCouldNotDeleteTheUserException();
    }
  }

  Future<DBUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final listOfUser = await db.query(
      RepoConstants.userTableName,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (listOfUser.isNotEmpty) {
      throw DBUserAlreadyExistsException();
    }
    final userId = await db.insert(RepoConstants.userTableName, {
      'email': email.toLowerCase(),
    });

    return DBUser.fromDB({
      'id': userId,
      'email': email,
    });
  }

  Future<DBUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final listOfUser = await db.query(
      RepoConstants.userTableName,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (listOfUser.isEmpty) {
      throw DBUserNotFoundException();
    }
    return DBUser.fromDB(listOfUser.first);
  }

  // Note Section...
  Future<DBNote> createNote({
    required DBUser owner,
    String title = '',
    String text = '',
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final user = await getUser(email: owner.email);
    if (user != owner) {
      throw DBUserNotFoundException();
    } else {
      final dateTime = Helper.toDateFormat(date: DateTime.now());
      final note = {
        'userId': user.id,
        'title': title,
        'text': text,
        'time': dateTime,
        'isSyncedWithCloud': 0
      };
      final noteId = await db.insert(RepoConstants.noteTableName, note);
      note.addAll({'id': noteId});
      final noteObj = DBNote.fromDB(map: note);
      _notes.add(noteObj);
      _noteCtrl.add(_notes);
      return noteObj;
    }
  }

  Future<void> deleteNote({required DBNote note}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(RepoConstants.noteTableName,
        where: 'id=?', whereArgs: [note.id]);

    if (deletedCount == 0) {
      throw DBNoteNotFoundException();
    } else {
      _notes.removeWhere((element) => element.id == note.id);
      _updateStreamController();
    }
  }

  void _updateStreamController() {
    _noteCtrl.add(_notes);
  }

  Future<int> deleteAllNote() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    _notes = [];
    _updateStreamController();
    return await db.delete(RepoConstants.createNoteTable);
  }

  Future<DBNote> getNote({required int noteId}) async {
    final db = _getDatabaseOrThrow();
    final noteList = await db.query(
      RepoConstants.noteTableName,
      limit: 1,
      where: 'id=?',
      whereArgs: [noteId],
    );
    if (noteList.isEmpty) {
      throw DBNoteNotFoundException();
    } else {
      final note = DBNote.fromDB(map: noteList.first);
      _notes.removeWhere((element) => element.id == noteId);
      _notes.add(note);
      return note;
    }
  }

  Future<Iterable<DBNote>> getAllNote() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final noteList = await db.query(
      RepoConstants.noteTableName,
    );
    return noteList.map(
      (e) => DBNote.fromDB(map: e),
    );
  }

  Future<DBNote> updateNote({
    required int noteId,
    String? title,
    String? text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final note = await getNote(noteId: noteId);
    final updatedCount = await db.update(
      RepoConstants.noteTableName,
      {
        'id': note.id,
        'userId': note.userId,
        'title': title ?? note.title,
        'text': text ?? note.text,
        'time': Helper.toDateFormat(
          date: DateTime.now(),
        ),
        'isSyncedWithCloud': note.isSyncedWithCloud ? 1 : 0,
      },
      where: 'id=?',
      whereArgs: [noteId],
    );
    if (updatedCount == 0) {
      DBNoteUpdateFailedException();
    }
    final updatedNote = await getNote(noteId: noteId);
    _notes.removeWhere((element) => element.id == noteId);
    _notes.add(updatedNote);
    _updateStreamController();
    return updatedNote;
  }

  Future<DBUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    late DBUser user;
    try {
      user = await getUser(email: email);
    } on DBUserNotFoundException catch (_) {
      user = await createUser(email: email);
    } catch (e) {
      rethrow;
    }
    if (setAsCurrentUser) _dbUser = user;
    return user;
  }
}
