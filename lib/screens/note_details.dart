import 'package:flutter/material.dart';
import 'package:note_keeper/database/database_helper.dart';

class NoteDetails extends StatefulWidget {

  final int noteID;
  final String noteTitle;
  final String noteContent;

  const NoteDetails({this.noteID, this.noteTitle, this.noteContent});

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {

  final dbHelper = DatabaseHelper.instance;

  var titleController = TextEditingController();
  final contentController = TextEditingController();

  void update(String updateTitle, String updateContent) async{
    var row = await dbHelper.update(widget.noteID, updateTitle, updateContent);
    print(row);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteTitle),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: widget.noteTitle,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: widget.noteContent,
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
                onPressed: (){
                  update(titleController.text, contentController.text);
                  Navigator.pop(context);
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.redAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
