import 'package:flutter/material.dart';

import 'dbHelper/DbHelper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DbHelper myDB;
  List<Map<String, dynamic>> arrNotes = [];

  @override
  void initState() {
    super.initState();
    myDB = DbHelper.db;
    addNotes();
  }

  void addNotes() async {
    bool check = await myDB.addNote("Flutter", "new Flutter note");

    if (check) {
      arrNotes = await myDB.fetchAllNotes();

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: arrNotes.length,
          itemBuilder: (_, index) {
            return ListTile(
              title: Text('${arrNotes[index]['title']}'),
              subtitle: Text('${arrNotes[index]['desc']}'),
            );
          }),
    );
  }
}
