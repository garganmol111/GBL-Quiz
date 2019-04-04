import 'package:flutter/material.dart';
import 'dart:math';
import 'generate_ticket.dart';
import 'gamebutton.dart';
import 'builddialog.dart';

class TambolaTicket extends StatefulWidget {
  final int rows;
  final int cols;

  const TambolaTicket({Key key, this.rows: 9, this.cols: 3}) : super(key: key);
  
  @override 
  _TambolaTicketState createState() => _TambolaTicketState();
}

class _TambolaTicketState extends State<TambolaTicket> {

  int randomNumber = -1;

  List<int> pot;
  List<List<int>> initialTicket;
  List<int> crossedNumbers;

  String resultText = "";
  String statusText = "Roll it";

  BuildContext _context;

  @override
  void initState() {
    super.initState();
    restart();
  }

  void restart() {
    initialTicket = generateTicket();
    pot = List<int>.generate(90, (i) => i+1);
    crossedNumbers = [];

    randomNumber = -1;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: new Table(
                border:TableBorder.all(),
                children: buildButtons(),
              )
            ),
            Text("$statusText"),
            Text("$resultText"),
            Center(
              child: Row(
                children: <Widget>[
                  FlatButton(
                    color: Colors.grey,
                    onPressed: rollNext,
                    child: Text("Roll"),
                  ),
                  FlatButton(
                    color: Colors.grey,
                    onPressed: () {setState(() {restart();});},
                    child: Text("Restart"),
                  )
                ],
              )
            ),
            Text("Pot: " + pot.toString())
          ],
        ),
      )
    );
  }

  List<TableRow> buildButtons() {

    List<TableRow> rows = [];

    int id=0;

    for(var i=0; i<widget.rows; i++) {
      //new empty row
      List<Widget> rowChildren = [];

      for(var j=0; j<widget.cols; j++) {
        int value = transpose(initialTicket)[i][j];
      
        rowChildren.add(
          new GameButton(
            id: id,
            value: value,
            playing: isNumberPlaying(value),
            crossed: isCrossed(value),
            onPressed: onButtonClicked,
          )
        );
        id++;
      }
      rows.add(new TableRow(children: rowChildren));
    }
    return rows;
  }
  
  onButtonClicked(int value, int id) {
    setState(() {
      
      if(value == randomNumber) {
        if(isNumberPlaying(value)) {
          showQuestion(id);
          resultText = resultText = Random.secure().nextBool() ? "Housie" : "Whoo";
          statusText = "Pull next number";
          crossedNumbers.add(value);
        } else {
          resultText = Random.secure().nextBool()
              ? "You can't cheat machine code"
              : "Nice try, but you don't have it on your ticket!";
        }
      } else {
        resultText =
            Random.secure().nextBool() ? "Missed, are u ok?" : "Try harder";
      }
    });
  }

  rollNext() {
    setState(() {
     if(pot.length > 0) {
       int randomIndex = Random.secure().nextInt(pot.length);

       this.randomNumber = pot.removeAt(randomIndex);

       this.statusText = "Rolled: $randomNumber";
       this.resultText = "playing one more time...";
     } else {
       restart();
     }
    });
  }

  isNumberPlaying(int value) {
    if(initialTicket[0].contains(value) || initialTicket[1].contains(value) || initialTicket[2].contains(value)) { 
      return true;
    } else {
      return false;
    }
  }

  isCrossed(int value) {
    return crossedNumbers.contains(value);
  }


  void showQuestion(int id) {
    showDialog(context: _context, builder: (_)=>BuildDialog(ID: id));
  }
}

