import 'dart:async';
import '../utils/auth_utils.dart';
import '../utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';

  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences _sharedPreferences;
  var _authToken, _id, _firstname, _lastname, _homeResponse, mobilenoorEmailKey;

  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    var id = _sharedPreferences.getInt(AuthUtils.userIdKey);
    var firstname = _sharedPreferences.getString(AuthUtils.firstNameKey);
    var lastname = _sharedPreferences.getString(AuthUtils.lastNameKey);
    var mobilenoorEmailKey = _sharedPreferences.getString(AuthUtils.mobilenoorEmailKey);

    print(authToken);

    _fetchHome(authToken);

    setState(() {
      _authToken = authToken;
      _id = id;
      _firstname = firstname;
      _lastname = lastname;
    });

    if(_authToken == null) {
      _logout();
    }
  }

  _fetchHome(String authToken) async {
    var responseJson = await NetworkUtils.fetch(authToken, '/api/v1/user');

    if(responseJson == null) {

      NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

    } else if(responseJson == 'NetworkError') {

      NetworkUtils.showSnackBar(_scaffoldKey, null);

    } else if(responseJson['error'] != null) {

      _logout();

    }

    setState(() {
      _homeResponse = responseJson.toString();
    });
  }

  _logout() {
    NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Home'),
        ),
        body: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    '$_firstname' + '$_lastname',
                    style: new TextStyle(
                        fontSize: 24.0,
                        color: Colors.grey.shade700
                    ),
                  ),
                ),
                new MaterialButton(
                    color: Theme.of(context).primaryColor,
                    child: new Text(
                      'Logout',
                      style: new TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: _logout
                ),
              ]
          ),
        )
    );
  }

}