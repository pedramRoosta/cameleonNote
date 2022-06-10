import 'package:cameleon_note/services/repository/constants/constants.dart';
import 'package:cameleon_note/services/repository/models/db_note.dart';
import 'package:cameleon_note/services/repository/models/db_user.dart';
import 'package:cameleon_note/services/repository/models/exceptions.dart';
import 'package:cameleon_note/services/repository/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class Repository extends IRepository {
  Database? _database;

  @override
  String get dbName => 'Notes.db';

  @override
  Future<void> open() async {
    if (_database != null) {
      throw DBNotOpenedException();
    }
    try {
      final docPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docPath.path, dbName);
      final db = await openDatabase(dbPath);
      _database = db;

      await db.execute(RepoConstants.createUserTable);
      await db.execute(RepoConstants.createNoteTable);
    } on MissingPlatformDirectoryException catch (_) {
      throw DBUnableToGetDocumentDirectoryException();
    } catch (_) {}
  }

  Database _getDatabaseOrThrow() {
    if (_database == null) {
      throw DBIsNotOpenException();
    } else {
      return _database!;
    }
  }

  @override
  Future<void> close() async {
    if (_database == null) {
      throw DBIsNotOpenException();
    } else {
      await _database!.close();
      _database = null;
    }
  }

  @override
  Future<void> deleteUser({required String email}) async {
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

  Future<DBNote> createNote({
    required DBUser owner,
    String title = '',
    String text = '',
  }) async {
    final db = _getDatabaseOrThrow();
    final user = await getUser(email: owner.email);
    if (user != owner) {
      throw DBUserNotFoundException();
    }
    final dateFormatter = DateFormat('yyyy-MM-dd | jj:mm');
    final dateTime = dateFormatter.format(DateTime.now());
    final note = {
      'userId': user.id,
      'title': title,
      'text': text,
      'time': dateTime,
      'isSyncedWithCloud': 0
    };
    final noteId = await db.insert(RepoConstants.noteTableName, note);
    note.addAll({'id': noteId});
    return DBNote.fromDB(map: note);
  }

  Future<void> deleteNote({required DBNote note}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(RepoConstants.noteTableName,
        where: 'id=?', whereArgs: [note.id]);
    if (deletedCount == 0) {
      throw DBNoteNotFoundException();
    }
  }

  Future<int> deleteAllNote() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(RepoConstants.createNoteTable);
  }
}
