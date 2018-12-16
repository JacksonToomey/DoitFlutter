import 'package:flutter/material.dart';


class NewChoreWidget extends StatefulWidget {

  @override
  _NewChoreWidgetState createState() => _NewChoreWidgetState();
}

class _NewChoreWidgetState extends State<NewChoreWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Chore"),
      ),
      body: Builder(builder: _getBody),
    );
  }

  Widget _getBody(BuildContext context) => Text("New Chore");
}