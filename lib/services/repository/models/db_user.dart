class DBUser {
  final int _id;
  final String _email;

  int get id => _id;
  String get email => _email;

  const DBUser({
    required int id,
    required String email,
  })  : _id = id,
        _email = email;

  factory DBUser.fromDB(Map<String, Object?> map) {
    return DBUser(
      id: map["id"] as int,
      email: map['email'] as String,
    );
  }

  @override
  String toString() {
    return "Person, id=$_id, email=$_email";
  }

  @override
  bool operator ==(covariant DBUser other) => _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}
