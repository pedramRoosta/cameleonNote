import 'package:cameleon_note/helpers/date_time.dart';
import 'package:cameleon_note/services/cloud/cloud_exception.dart';
import 'package:cameleon_note/services/cloud/cloud_note.dart';
import 'package:cameleon_note/services/cloud/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStorage {
  final notes =
      FirebaseFirestore.instance.collection(CloudConstants.noteCollection);
  Stream<Iterable<CloudNote>> allNotes({required String userId}) {
    return notes.snapshots().map((event) => event.docs
        .map((doc) => CloudNote.fromSnapshot(doc))
        .where((note) => note.userId == userId));
  }

  void createNewNote({
    required String userId,
    String title = '',
    String text = '',
  }) async {
    await notes.add({
      CloudConstants.userIdField: userId,
      CloudConstants.titleField: title,
      CloudConstants.textField: text,
      CloudConstants.timeField: Helper.toDateFormat(date: DateTime.now()),
    });
  }

  Future<void> updateNote({
    required String documentId,
    String? title,
    String? text,
  }) async {
    try {
      await notes.doc(documentId).update({
        CloudConstants.textField: text,
        CloudConstants.titleField: title,
      });
    } catch (_) {
      throw CloudCouldNotUpdateNoteExc();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CloudCouldNotDeleteNotesExc();
    }
  }

  Future<Iterable<CloudNote>> getAllNote({required String userId}) async {
    try {
      return await notes
          .where(CloudConstants.userIdField, isEqualTo: userId)
          .get()
          .then(
            (value) => value.docs.map((doc) {
              final docData = doc.data();
              return CloudNote(
                documentId: doc.id,
                userId: docData[CloudConstants.userIdField] as String,
                title: docData[CloudConstants.titleField] as String,
                text: docData[CloudConstants.textField] as String,
                time: docData[CloudConstants.timeField] as String,
              );
            }),
          );
    } catch (e) {
      throw CloudCouldNotGetAllNotesExc();
    }
  }
}
