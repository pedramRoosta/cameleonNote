import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cameleon_note/services/cloud/constant.dart';

class CloudNote {
  const CloudNote({
    required this.documentId,
    required this.userId,
    required this.title,
    required this.text,
    required this.time,
  });
  final String documentId;
  final String userId;
  final String title;
  final String text;
  final String time;

  factory CloudNote.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final snapshotData = snapshot.data();
    return CloudNote(
      documentId: snapshot.id,
      userId: snapshotData[CloudConstants.userIdField],
      title: snapshotData[CloudConstants.titleField],
      text: snapshotData[CloudConstants.textField],
      time: snapshotData[CloudConstants.timeField],
    );
  }
}
