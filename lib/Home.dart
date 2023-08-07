import 'package:flutter/material.dart';
import 'package:flutter_ritesh/note_model.dart';

import 'dbHelper/DbHelper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DbHelper myDB;
  List<NoteModel> arrNotes = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myDB = DbHelper.db;
  }

  void addNotes(String title, String desc) async {
    bool check = await myDB.addNote(NoteModel(title: title, desc: desc));

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
            return Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                height: 150,
                color: Colors.amberAccent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            arrNotes[index].title,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.delete_forever_sharp,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(arrNotes[index].desc,
                        style: TextStyle(color: Colors.grey, fontSize: 16))
                  ],
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: subtitleController,
                  decoration: InputDecoration(
                    labelText: 'Subtitle',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle the submission of title and subtitle
                    String title = titleController.text;
                    String subtitle = subtitleController.text;
                    // You can do whatever you want with the title and subtitle here
                    // For example, save them in variables, update state, etc.
                    print('Title: $title');
                    print('Subtitle: $subtitle');
                    addNotes(title, subtitle);
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );
        });
  }
}
