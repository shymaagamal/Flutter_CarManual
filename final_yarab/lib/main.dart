import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';

//********************************************************************* *
//********************************************************************* *
dynamic x = 0;

void main() async {
  Socket sock = await Socket.connect('172.28.146.254', 80);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(sock));
}

//-------------------------------------------------------------------
class MyApp extends StatelessWidget {
  Socket socket;
  MyApp(Socket s) {
    this.socket = s;
  }
  @override
  Widget build(BuildContext context) {
    final title = 'Manual Car';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(
        title: title,
        channel: socket,
      ),
    );
  }
}

//******************************************************* */
class Home extends StatefulWidget {
  final String title;
  final Socket channel;

  Home({Key key, @required this.title, @required this.channel})
      : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}
//******************************************************************** */

class _HomeState extends State<Home> {
  void readingSavedData() {
    final db = FirebaseDatabase.instance.reference().child("Man");

    db.child("Place").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        x = values["X"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ),
      body: Center(
        child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            width: 200,
            height: 50,
            child: Text(
              "RFID VALUES : $x",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          button(_forward, "F"),
          new Container(
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                new RaisedButton(
                  child: Text("L",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 50.0,
                      )),
                  color: Colors.pink[900],
                  onPressed: _left,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                      side: BorderSide(color: Colors.white)),
                  padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                ),
                new RaisedButton(
                  child: Text("R",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 50.0,
                      )),
                  color: Colors.pink[900],
                  onPressed: _right,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                      side: BorderSide(color: Colors.white)),
                  padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                )
              ])),
          button(_backward, "B"),
          SizedBox(
            height: 50,
          )
        ]),
      ),
    );
  }

  Timer _locationTimer;
  @override
  void initState() {
    _locationTimer = Timer.periodic(
        Duration(milliseconds: 1),
        (Timer t) => setState(() {
              readingSavedData();
            }));
    super.initState();
  }

  @override
  void dispose() {
    widget.channel.close();
    super.dispose();
  }

  void _forward() {
    widget.channel.write("F");
  }

  void _backward() {
    widget.channel.write("B");
  }

  void _right() {
    widget.channel.write("R");
  }

  void _left() {
    widget.channel.write("L");
  }

  void _stop() {
    widget.channel.write("S");
  }

  void _reload() async {
    Socket sock = await Socket.connect('172.28.134.149', 80);
  }
}

Widget button(
  func,
  string,
) {
  return Container(
      margin: const EdgeInsets.fromLTRB(70, 50, 50, 50),
      child: new RaisedButton(
        child: Text(string,
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 50.0,
            )),
        color: Colors.pink[900],
        onPressed: func,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45.0),
            side: BorderSide(color: Colors.white)),
        padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
      ));
}
