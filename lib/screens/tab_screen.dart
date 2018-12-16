import 'package:flutter/material.dart';
import 'package:doit_app/screens/upcoming_tab.dart';
import 'package:doit_app/screens/chore_tab.dart';
import 'package:doit_app/api/api.dart';


class TabScreenWidget extends StatelessWidget {
  final Api _api;

  TabScreenWidget(this._api);

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Builder(builder: _getBody),
        appBar: AppBar(
          title: Text("Doit"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed("/new");
              },
            )
          ],
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.calendar_today)),
            Tab(icon: Icon(Icons.list)),
          ]),
        ),
      ),
    );

  }

  Widget _getBody(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        UpcomingTabWidget(_api),
        ChoreTabWidget(_api),
      ],
    );
  }
}