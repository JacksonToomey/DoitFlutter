import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doit_app/model/upcoming_chore.dart';
import 'package:doit_app/model/chore_definition.dart';


class Api {
  String _token = "";

  setToken(String token) {
    this._token = token;
  }

  String getToken() {
    return _token;
  }

  _resetToken() async {
    final storage = new FlutterSecureStorage();
    String email = await storage.read(key: "email");
    String password = await storage.read(key: "password");
    final netlifyResponse = await http.post(
      "https://app.doit.jtoid.com/.netlify/identity/token",
      body: {
        "grant_type": "password",
        "username": email,
        "password": password,
      }
    );
    final netlifyData = json.decode(netlifyResponse.body);
    String token = netlifyData["access_token"];
    final doitResponse = await http.post(
      "https://api.doit.jtoid.com/login",
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );
    final appData = json.decode(doitResponse.body);
    this._token = appData["token"];
  }

  Future<List<UpcomingChore>> getUpcomingChores() async {
    var resp = await http.get(
      "https://api.doit.jtoid.com/api/upcoming",
      headers: {
        "Authorization": "Bearer ${this._token}",
      },
    );
    if(resp.statusCode == 401 || resp.statusCode == 403) {
      await this._resetToken();
      resp = await http.get(
        "https://api.doit.jtoid.com/api/upcoming",
        headers: {
          "Authorization": "Bearer ${this._token}",
        },
      );
    }
    List<dynamic> data = json.decode(resp.body);

    List<UpcomingChore> upcoming = data.map((item) => UpcomingChore.fromJson(item)).toList();
    return upcoming;
  }

  Future<List<ChoreDefinition>> getChoreDefinitions() async {
    var resp = await http.get(
      "https://api.doit.jtoid.com/api/chores",
      headers: {
        "Authorization": "Bearer ${this._token}",
      },
    );
    if(resp.statusCode == 401 || resp.statusCode == 403) {
      await this._resetToken();
      resp = await http.get(
        "https://api.doit.jtoid.com/api/chores",
        headers: {
          "Authorization": "Bearer ${this._token}",
        },
      );
    }
    List<dynamic> data = json.decode(resp.body);

    List<ChoreDefinition> chores = data.map((item) => ChoreDefinition.fromJson(item)).toList();
    return chores;
  }

  Future<void> completeChore(String id) async {
    var resp = await http.post(
      "https://api.doit.jtoid.com/api/upcoming/${id}",
      headers: {
        "Authorization": "Bearer ${this._token}",
      },
    );
    if (resp.statusCode == 401 || resp.statusCode == 403) {
      await this._resetToken();
      resp = await http.post(
        "https://api.doit.jtoid.com/api/upcoming/${id}",
        headers: {
          "Authorization": "Bearer ${this._token}",
        },
      );
    }
  }

    Future<void> deleteChore(String id) async {
      var resp = await http.delete(
        "https://api.doit.jtoid.com/api/chores/${id}",
        headers: {
          "Authorization": "Bearer ${this._token}",
        },
      );
      if(resp.statusCode == 401 || resp.statusCode == 403) {
        await this._resetToken();
        resp = await http.delete(
          "https://api.doit.jtoid.com/api/chores/${id}",
          headers: {
            "Authorization": "Bearer ${this._token}",
          },
        );
      }

    return;
  }
}