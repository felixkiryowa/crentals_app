import 'dart:convert';
import 'package:crentals_app/components/error_box.dart';
import 'package:flutter/material.dart';
import '../utils/network_utils.dart';
import '../utils/auth_utils.dart';
import '../validators/email_validator.dart';
import '../dasboard/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './signup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:async';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String uri = 'http://10.0.2.2:8000/api/v1/';
  SharedPreferences _sharedPreferences;
  bool _isHidden = true;
  bool _isLoading = false;
  bool _isError = false;
  bool _isLoggedIn = false;
  String _errorText, _emailOrPhoneNumberError, _passwordError;

  final _emailOrPhoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  _saveFacebookUser(name, email, provider, provider_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = uri + 'authenticate/facebook';
    Map<String, String> headers = {"Content-type": "application/json"};
    var body = json.encode({
      "name": name,
      "email": email,
      "provider": provider,
      "provider_id": provider_id
    });

    try {
      final response =
          await http.post(Uri.encodeFull(url), headers: headers, body: body);

      final responseJson = json.decode(response.body);
      prefs.setString('facebook_id', responseJson["user"]["provider_id"]);
      prefs.setString('provider_name', responseJson["user"]["provider"]);
      prefs.setString(
          'facebook_user',
          responseJson["user"]["firstname"] +
              " " +
              responseJson["user"]["lastname"]);
      print(prefs.getString('facebook_user'));

      if (responseJson == null) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
      } else if (responseJson == 'NetworkError') {
        NetworkUtils.showSnackBar(_scaffoldKey, null);
      } else {
        /**
         * Set the auth token in preferences
         */
//        AuthUtils.insertDetails(_sharedPreferences, responseJson);
//        AuthUtils.get_logged_user(responseJson['auth_token']);
        /**
         * Removes stack and start with the new page.
         * In this case on press back on HomePage app will exit.
         *
         * **/
//
//        Navigator.pushReplacement(context,
//            MaterialPageRoute(builder: (BuildContext ctx) => HomePage()));

      }
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  _loginWithFB() async {
    final result = await facebookLogin.logIn(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);

        var name = profile["name"];
        var email = profile["email"];
        var provider = "FACEBOOK";
        var provider_id = profile["id"];
        _saveFacebookUser(name, email, provider, provider_id);
        break;
      case FacebookLoginStatus.cancelledByUser:
        NetworkUtils.showSnackBar(_scaffoldKey, 'Login cancelled by user');
        break;
      case FacebookLoginStatus.error:
        NetworkUtils.showSnackBar(_scaffoldKey, result.errorMessage);
        break;
    }
  }

