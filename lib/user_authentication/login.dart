import 'package:crentals_app/components/error_box.dart';
import 'package:flutter/material.dart';
import '../utils/network_utils.dart';
import '../utils/auth_utils.dart';
import '../validators/email_validator.dart';
import '../dasboard/home_page.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences _sharedPreferences;

  bool _isError = false;
  bool _obscureText = true;
  bool _isLoading = false;
  TextEditingController _emailController, _passwordController;
  String _errorText, _emailError, _passwordError;

  @override
  void initialState() {
    super.initState();
    _fetchSessionAndNavigate();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    if (authToken != null) {
      Navigator.of(_scaffoldKey.currentContext)
          .pushReplacementNamed(HomePage.routeName);
    }
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  _authenticateUser() async {
    //Call showLoading function to display loader
    _showLoading();

    if (_valid()) {
      var responseJson = await NetworkUtils.authenticateUser(
          _emailController.text, _passwordController.text);

      print(responseJson);

      if (responseJson == null) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
      } else if (responseJson == 'NetworkError') {
        NetworkUtils.showSnackBar(_scaffoldKey, null);
      } else if (responseJson['errors'] != null) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid Email/Password');
      } else {
        AuthUtils.insertDetails(_sharedPreferences, responseJson);
        /**
         * Removes stack and start with the new page.
         * In this case on press back on HomePage app will exit.
         * **/
        Navigator.of(_scaffoldKey.currentContext)
            .pushReplacementNamed(HomePage.routeName);
      }
      //Call the hideLoading function to hide a loader
      _hideLoading();
    } else {
      setState(() {
        _isLoading = false;
        _emailError;
        _passwordError;
      });
    }
  }

  _valid() {
    bool valid = true;

    if (_emailController.text.isEmpty) {
      valid = false;
      _emailError = "Email can't be blank!";
    } else if (!_emailController.text.contains(EmailValidator.regex)) {
      valid = false;
      _emailError = "Enter valid email!";
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

  Widget build(BuildContext context) {
    final emailOrMobileNumberField = new TextField(
      obscureText: false,
      decoration: new InputDecoration(
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
      obscureText: _isHidden ? true : false,
      decoration: new InputDecoration(
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
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.brown[400],
        child: new MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {},
          child: new Text("Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );


    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        body:_isLoading ? _loadingScreen() :   new Container(
          padding: new EdgeInsets.only(top: 70.0),
          width: double.infinity,
          child: new SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 80.0,
                  child: Image.asset('assets/images/rentals_logo.png'),
                ),
                new SizedBox(
                  height: 5.0,
                ),
                pageTitle,
                new SizedBox(
                  height: 3.0,
                ),
                new ErrorBox(
                  isError: _isError,
                  errorText: _errorText,
                ),
                new Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
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
                new Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
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
                            print('Signup page');
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
                style: new TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16.0
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



