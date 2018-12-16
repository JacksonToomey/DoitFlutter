import 'package:flutter/material.dart';
import 'package:doit_app/model/upcoming_chore.dart';

class UpcomingDetailWidget extends StatelessWidget {
  final UpcomingChore _chore;
  final Function(String) _onDonePress;
  UpcomingDetailWidget(this._chore, this._onDonePress);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Upcoming Details"),
    ),
    body: Builder(builder: (context) => Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _chore.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34.0,
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Text(_chore.details),
            Padding(padding: EdgeInsets.all(10)),
            RaisedButton(
              child: Text("Doit"),
              onPressed: () {
                  _onDonePress(_chore.id);
                  Navigator.of(context).pop();
                },
            ),
            Padding(padding: EdgeInsets.all(10)),
          ],
        ),
      ),
    ))
  );
}