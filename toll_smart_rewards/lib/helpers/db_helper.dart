import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'toll_rewards.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT,
            first_name TEXT,
            last_name TEXT,
            points INTEGER
          )
        ''');

        await db.insert('users', {
          'username': 'reia',
          'password': '1326',
          'first_name': 'Reia',
          'last_name': 'Menezes',
          'points': 150,
        });
      },
    );
  }

  static Future<Map<String, dynamic>?> authenticateUser(
    String username,
    String password,
  ) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> updatePoints(String username, int newPoints) async {
    final db = await database;
    await db.update(
      'users',
      {'points': newPoints},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  static Future<bool> doesUserExist(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  static Future<bool> updatePassword(
    String username,
    String newPassword,
  ) async {
    final db = await database;
    final result = await db.update(
      'users',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
    return result > 0; // true if a row was updated
  }
}
