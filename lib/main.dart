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
  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Scaffold(
        backgroundColor: Colors.brown[100],
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                    flex: 2,
                    child: new Container(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80.0,
                            child: Image.asset('assets/images/rentals_logo.png'),
                          ),
                          new Padding(padding: EdgeInsets.only(bottom: 40.0)),
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
                                      decoration: new BoxDecoration(
                                         gradient: new LinearGradient(begin: Alignment.center, colors: [
                                           Colors.brown[600],
                                           Colors.brown[500],
                                           Colors.brown[800],
                                           Colors.brown[400],
                                         ]),
                                          color: Colors.white,
                                          borderRadius:
                                              new BorderRadius.circular(20.0)),
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
                          new SizedBox(height: 20.0,),
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                  child: new Padding(
                                      padding: new EdgeInsets.only(
                                          left: 20.0, right: 10.0, top: 10.0),
                                      child: new Container(
                                        alignment: Alignment.center,
                                        height: 60.0,
                                        decoration: new BoxDecoration(
                                            color: Color(0xff4364A1),
                                            borderRadius:
                                                new BorderRadius.circular(20.0)),
                                        child: new Text(
                                          'Facebook',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ))),
                              new Expanded(
                                  child: new Padding(
                                      padding: new EdgeInsets.only(
                                          left: 20.0, right: 10.0, top: 10.0),
                                      child: new Container(
                                        alignment: Alignment.center,
                                        height: 60.0,
                                        decoration: new BoxDecoration(
                                            color: Color(0xffDF513B),
                                            borderRadius:
                                                new BorderRadius.circular(20.0)),
                                        child: new Text(
                                          'Gmail',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ))),
                            ],
                          ),
                          new Container(
                            padding: new EdgeInsets.only(top: 50.0),
                            child: new Text(
                              'Get Your Home And Live Like  A Boss',
                              style: new TextStyle(
                                  color: Colors.brown[400],
                                  fontSize: 20.0,
                                  fontFamily: 'Pacifico'),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
