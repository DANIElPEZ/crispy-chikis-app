import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? localDatabase;

  Future<Database> get database async {
    if (localDatabase != null) return localDatabase!;

    localDatabase = await initDatabase();
    return localDatabase!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'User.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
          CREATE TABLE IF NOT EXISTS user(
            usuario_id INTEGER PRIMARY KEY,
            nombre TEXT,
            email TEXT,
            telefono TEXT
          );
          ''');
    });
  }

  Future<Map<String, dynamic>> getUser() async {
    final db = await database;
    final result = await db.query('user', limit: 1);
    return result.isNotEmpty ? result.first:{};
  }

  Future<void> insertORupdate(Map<String, dynamic> user) async {
    final db = await database;
    final result =await getUser();
    if (result.isNotEmpty) {
      await db.update('user', user, where: 'email=?', whereArgs: [user['email']]);
      return;
    }
    await db.insert('user', user,
          conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteUser()async{
    final db = await database;
    await db.delete('user');
  }
}
