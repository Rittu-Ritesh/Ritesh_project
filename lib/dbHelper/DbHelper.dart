import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper db = DbHelper._();

  Database? _database;

  Future<Database> getDb() async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDB();
    }
  }

  Future<Database> initDB() async {
    Directory docPath = await getApplicationDocumentsDirectory();

    final path = join(docPath.path, "Note.db");

    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
          "Create table note ( note_id integer primary key autoincrement, title text, desc text)");
    });
  }

  Future<bool> addNote(String title, String desc) async {
    var db = await getDb();

    var rowsEffect = await db.insert('note', {"title": title, "desc": desc});

    if (rowsEffect > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await getDb();

    List<Map<String, dynamic>> notes = await db.query('note');

    return notes;
  }
}
