import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thing_timer/common.dart';
import 'package:thing_timer/occupation/occupation_create.dart';
import 'package:thing_timer/occupation/occupation.dart';
import 'occupation_detail.dart';

class Occupations extends StatefulWidget {
  Occupations({Key key}) : super(key: key);

  @override
  _OccupationsState createState() => _OccupationsState();
}

class _OccupationsState extends State<Occupations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Occupations"),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            await setState(() {});
            return;
          },
          child: FutureBuilder(
            future: _fetchOccupations(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Occupation>> snapshot) {
              if (snapshot.hasError) {
                return InnerInfoScreen(
                  info: "Could not fetch",
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return _rows(snapshot.data);
              }
              return InnerInfoScreen(
                info: "Fetching occupations",
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Route route =
              MaterialPageRoute(builder: (context) => OccupationCreate());
          await Navigator.push(context, route);
          setState(() {});
        },
      ),
    );
  }

  Future<List<Occupation>> _fetchOccupations() async {
    var db = FirebaseFirestore.instance;
    List<Occupation> occupations = List();
    try {
      var snapshot = await db.collection("occupations").get();
      snapshot.docs.forEach((doc) {
        occupations.add(Occupation.fromDocument(doc));
      });
      return occupations;
    } catch (err) {
      print("Occupations çekilemedi. " + err.toString());
    }
  }

  Widget _rows(List<Occupation> data) {
    return ListView(
      children: data.map(_rowm).toList(),
    );
  }

  Widget _rowm(Occupation e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: OccupationRow(
          occupation: e,
          canBeTapped: true,
        ),
      ),
    );
  }
}

class OccupationRow extends StatefulWidget {
  final Occupation occupation;
  final bool canBeTapped;
  OccupationRow({Key key, this.occupation, this.canBeTapped = false})
      : super(key: key);

  @override
  _OccupationRowState createState() => _OccupationRowState();
}

class _OccupationRowState extends State<OccupationRow> {
  bool isTicking = false;
  Timer timer;

  @override
  void initState() {
    super.initState();
    isTicking = widget.occupation.isTicking;
    if (isTicking) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateView());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.canBeTapped
          ? () async {
              Route route = MaterialPageRoute(
                  builder: (context) => OccupationDetail(
                        occupation: widget.occupation,
                      ));
              await Navigator.push(context, route);
              //this code is not on tap. It is after returning
              setState(() {
                isTicking = widget.occupation.isTicking;
                timer = Timer.periodic(
                    Duration(seconds: 1), (Timer t) => _updateView());
              });
            }
          : () {},
      child: _row(widget.occupation),
    );
  }

  Widget _row(Occupation e) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _content(e),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: _handleStateSwitch,
              child: Icon(
                isTicking ? Icons.pause : Icons.play_arrow,
                size: 50,
                color: Colors.pinkAccent,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _content(Occupation e) {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(e),
          _description(e),
          _totalTime(e),
          _currentTime(e),
        ],
      ),
    );
  }

  Widget _header(Occupation e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            e.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Row(
            children: [
              Text(
                "Beginning: ",
                style: TextStyle(color: Colors.black45),
              ),
              Text(
                e.getDateAsString(),
                style: TextStyle(color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _description(Occupation e) {
    return Text(
      e.description,
      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
    );
  }

  _totalTime(Occupation e) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Text(
            "Total: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(e.getTotalDurationAsString()),
        ],
      ),
    );
  }

  _currentTime(Occupation e) {
    return Row(
      children: [
        Text("Current: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(e.getCurrentDurationAsString()),
      ],
    );
  }

  void _handleStateSwitch() {
    setState(() {
      isTicking = !isTicking;
      if (isTicking) {
        timer =
            Timer.periodic(Duration(seconds: 1), (Timer t) => _updateView());
      } else {
        timer?.cancel();
      }
    });
    //if continue
    if (isTicking) {
      widget.occupation.continueTimer();
    }
    if (!isTicking) {
      widget.occupation.pauseTimer();
    }
  }

  void _updateView() {
    setState(() {});
  }
}
