import 'package:flutter/material.dart';
import 'tambola.dart';
import 'createquizpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      )
    );
  }
}
 
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TambolaTicket()
                    ));
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )
                  ),
                ),             
              ]
            ),
            new Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.grey,
                  onPressed: () {
                    final result = Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TambolaTicket()
                    ));
                  },
                  child: Text(
                    "Start Quiz",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )
                  ),
                ),             
              ]
            ),
            new Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => CreateQuizPage()
                    ));
                  },
                  child: Text(
                    "Create a Quiz",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )
                  ),
                ),             
              ]
            ),
          ],
        )
      )
    );
  }
}