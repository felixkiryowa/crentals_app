import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';

class NetworkUtils {

  static final String developmentHost = 'http://127.0.0.1:8000';

  static dynamic authenticateUser(String email, String password) async {
    var uri = developmentHost + AuthUtils.endPoint;

    try {
      final response = await http.post(
          uri,
          body: {
            'mobilenoorEmail': email,
            'password': password
          }
      );

      final responseJson = json.decode(response.body);
      return responseJson;

    } catch (exception) {
      print(exception);
      if(exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static logoutUser(BuildContext context, SharedPreferences prefs) {
    prefs.setString(AuthUtils.authTokenKey, null);
//    prefs.setInt(AuthUtils.userIdKey, null);
//    prefs.setString(AuthUtils.nameKey, null);
    Navigator.of(context).pushReplacementNamed('/');
  }

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(message ?? 'You are offline'),
        )
    );
  }

  static fetch(var authToken, var endPoint) async {
    var uri = developmentHost + endPoint;

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': authToken
        },
      );

      final responseJson = json.decode(response.body);
      return responseJson;

    } catch (exception) {
      print(exception);
      if(exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
}