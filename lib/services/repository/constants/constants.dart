abstract class RepoConstants {
  static const userTableName = 'user';
  static const noteTableName = 'note';

  static const createNoteTable = '''
         CREATE TABLE IF NOT EXISTS "$noteTableName" (
            "id"	INTEGER NOT NULL,
            "userId"	INTEGER NOT NULL,
            "title"	TEXT,
            "text"	TEXT,
            "time"	TEXT,
            "isSyncedWithCloud"	INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY("id" AUTOINCREMENT),
            FOREIGN KEY("userId") REFERENCES "User"("id")
          ); ''';

  static const createUserTable = '''
          CREATE TABLE IF NOT EXISTS "$userTableName" (
            "id"	INTEGER NOT NULL,
            "email"	TEXT NOT NULL UNIQUE,
            PRIMARY KEY("id")
          ); ''';
}
