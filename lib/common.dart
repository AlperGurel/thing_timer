import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  final String info;

  const InfoScreen({Key key, this.info}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Durum"),
      ),
      body: Center(child: Text(info)),
    );
  }
}

class InnerInfoScreen extends StatelessWidget {
  final String info;

  const InnerInfoScreen({Key key, this.info}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(info));
  }
}

showToast(BuildContext context, String message) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 3),
  ));
}
