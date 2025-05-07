import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    //Check if database is already initialized
    if (_database != null) return _database!;
    //Initialize database if not already initialized
    _database = await _initDatabase();
    return _database!;
  }

  ///Initializes the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');

    return await openDatabase(
      path,
      version: 1,
      onUpgrade: (Database db, int oldVersion, int newVersion){
        debugPrint("Database onUpgrade");
      },

      onCreate: (Database db, int version) async {
        debugPrint("Database onCreateCalled");

        ///3.  CREATE TABLE : USER
        await db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT, emailId TEXT, password TEXT)');
      },
    );
  }

  ///INSERT USER VALUE INTO TABLE
  Future<void> insertUser({
    required int id,
    required String firstName,
    required String lastName,
    required String emailId,
    required String password,
  }) async {
    final db = await database;

    ///SQL SYNTAX
    await db.insert(
        'users',
        {
          'id': id,
          'firstName': firstName,
          'lastName': lastName,
          'emailId': emailId,
          'password': password
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>> getUserList() async {
    final db = await database;
    return await db.query("users", limit: 10);
  }

  ///UPDATE USER
  Future<void> updateUser({required int id, required String emailId, required String password}) async {
    final db = await database;
    await db.update(
      'users',
      {'emailId': emailId, 'password': password},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///DELETE USER
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

}
