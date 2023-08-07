import 'dart:io';

import 'package:flutter_ritesh/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper db = DbHelper._();

  Database? _database;

  static final NOTE_TABLE = "note";
  static final NOTE_COLUMN_ID = "note_id";
  static final NOTE_COLUMN_TITLE = "title";
  static final NOTE_COLUMN_DESC = "desc";

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
          "Create table $NOTE_TABLE ( $NOTE_COLUMN_ID integer primary key autoincrement, $NOTE_COLUMN_TITLE text, $NOTE_COLUMN_DESC text)");
    });
  }

  Future<bool> addNote(NoteModel note) async {
    var db = await getDb();

    var rowsEffect = await db.insert(NOTE_TABLE, note.toMap());

    if (rowsEffect > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<NoteModel>> fetchAllNotes() async {
    var db = await getDb();

    List<Map<String, dynamic>> notes = await db.query(NOTE_TABLE);

    List<NoteModel> listNotes = [];

    for (Map<String, dynamic> note in notes) {
      NoteModel model = NoteModel.fromMap(note);
      listNotes.add(model);
    }
    print(listNotes);

    return listNotes;
  }
}
