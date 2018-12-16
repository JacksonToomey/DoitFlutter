import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/tab_screen.dart';
import 'screens/new_chore_screen.dart';
import 'api/api.dart';

void main() => runApp(MyApp(new Api()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Api _api;

  MyApp(this._api);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doit',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreenWidget(_api),
        '/tabs': (context) => TabScreenWidget(_api),
        '/new': (context) => NewChoreWidget(),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}
