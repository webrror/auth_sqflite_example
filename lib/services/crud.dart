import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Crud {
  // Database related oeprations

  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    // id - Unique ID
    // email - email of user
    // password - encrypted* password of user
    // createdAt - time at which note was created
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'authex.db',
      version: 1,
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  // Add, Update and Delete operations

  // Users
  static Future<bool> users() async {
    final db = await Crud.db();
    final List<Map<String, dynamic>> details = await db.query(
      'users',
    );
    if (details.isNotEmpty) {
      return true;
    }
    return false;
  }

  // Login
  static Future<List<Map<String, dynamic>>> login(
      String email, String password) async {
    final db = await Crud.db();
    final List<Map<String, dynamic>> details = await db.rawQuery(
        'SELECT * FROM users WHERE email=? and password=?', [email, password]);
    return details;
  }

  // Signup
  static Future<int> signup(String email, String password) async {
    final db = await Crud.db();
    final dataToBeInserted = {'email': email, 'password': password};
    final id = await db.insert('users', dataToBeInserted);
    return id;
  }

  // Delete account
  static Future<void> deleteNote(int id) async {
    final db = await Crud.db();
    try {
      await db.delete('notes', where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Something went wrong");
    }
  }
}
