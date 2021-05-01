import 'package:flutter/material.dart';
import 'package:thing_timer/occupation/occupation_detail.dart';

class CreateNote extends StatefulWidget {
  final occupation;

  CreateNote({Key key, this.occupation}) : super(key: key);

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _textInput(),
            _sendButton(),
          ],
        ),
      ),
    );
  }

  _textInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: noteController,
        validator: (value) {
          if (value.trim().isEmpty) {
            return "Enter a note";
          }
          return null;
        },
        maxLines: 2,
        decoration: InputDecoration(
          labelText: "Enter a new note",
        ),
      ),
    );
  }

  _sendButton() {
    return FlatButton(
      child: Text("ADD"),
      color: Colors.redAccent,
      textColor: Colors.white,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          widget.occupation.addNote(noteController.text.trim());
          await widget.occupation.saveToFirebase();
          Route route = MaterialPageRoute(
              builder: (context) => OccupationDetail(
                    occupation: widget.occupation,
                  ));
          Navigator.pop(context);
        }
      },
    );
  }
}
