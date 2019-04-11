import 'package:flutter/material.dart';
import 'dart:math';
import 'generate_ticket.dart';
import 'gamebutton.dart';
import 'builddialog.dart';
import 'quizquestions.dart';

class TambolaTicket extends StatefulWidget {
  final int rows;
  final int cols;
  final Quiz quiz;

  const TambolaTicket({Key key, this.rows: 9, this.cols: 3, this.quiz})
      : super(key: key);

  @override
  _TambolaTicketState createState() => _TambolaTicketState();
}

class _TambolaTicketState extends State<TambolaTicket> {
  int randomNumber = -1;

  List<int> pot;
  List<List<int>> initialTicket;
  List<int> crossedNumbers;
  List<int> correctAnswers;

  String resultText = "";
  String statusText = "Roll it";

  BuildContext _context;

  List<TableRow> renderedTicket;

  bool _isCornersButtonDisabled;
  bool _isRow1ButtonDisabled;
  bool _isRow2ButtonDisabled;
  bool _isRow3ButtonDisabled;
  bool _isFullHouseButtonDisabled;

  @override
  void initState() {
    super.initState();
    restart();
  }

  void restart() {
    initialTicket = generateTicket();
    pot = List<int>.generate(90, (i) => i + 1);
    crossedNumbers = [];
    correctAnswers = [];
    renderedTicket = [];
    widget.quiz.reset();

    _isCornersButtonDisabled = false;
    _isRow1ButtonDisabled = false;
    _isRow2ButtonDisabled = false;
    _isRow3ButtonDisabled = false;
    _isFullHouseButtonDisabled = false;
    randomNumber = -1;

  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.quiz.quizName),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                    child: new Table(
                  border: TableBorder.all(),
                  children: buildButtons(),
                )),
                Text("$statusText"),
                //Text("$resultText"),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.grey,
                      onPressed: rollNext,
                      child: Text("Roll"),
                    ),
                    FlatButton(
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          restart();
                        });
                      },
                      child: Text("Restart"),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildCornersButton(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildRow1Button(),
                    _buildRow2Button(),
                    _buildRow3Button(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildFullHouseButton(),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  List<TableRow> buildButtons() {
    correctAnswers = [];
    List<TableRow> rows = [];

    int id = 0;

    for (var i = 0; i < widget.rows; i++) {
      //new empty row
      List<Widget> rowChildren = [];
      
      for (var j = 0; j < widget.cols; j++) {
        int value = initialTicket[i][j];

        if (value != 0) {
          rowChildren.add(new GameButton(
            id: id,
            value: value,
            playing: isNumberPlaying(value),
            crossed: isCrossed(value, id),
            onPressed: onButtonClicked,
            ques: widget.quiz.questions[id],
            answerStatus: getAnswerStatus(id),
          ));
          if(getAnswerStatus(id) == 2)
            correctAnswers.add(value);
          id++;
        } else {
          rowChildren.add(Text(""));
        }
      }
      rows.add(new TableRow(children: rowChildren));
    }
    renderedTicket = rows.map((e) => e).toList();
    return rows;
  }

  onButtonClicked(int value, int id, BuildContext context) {
    setState(() {

      //////////////////////////////////////////////////////////
      // showQuestion(id, widget.quiz, context);
      //     resultText =
      //         resultText = Random.secure().nextBool() ? "Housie" : "Whoo";
      //     statusText = "Pull next number";
      //     crossedNumbers.add(value);
      /////////////////////////////////////////////////////////

      if (value == randomNumber) {
        if (isNumberPlaying(value)) {
          showQuestion(id, widget.quiz, context);
          resultText =
              resultText = Random.secure().nextBool() ? "Housie" : "Whoo";
          statusText = "Pull next number";
          crossedNumbers.add(value);
          if(widget.quiz.questions[id].isCorrect == 2)
            correctAnswers.add(id);
        } else {
          resultText = Random.secure().nextBool()
              ? "You can't cheat machine code id: $id"
              : "Nice try, but you don't have it on your ticket! id: $id";
        }
      } else {
        resultText = Random.secure().nextBool()
            ? "Missed, are u ok? id: $id"
            : "Try harder id: $id";
      }
    });
  }

  rollNext() {
    setState(() {
      if (pot.length > 0) {
        int randomIndex = Random.secure().nextInt(pot.length);

        this.randomNumber = pot.removeAt(randomIndex);

        this.statusText = "Rolled: $randomNumber";
        this.resultText = "playing one more time...";
      } else {
        //restart();
      }
    });
  }

  isNumberPlaying(int value) {
    List<List<int>> temp = transpose(initialTicket);
    if (temp[0].contains(value) ||
        temp[1].contains(value) ||
        temp[2].contains(value)) {
      return true;
    } else {
      return false;
    }
  }

  isCrossed(int value, int id) {
    return crossedNumbers.contains(value);
  }

  int getAnswerStatus(int id) {
    return widget.quiz.questions[id].isCorrect;
  }

  void showQuestion(int id, Quiz quiz, BuildContext context) async {
    await showDialog(
        context: _context,
        builder: (_) => BuildDialog(
              ID: id,
              quiz: quiz,
            )).then((val) {
      setState(() {});
    });
    //await Navigator.push(context, new MaterialPageRoute(builder: (context) => BuildDialog(ID: id, quiz: quiz,)));
  }


/////////////////////////////////////////////////////////////////////////////////////////////////
// CALL BUTTONS CHECKING FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////////
  

  Widget _buildCornersButton() {
    
    Text retText() {
      if(_isCornersButtonDisabled) {
        return new Text(
          "Call Corners",
          style: TextStyle(
            decoration: TextDecoration.lineThrough
          ),
        );
      }
      else
        return new Text("Call Corners");
    }

    return new RaisedButton(
      child: retText(),
      onPressed: _isCornersButtonDisabled ? null : checkCorners,
      color: Colors.grey,
    );
  }

  Widget _buildRow1Button() {
    Text retText() {
      if(_isRow1ButtonDisabled) {
        return new Text(
          "Call Row 1",
          style: TextStyle(
            decoration: TextDecoration.lineThrough
          ),
        );
      }
      else
        return new Text("Call Row 1");
    }

    return new RaisedButton(
      child: retText(),
      onPressed: _isRow1ButtonDisabled ? null : checkRow1,
      color: Colors.grey,
    );
  }

  Widget _buildRow2Button() {
    Text retText() {
      if(_isRow2ButtonDisabled) {
        return new Text(
          "Call Row 2",
          style: TextStyle(
            decoration: TextDecoration.lineThrough
          ),
        );
      }
      else
        return new Text("Call Row 2");
    }

    return new RaisedButton(
      child: retText(),
      onPressed: _isRow2ButtonDisabled ? null : checkRow2,
      color: Colors.grey,
    );
  }

  Widget _buildRow3Button() {
    Text retText() {
      if(_isRow3ButtonDisabled) {
        return new Text(
          "Call Row 3",
          style: TextStyle(
            decoration: TextDecoration.lineThrough
          ),
        );
      }
      else
        return new Text("Call Row 3");
    }

    return new RaisedButton(
      child: retText(),
      onPressed: _isRow3ButtonDisabled ? null : checkRow3,
      color: Colors.grey,
    );
  }

  Widget _buildFullHouseButton() {
    Text retText() {
      if(_isFullHouseButtonDisabled) {
        return new Text(
          "Call Full House",
          style: TextStyle(
            decoration: TextDecoration.lineThrough
          ),
        );
      }
      else
        return new Text("Call Full House");
    }

    return new RaisedButton(
      child: retText(),
      onPressed: _isFullHouseButtonDisabled ? null : checkFullHouse,
      color: Colors.grey,
    );
  }

  void checkCorners() {
    List<int> temp = [];
    List<List<int>> tempTicket = transpose(initialTicket);
    for(int i=0; i<3; i++) {
      for(int j=0; j<9; j++) {
        if(tempTicket[i][j] != 0)
          temp.add(tempTicket[i][j]);
      }
    }
    
    List<int> newTemp = [temp[0], temp[4], temp[10], temp[14]];
    bool flag = true;
    newTemp.forEach((f) {
      if(crossedNumbers.contains(f))
        flag=true;
      else flag=false;
    });

    print(correctAnswers);

    print(flag.toString());
    setState(() {
      _isCornersButtonDisabled = flag;
    });
  }

  void checkRow1() {
    List<int> temp = [];
    List<List<int>> tempTicket = transpose(initialTicket);
    for(int i=0; i<3; i++) {
      for(int j=0; j<9; j++) {
        if(tempTicket[i][j] != 0)
          temp.add(tempTicket[i][j]);
      }
    }
    
    List<int> newTemp = [temp[0], temp[1], temp[2], temp[3], temp[4]];
    bool flag = true;
    newTemp.forEach((f) {
      if(crossedNumbers.contains(f))
        flag=true;
      else flag=false;
    });

    print(correctAnswers);

    print(flag.toString());
    setState(() {
      _isRow1ButtonDisabled = flag;
    });
  }

  void checkRow2() {
    List<int> temp = [];
    List<List<int>> tempTicket = transpose(initialTicket);
    for(int i=0; i<3; i++) {
      for(int j=0; j<9; j++) {
        if(tempTicket[i][j] != 0)
          temp.add(tempTicket[i][j]);
      }
    }
    
    List<int> newTemp = [temp[5], temp[6], temp[7], temp[8], temp[9]];
    bool flag = true;
    newTemp.forEach((f) {
      if(crossedNumbers.contains(f))
        flag=true;
      else flag=false;
    });

    print(correctAnswers);

    print(flag.toString());
    setState(() {
      _isRow2ButtonDisabled = flag;
    });
  }

  void checkRow3() {
    List<int> temp = [];
    List<List<int>> tempTicket = transpose(initialTicket);
    for(int i=0; i<3; i++) {
      for(int j=0; j<9; j++) {
        if(tempTicket[i][j] != 0)
          temp.add(tempTicket[i][j]);
      }
    }
    
    List<int> newTemp = [temp[10], temp[11], temp[12], temp[13], temp[14]];
    bool flag = true;
    newTemp.forEach((f) {
      if(crossedNumbers.contains(f))
        flag=true;
      else flag=false;
    });

    print(correctAnswers);

    print(flag.toString());
    setState(() {
      _isRow3ButtonDisabled = flag;
    });
  }

  void checkFullHouse() {
    List<int> temp = [];
    List<List<int>> tempTicket = transpose(initialTicket);
    for(int i=0; i<3; i++) {
      for(int j=0; j<9; j++) {
        if(tempTicket[i][j] != 0)
          temp.add(tempTicket[i][j]);
      }
    }
    
    bool flag = true;
    temp.forEach((f) {
      if(crossedNumbers.contains(f))
        flag=true;
      else flag=false;
    });

    print(correctAnswers);

    print(flag.toString());
    setState(() {
      _isFullHouseButtonDisabled = flag;
    });
  }
}
