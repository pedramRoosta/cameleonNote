abstract class CloudBaseException implements Exception {
  String get message => 'Unknown exception occured.';
}

class CloudCouldNotCreateNoteExc extends CloudBaseException {
  @override
  String get message => 'Could not create note.';
}

class CloudCouldNotGetAllNotesExc extends CloudBaseException {
  @override
  String get message => 'Could not get all notes.';
}

class CloudCouldNotUpdateNoteExc extends CloudBaseException {
  @override
  String get message => 'Could not update note.';
}

class CloudCouldNotDeleteNotesExc extends CloudBaseException {
  @override
  String get message => 'Could not delete note.';
}
