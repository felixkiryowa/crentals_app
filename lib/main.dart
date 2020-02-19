import 'package:flutter/material.dart';
import 'user_authentication/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRentals App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        accentColor: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static int getYear = new DateTime.now().year;
  String currentYear = getYear.toString();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(top: 100.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    'assets/images/rentals_logo2.png',
                    fit: BoxFit.contain,
                  ),
                  new Padding(padding: new EdgeInsets.only(top: 30.0)),
                  new Text(
                    'cRentals',
                    style: new TextStyle(
                      fontSize: 30.0,
                      color: Color(0xff4D4833),
                    ),
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  new Container(
                    padding: new EdgeInsets.all(70.0),
                    child: new Text(
                      'Find Your Home, New Neighbours, Peace Of Mind & Find New Tenants',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: new TextStyle(
                          fontSize: 20.0, color: Colors.brown[400]),
                    ),
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Padding(
                        padding: new EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0.0),
                        child: new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                            title: 'Login User',
                                          )));
                            },
                            child: new Container(
                              alignment: Alignment.center,
                              height: 60.0,
                              child: new Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            )),
                      ))
                    ],
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0.0),
                        child: new ButtonTheme(
                          minWidth: 150.0,
                          height: 50.0,
                          child: new OutlineButton(
                            child: Text(
                              'Login',
                              style: new TextStyle(color: Colors.brown[400]),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                            title: 'Login User',
                                          )));
                            },
                            borderSide: BorderSide(
                              color: Colors.brown[400], //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 0.8, //width of the border
                            ),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0.0),
                        child: new ButtonTheme(
                          minWidth: 150.0,
                          height: 50.0,
                          child: new FlatButton(
                            color: Colors.brown[400],
                            child: Text(
                              'Sign up',
                              style: new TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              print(currentYear);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new Text(
                    '\u00a9 $currentYear | cRentals',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.brown[400], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
