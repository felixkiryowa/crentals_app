import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';
import 'dart:convert';
import 'dart:async';

class NetworkUtils {

  static final String developmentHost = 'http://10.0.2.2:8000';


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
//      print(responseJson);
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