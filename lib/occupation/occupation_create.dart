import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thing_timer/occupation/occupation.dart';
import 'package:thing_timer/occupation/occupations.dart';
import 'package:thing_timer/common.dart';

class OccupationCreate extends StatefulWidget {
  @override
  _OccupationCreateState createState() => _OccupationCreateState();
}

class _OccupationCreateState extends State<OccupationCreate> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Occupation"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 30, right: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [_titleField(), _descriptionField(), _createButton()],
              ),
            ),
          ),
        ));
  }

  _titleField() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "Enter a title";
        }
        return null;
      },
      controller: titleController,
      decoration: InputDecoration(hintText: "Title"),
    );
  }

  _descriptionField() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "Enter a description";
        }
        return null;
      },
      controller: descriptionController,
      decoration: InputDecoration(hintText: "Description"),
    );
  }

  _createButton() {
    return Builder(
      builder: (context) => FlatButton(
        child: Text("CREATE"),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            var occupation =
                Occupation(titleController.text, descriptionController.text);
            try {
              await occupation.saveToFirebase();
              _onSaveComplete(context);
            } catch (err) {
              _onSaveError(context, err);
            }
          }
        },
      ),
    );
  }

  FutureOr _onSaveComplete(BuildContext context) {
    showToast(context, "Occupation created");
    Route route = MaterialPageRoute(builder: (context) => Occupations());
    FocusScope.of(context).unfocus();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  FutureOr _onSaveError(BuildContext context, error) {
    debugPrint(error.toString());
    showToast(context, "Error on creation");
  }
}
