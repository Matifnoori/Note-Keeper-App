import 'package:flutter/material.dart';
import 'package:note_keeper/database/database_helper.dart';
import 'package:note_keeper/screens/note_details.dart';

class HomePage extends StatefulWidget {
    @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;

  String noteTitle;
  String noteContent;

  List _notes = [];

  bool isLoad = false;

  // insert data
  void insertData() async {
    Map<String, dynamic> row = {
      DatabaseHelper.noteTitle: noteTitle,
      DatabaseHelper.noteContent: noteContent
    };
    final id = await dbHelper.insert(row);
    print(id);
  }

  // select all data
  void selectAll() async {
    var allRows = await dbHelper.selectAll();
    allRows.forEach((row) {
      _notes.add(row);
    });
    setState(() {
      allRows.isEmpty ? null : isLoad = !isLoad;
    });
  }

  // select specific value
  void selectSpecific() async {
    var allRows = await dbHelper.selectSpecific('Love');
    print(allRows);
  }

  // delete specific data
  void delete(int noteID) async {
    var id = await dbHelper.deleteData(noteID);
    print(id);
  }

  @override
  void initState() {
    super.initState();
    selectAll();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: isLoad
          ? ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_notes[index]['noteId'].toString()),
            onDismissed: (direction) {
              setState(() {
                delete(_notes[index]['noteId']);
                _notes.removeAt(index);
              });
            },
            background: Container(color: Colors.red,),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 2)),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: ListTile(
                title: Text('${_notes[index]['noteTitle']}'),
                subtitle: Text('${_notes[index]['noteContent']}'),
                trailing: Icon(Icons.delete),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetails(
                          noteID: index + 1,
                          noteTitle: '${_notes[index]['noteTitle']}',
                          noteContent: '${_notes[index]['noteContent']}',
                        ),
                      ));
                },
              ),
            ),
          );
        },
      )
          : Center(
              child: Text('No items'),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            barrierColor: Colors.black.withOpacity(0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            builder: (context) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          noteTitle = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Note Title',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          noteContent = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Note Content',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                        onPressed: () {
                          insertData();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
