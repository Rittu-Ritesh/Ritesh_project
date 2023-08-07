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
    fetchNotes();
  }

  void fetchNotes() async {
    arrNotes = await myDB.fetchAllNotes();

    setState(() {});
  }

  void addNotes(String title, String desc) async {
    bool check = await myDB.addNote(NoteModel(title: title, desc: desc));

    if (check) {
      fetchNotes();
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
              height: 120,
              color: Colors.amberAccent,
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Column(
                      children: [
                        Text(arrNotes[index].title,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          arrNotes[index].desc,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          maxLines: null,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.grey),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                              onTap: () {
                                titleController.text = arrNotes[index].title;
                                subtitleController.text = arrNotes[index].desc;
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding:
                                              EdgeInsets.all(16.0).copyWith(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
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
                                                onPressed: () async {
                                                  // Handle the submission of title and subtitle
                                                  String title =
                                                      titleController.text;
                                                  String subtitle =
                                                      subtitleController.text;

                                                  await myDB.updateNotes(
                                                      NoteModel(
                                                          note_id:
                                                              arrNotes[index]
                                                                  .note_id,
                                                          title: title,
                                                          desc: subtitle));
                                                  fetchNotes();
                                                  titleController.clear();
                                                  subtitleController.clear();
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Update'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Icon(Icons.edit_note)),
                          InkWell(
                              onTap: () async {
                                await myDB.deleteNote(arrNotes[index].note_id!);
                                fetchNotes();
                              },
                              child: Icon(Icons.delete_forever_sharp))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0).copyWith(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
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
                      titleController.clear();
                      subtitleController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
