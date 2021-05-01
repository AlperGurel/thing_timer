import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Occupation {
  String documentId;
  String name;
  String description;
  List<String> notes;
  DateTime initialStartTime;
  DateTime lastResumeTime;
  Duration totalDuration;
  bool isTicking;

  Occupation(String name, String description) {
    this.name = name;
    this.description = description;
    this.initialStartTime = DateTime.now();
    isTicking = false;
    this.notes = List<String>();
    this.lastResumeTime = DateTime.now();
    this.totalDuration = Duration(seconds: 0);
  }

  Occupation.fromDocument(QueryDocumentSnapshot doc) {
    this.documentId = doc.id;
    this.name = doc.data()["name"];
    this.description = doc.data()["description"];
    this.notes = doc.data()["notes"].cast<String>();
    this.initialStartTime = doc.data()["initialStartTime"].toDate();
    if (doc.data()["lastResumeTime"] != null) {
      this.lastResumeTime = doc.data()["lastResumeTime"].toDate();
    } else {
      this.lastResumeTime = DateTime.now();
    }
    this.totalDuration = Duration(seconds: doc.data()["totalDuration"]);
    this.isTicking = doc.data()["isTicking"];
  }

  _convertThisToFirebaseObject() {
    return {
      "name": this.name,
      "description": this.description,
      "notes": this.notes,
      "initialStartTime": this.initialStartTime,
      "lastResumeTime": this.lastResumeTime,
      "totalDuration": this.totalDuration.inSeconds,
      "isTicking": this.isTicking
    };
  }

  continueTimer() {
    this.lastResumeTime = DateTime.now();
    isTicking = true;
    saveToFirebase();
  }

  pauseTimer() {
    isTicking = false;
    this.totalDuration =
        this.totalDuration + DateTime.now().difference(lastResumeTime);
    saveToFirebase();
  }

  getDateAsString() {
    return this.initialStartTime.day.toString() +
        "/" +
        this.initialStartTime.month.toString() +
        "/" +
        this.initialStartTime.year.toString();
  }

  durationToString(Duration d) {
    String hours = d.inHours > 0 ? d.inHours.toString() + " hr " : "";
    String minutes =
        d.inMinutes > 0 ? d.inMinutes.remainder(60).toString() + " min " : "";
    String seconds = d.inSeconds.remainder(60).toString() + " sec";
    return hours + minutes + seconds;
  }

  getTotalDurationAsString() {
    if (isTicking) {
      var totDuration =
          this.totalDuration + DateTime.now().difference(lastResumeTime);
      return durationToString(totDuration);
    } else {
      return durationToString(this.totalDuration);
    }
  }

  getCurrentDurationAsString() {
    if (!this.isTicking) {
      return durationToString(Duration(seconds: 0));
    }
    return durationToString(DateTime.now().difference(lastResumeTime));
  }

  addNote(String s) {
    this.notes.add(s);
  }

  Future<void> saveToFirebase() async {
    var db = FirebaseFirestore.instance;
    var data = _convertThisToFirebaseObject();
    try {
      if (this.documentId != null) {
        await db.collection("occupations").doc(this.documentId).update(data);
        return;
      } else {
        await db.collection("occupations").add(data);
        return;
      }
    } catch (err) {
      debugPrint("Kayıt edilirken bir hata oluştu: " + err.toString());
      throw (err);
    }
  }
}
