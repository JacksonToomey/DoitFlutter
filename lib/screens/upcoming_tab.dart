import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doit_app/model/upcoming_chore.dart';
import 'package:doit_app/screens/upcoming_detail.dart';
import 'package:doit_app/api/api.dart';


DateFormat _format = DateFormat("EEE, MMM d, yyyy");

class _LoadingIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(),
  );
}


class _UpcomingRow extends StatelessWidget {
  final UpcomingChore _chore;
  final Function(String) _onChoreComplete;
  _UpcomingRow(this._chore, this._onChoreComplete);

  Widget _getTile() => ListTile(
    title: Text(
      _chore.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    ),
    subtitle: Text(
      _format.format(_chore.dueDate),
    ),
  );

  Widget _getButton() => ButtonTheme.bar(
    child: ButtonBar(
      children: <Widget>[
        FlatButton(
          child: Text(
            "Doit",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () { _onChoreComplete(_chore.id); },
        )
      ],
    ),
  );

  Widget _getCard() => Card(
    child: Column(
      children: <Widget>[
        _getTile(),
        _getButton(),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Container(
    child: GestureDetector(
      onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpcomingDetailWidget(_chore, _onChoreComplete))); },
      child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: _getCard(),
      ),
    ),
  );
}

class UpcomingTabWidget extends StatefulWidget {
  final Api _api;

  UpcomingTabWidget(this._api);

  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTabWidget> {

  List<UpcomingChore> _chores = [];

  Future<List<UpcomingChore>> _getChoreTask;

  @override
  void initState() {
    _getChoreTask = widget._api.getUpcomingChores();
    _getChoreTask.then((upcoming) {
      setState(() {
        _chores = upcoming;
      });
    });
  }

  Future<void> _onRefresh() async {
    var upcoming = await widget._api.getUpcomingChores();
    setState(() {
      _chores = upcoming;
    });
  }

  _onChoreComplete(String id) {
    widget._api.completeChore(id).then((_) {
      _getChoreTask = widget._api.getUpcomingChores();
      _getChoreTask.then((upcoming) {
        setState(() {
          _chores = upcoming;
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _getChoreTask,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return _LoadingIndicator();
        default:
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) => _UpcomingRow(_chores[index], _onChoreComplete),
              itemCount: _chores.length,
            ),
          );
      }
    }
  );
}