abstract class IRepository {
  String get dbName;
  Future<void> open();
  Future<void> close();
  Future<void> deleteUser({required String email});
}
