import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:doit_app/api/api.dart';

class LoginScreenWidget extends StatefulWidget {
  final Api _api;

  LoginScreenWidget(this._api);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreenWidget> {
  bool _checkingStatus = true;
  String _email = "";
  String _password = "";

  Future<bool> _checkLoginStatus() async {
    final storage = new FlutterSecureStorage();
    String email = await storage.read(key: "email");
    if (email == null) {
      return false;
    }

    String password = await storage.read(key: "password");
    if (password == null) {
      return false;
    }

    return _doLogin(email, password);
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus().then((value) {
      if (!value) {
        setState(() {
          _checkingStatus = false;
        });
        return;
      }
      Navigator.of(context).pushReplacementNamed('/tabs');
    });
  }

  _setEmailText(String text) {
    setState(() {
      _email = text;
    });
  }

  _setPasswordText(String text) {
    setState(() {
      _password = text;
    });
  }

  Future<bool> _doLogin([String email="", String password=""]) async {
    if (email == "" || password == "") {
      email = _email;
      password = _password;
    }
    final netfliyResponse = await http.post(
      "https://app.doit.jtoid.com/.netlify/identity/token",
      body: {
        "grant_type": "password",
        "username": email,
        "password": password,
      },
    );

    if (netfliyResponse.statusCode != 200) {
      return false;
    }

    final netlifyData = json.decode(netfliyResponse.body);
    String token = netlifyData["access_token"];

    final doitResponse = await http.post(
      "https://api.doit.jtoid.com/login",
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
      }),
    );

    if (doitResponse.statusCode != 200) {
      return false;
    }
    final appData = json.decode(doitResponse.body);

    final storage = FlutterSecureStorage();
    await storage.write(key: "email", value: email);
    await storage.write(key: "password", value: password);
    await storage.write(key: "token", value: appData["token"]);
    widget._api.setToken(appData["token"]);
    return true;
  }

  _onLogin(BuildContext context) {
    if (_email.trim() == "" || _password.trim() == "") {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid Email/Password")));
      return;
    }

    _doLogin().then((success) {
      if(!success) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid Email/Password")));
        return;
      }

      Navigator.of(context).pushReplacementNamed('/tabs');
    });
  }

  Widget _getBody(BuildContext context) {
    if(_checkingStatus) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
        child: Container(
        height: 300.0,
        alignment: AlignmentDirectional.center,
        margin: EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: Offset(5.0, 10.0),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(height: 25),
            Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                onChanged: _setEmailText,
              ),
            ),
            Container(height: 25),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                onChanged: _setPasswordText,
              ),
            ),
            Container(height: 25),
            RaisedButton(
              child: Text("Login"),
              elevation: 2.0,
              onPressed: () => _onLogin(context),
            ),
          ],
        ),
      )
    );
//
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: _getBody,
      )
    );
  }
}
