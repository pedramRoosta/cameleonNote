class DBNote {
  const DBNote({
    required int id,
    required int userId,
    required String title,
    required String text,
    required String time,
    required bool isSyncedWithCloud,
  })  : _id = id,
        _userId = userId,
        _title = title,
        _text = text,
        _time = time,
        _isSyncedWithCloud = isSyncedWithCloud;
  final int _id;
  final int _userId;
  final String _title;
  final String _text;
  final String _time;
  final bool _isSyncedWithCloud;

  int get id => _id;
  int get userId => _userId;
  String get title => _title;
  String get text => _text;
  String get time => _time;
  bool get isSyncedWithCloud => _isSyncedWithCloud;

  factory DBNote.fromDB({required Map<String, Object?> map}) => DBNote(
        id: map['id'] as int,
        userId: map['userId'] as int,
        title: map['title'] as String,
        text: map['text'] as String,
        time: map['time'] as String,
        isSyncedWithCloud: (map['syncedWithCloud'] as int) == 1 ? true : false,
      );

  @override
  String toString() {
    return 'Note, id=$_id,userId=$_userId,title=$_title,text=$_text,time=$_time,syncedWithCloud=$_isSyncedWithCloud';
  }

  @override
  bool operator ==(covariant DBNote other) => _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}