//Function to login a user using google
  _loginWithGoogle() async {
    try {
      await _googleSignIn.signIn();
      print(_googleSignIn.currentUser);

      setState(() {
        _isLoggedIn = true;
      });
    } catch (err) {
      print(err);
    }
  }

  //Function to logout user logged in using google
  _googleLogout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    if (authToken != null) {
      Navigator.of(_scaffoldKey.currentContext)
          .pushReplacementNamed(HomePage.routeName);
    }
  }

  _authenticateUser() async {
    _showLoading();
    if (_validateLoginInputs()) {
      String url = uri + 'authenticate';
      Map<String, String> headers = {"Content-type": "application/json"};
      var body = json.encode({
        "mobilenoorEmail": _emailOrPhoneNumberController.text,
        "password": _passwordController.text
      });

      try {
        final response =
            await http.post(Uri.encodeFull(url), headers: headers, body: body);

        final responseJson = json.decode(response.body);
        print(responseJson);

        if (responseJson == null) {
          NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
        } else if (responseJson == 'NetworkError') {
          NetworkUtils.showSnackBar(_scaffoldKey, null);
        } else if (responseJson['error'] == 'invalid_credentials') {
          NetworkUtils.showSnackBar(_scaffoldKey,
              'The Email or Phone Number you\'ve entered does not match any account.');
        } else {
          /**
           * Set the auth token in preferences
           */
          AuthUtils.insertDetails(_sharedPreferences, responseJson);
          AuthUtils.get_logged_user(responseJson['auth_token']);
          /**
           * Removes stack and start with the new page.
           * In this case on press back on HomePage app will exit.
           *
           * **/

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext ctx) => HomePage()));
        }
        _hideLoading();
      } catch (exception) {
        print(exception);
        if (exception.toString().contains('SocketException')) {
          return 'NetworkError';
        } else {
          return null;
        }
      }
    } else {
      setState(() {
        _isLoading = false;
        _emailOrPhoneNumberError;
        _passwordError;
      });
    }
  }

  _validateLoginInputs() {
    bool valid = true;

    if (_emailOrPhoneNumberController.text.isEmpty) {
      valid = false;
      _emailOrPhoneNumberError = "Email can't be blank!";
    } else if (!_emailOrPhoneNumberController.text
        .contains(EmailValidator.regex)) {
      valid = false;
      _emailOrPhoneNumberError = "Enter valid email!";
    }

    if (_passwordController.text.isEmpty) {
      valid = false;
      _passwordError = "Password can't be blank!";
    } else if (_passwordController.text.length < 6) {
      valid = false;
      _passwordError = "Password is invalid!";
    }

    return valid;
  }

  

  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailOrPhoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final emailOrMobileNumberField = new TextField(
      controller: _emailOrPhoneNumberController,
      obscureText: false,
      decoration: new InputDecoration(
        errorText: _emailOrPhoneNumberError,
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        prefixIcon: new Icon(Icons.email),
        hintText: 'Enter Email / Mobile Number',
        border: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.grey, width: 32.0),
          borderRadius: new BorderRadius.circular(25.0),
        ),
      ),
    );

    final passwordField = new TextField(
      controller: _passwordController,
      obscureText: _isHidden ? true : false,
      decoration: new InputDecoration(
        errorText: _passwordError,
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        prefixIcon: new Icon(Icons.lock),
        suffixIcon: new IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden
              ? new Icon(Icons.visibility_off)
              : new Icon(Icons.visibility),
        ),
        hintText: 'Enter Password',
        border: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.grey, width: 32.0),
          borderRadius: new BorderRadius.circular(25.0),
        ),
      ),
    );

    final pageTitle = new Padding(
        padding: const EdgeInsets.only(bottom: 40.0, left: 28.0),
        child: new Align(
          alignment: Alignment.topLeft,
          child: new Text(
            'sign In',
            style: new TextStyle(
              color: Colors.brown[400],
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              fontFamily: 'OpenSans',
            ),
            textAlign: TextAlign.start,
          ),
        ));

    final loginButon = new Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      child: new Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(18.0),
        color: Colors.brown[400],
        child: new MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: _authenticateUser,
          child: new Text("Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    final socialMedia = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new ErrorBox(isError: _isError, errorText: _errorText),
        new Padding(
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          child: new ButtonTheme(
            minWidth: 150.0,
            height: 50.0,
            child: new FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              color: Color(0xff4364A1),
              child: Text(
                'Facebook',
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _loginWithFB();
              },
            ),
          ),
        ),
        new Padding(
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          child: new ButtonTheme(
            minWidth: 150.0,
            height: 50.0,
            child: new FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              color: Color(0xffDF513B),
              child: Text(
                'Gmail',
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _loginWithGoogle();
              },
            ),
          ),
        )
      ],
    );

    return new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: _isLoading
            ? _loadingScreen()
            : new Container(
                padding: new EdgeInsets.only(top: 70.0),
                width: double.infinity,
                child: new SingleChildScrollView(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Center(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/rentals_logo2.png',
                              fit: BoxFit.contain,
                            ),
                            new Text(
                              'cRentals',
                              style: new TextStyle(
                                fontSize: 30.0,
                                color: Color(0xff4D4833),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.only(top: 30.0)),
                      new SizedBox(
                        height: 5.0,
                      ),
                      pageTitle,
                      new SizedBox(
                        height: 3.0,
                      ),
                      new Padding(
                        padding: new EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0.0),
                        child: emailOrMobileNumberField,
                      ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      new Padding(
                          padding: new EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 0.0),
                          child: passwordField),
                      new SizedBox(
                        height: 20.0,
                      ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      socialMedia,
                      new SizedBox(
                        height: 5.0,
                      ),
                      new Padding(
                        padding: new EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0.0),
                        child: new Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new InkWell(
                                child: new Text(
                                  "Forgotten Password?",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                onTap: () {
                                  print('fake');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      loginButon,
                      new SizedBox(
                        height: 10.0,
                      ),
                      new Container(
                        child: new Center(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text("Don't have an account?"),
                              new SizedBox(
                                width: 10.0,
                              ),
                              new InkWell(
                                child: new Text("SIGN UP",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()));
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

class _loadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: 100.0),
      child: new Center(
        child: new Column(
          children: <Widget>[
            new CircularProgressIndicator(
              strokeWidth: 4.0,
            ),
            new Container(
              padding: new EdgeInsets.all(8.0),
              child: new Text(
                'Please Wait',
                style:
                    new TextStyle(color: Colors.grey.shade500, fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
