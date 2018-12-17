import 'package:flutter/material.dart';
import 'package:doit_app/model/chore_definition.dart';
import 'package:doit_app/api/api.dart';


class ChoreTabWidget extends StatefulWidget {
  final Api _api;

  ChoreTabWidget(this._api);

  @override
  _ChoreTabState createState() => _ChoreTabState();
}

class _ChoreTabState extends State<ChoreTabWidget> {
  Future<List<ChoreDefinition>> _getChores;

  List<ChoreDefinition> _chores = [];


  @override
  void initState() {
    _getChores = widget._api.getChoreDefinitions();
    _getChores.then((chores) {
      _chores = chores;
    });
  }

  _deleteChore(String id) {
    widget._api.deleteChore(id).then((_) {
      _getChores = widget._api.getChoreDefinitions();
      _getChores.then((chores) {
        setState(() {
          _chores = chores;
        });
      });
    });
  }

  Future<void> _refresh() async {
    _getChores = widget._api.getChoreDefinitions();
    _getChores.then((chores) => setState(() {
      _chores = chores;
    }));
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _getChores,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return Center(
            child: CircularProgressIndicator(),
          );
        default:
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
                itemCount: _chores.length,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  contentPadding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  title: Text(_chores[index].name),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("This will permanently delete this chore and any future tasks associated with it."),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Delete"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteChore(_chores[index].id);
                              },
                            ),
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                    );
                  }),
                ),
            )
          );
      }
    },
  );
}