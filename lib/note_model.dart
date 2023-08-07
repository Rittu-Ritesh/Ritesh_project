import 'package:flutter_ritesh/dbHelper/DbHelper.dart';

class NoteModel {
  int? note_id;

  String title;

  String desc;

  NoteModel({this.note_id, required this.title, required this.desc});

  //Creating a NoteModel from map Data  fetch data and store inside Model

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
        note_id: map[DbHelper.NOTE_COLUMN_ID],
        title: map[DbHelper.NOTE_COLUMN_TITLE],
        desc: map[DbHelper.NOTE_COLUMN_DESC]);
  }

  Map<String, dynamic> toMap() {
    return {
      DbHelper.NOTE_COLUMN_ID: note_id,
      DbHelper.NOTE_COLUMN_TITLE: title,
      DbHelper.NOTE_COLUMN_DESC: desc
    };
  }
}
