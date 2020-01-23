import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => new SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  String _picked = "Two";

  final pageTitle = new Padding(
      padding: const EdgeInsets.only(bottom: 40.0, left: 28.0),
      child: new Align(
        alignment: Alignment.topLeft,
        child: new Text(
          'sign Up',
          style: new TextStyle(
            color: Colors.brown[400],
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            fontFamily: 'OpenSans',
          ),
          textAlign: TextAlign.start,
        ),
      ));
  final categoriesTitle = new Padding(
      padding: const EdgeInsets.only(bottom: 40.0, left: 28.0),
      child: new Align(
        alignment: Alignment.topLeft,
        child: new Text(
          'I am ',
          style: new TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'OpenSans',
          ),
          textAlign: TextAlign.start,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: new EdgeInsets.only(top: 70.0),
        child: new SingleChildScrollView(
          child: new Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisSize: MainAxisSize.min,
//            mainAxisAlignment: MainAxisAlignment.center,
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
             categoriesTitle,
              new Text('gfhfgfhfghfg'),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RadioButtonGroup(
                      activeColor: Colors.brown[400],
                      orientation: GroupedButtonsOrientation.HORIZONTAL,
                      labels: <String>["Buyer", "Seller", "Dealer"],
                      onSelected: (String selected) => print(selected))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
