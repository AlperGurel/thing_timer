import 'package:flutter/material.dart';

import 'occupation.dart';
import 'occupations.dart';
import 'note_create.dart';

class OccupationDetail extends StatefulWidget {
  final Occupation occupation;
  OccupationDetail({Key key, this.occupation}) : super(key: key);

  @override
  _OccupationDetailState createState() => _OccupationDetailState();
}

class _OccupationDetailState extends State<OccupationDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Route route = MaterialPageRoute(
              builder: (context) => CreateNote(
                    occupation: widget.occupation,
                  ));
          await Navigator.push(context, route);
          setState(() {});
        },
        child: Icon(Icons.note_add),
      ),
      appBar: AppBar(
        title: Text(widget.occupation.name),
      ),
      body: Column(
        children: [
          OccupationRow(
            occupation: widget.occupation,
          ),
          Expanded(
            child: ListView(
              children: widget.occupation.notes.reversed.map(_noteRow).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteRow(String e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(e),
      )),
    );
  }
}
