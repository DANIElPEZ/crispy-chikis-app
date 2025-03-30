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
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            email TEXT,
            telefono INTEGER
          );
          ''');
    });
  }

  Future<Map<String, dynamic>> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('user', limit: 1);
    return result.isNotEmpty ? result.first : {};
  }

  Future<void> insertORupdate(Map<String, dynamic> user) async {
    final db = await database;
    final isExist =
        await db.query('user', where: 'id=?', whereArgs: [user['id']]);
    if (isExist.isEmpty) {
      await db.insert('user', user,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      update(user);
    }
  }

  Future<void> update(Map<String, dynamic> user) async {
    final db = await database;
    await db.update('user', user, where: 'id=?', whereArgs: [user['id']]);
  }
}
