import 'package:flutter/material.dart';
import 'package:note_apk/data/local/db_helper.dart';

class NewNotes extends StatefulWidget {
  final String nTitle;
  final String nDescription;
  final int sNo; // Note ID (for updating)

  NewNotes({required this.nTitle, required this.nDescription, required this.sNo});

  @override
  State<NewNotes> createState() => _NewNotesState();
}

class _NewNotesState extends State<NewNotes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    titleController.text = widget.nTitle; // Set initial values
    descController.text = widget.nDescription;
  }

  void updateNote() async {
    String updatedTitle = titleController.text;
    String updatedDesc = descController.text;

    if (updatedTitle.isNotEmpty && updatedDesc.isNotEmpty) {
      bool check = await dbRef!.updateNote(
        mTitle: updatedTitle,
        mDesc: updatedDesc,
        sno: widget.sNo,
      );

      if (check) {
        Navigator.pop(context, true); // Return success response
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        title: Text("Edit Note", style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: (){
                updateNote;
              }, // Call update function
              icon: Icon(Icons.check, color: Colors.white),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descController,
              maxLines: 6,
              style: TextStyle(color: Colors.white, fontSize: 18),

            ),
          ],
        ),
      ),
    );
  }
}
