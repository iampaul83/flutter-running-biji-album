import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/biji/biji.dart' as biji;
import 'package:flutter_app/biji/biji.dart';

class BijiInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BijiInfoPageState();
}
class _BijiInfoPageState extends State<BijiInfoPage> {

  @override
  Widget build(BuildContext context) {
    print('BijiInfoPage.build');
    return Scaffold(
      appBar: AppBar(
        title: Text("Biji Info"),
      ),
      body: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Go back!'),
      ),
    );
  }

}
