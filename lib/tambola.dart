import 'package:flutter/material.dart';
import 'dart:math';
import 'generate_ticket.dart';
import 'gamebutton.dart';
import 'builddialog.dart';
import 'quizquestions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'result_page.dart';

class QuizState<T extends StatefulWidget> extends State<T> {
  Quiz _quiz;

  set setQuiz(Quiz quiz) => setState(() {
        _quiz = quiz;
      });

  Quiz get getQuiz => _quiz;

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key, this.quizID, this.databaseReference})
      : super(key: key);

  final quizID;
  final databaseReference;

  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends QuizState<LoadingScreen> {
  Quiz quiz;

  @override
  void initState() {
    super.initState();

    /// If the LoadingScreen widget has an initial message set, then the default
    /// message in the MessageState class needs to be updated

    /// We require the initializers to run after the loading screen is rendered
    SchedulerBinding.instance.addPostFrameCallback((_) {
      List<Questions> y = [];
      widget.databaseReference.once().then((DataSnapshot snapshot) {
        quiz = Quiz.fromJson(
            Map<String, dynamic>.from(snapshot.value[widget.quizID]));
        for (int i = 0; i < 15; i++) {
          Questions x = Questions.fromJson(Map<String, dynamic>.from(
              snapshot.value[widget.quizID]['questions'][i]));
          y.add(x);
        }
        quiz.questions = y;
        //print(y);
        // print("retrieved data: " + temp.toString());
        //print("1");
      });
      // .then((data) {
      //   quiz = data;
      //   print("2");
      //   //print(quiz);
      // });

      runInitTasks();
    });
  }

  /// This method calls the initializers and once they complete redirects to
  /// the widget provided in navigateAfterInit
  @protected
  Future runInitTasks() async {
    /// Run each initializer method sequentially
//print("3");
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => TambolaTicket(
              quiz: quiz,
              databaseReference: widget.databaseReference,
            )));
  }

// Future<Quiz> _getJson() async {
//     Quiz temp;
//     List<Questions> y = [];
//     widget.databaseReference.once().then((DataSnapshot snapshot) {
//       temp = Quiz.fromJson(
//           Map<String, dynamic>.from(snapshot.value[widget.quizID]));
//       for (int i = 0; i < 15; i++) {
//         Questions x = Questions.fromJson(Map<String, dynamic>.from(
//             snapshot.value[widget.quizID]['questions'][i]));
//         y.add(x);
//       }
//       temp.questions = y;
//       print(y);
//      // print("retrieved data: " + temp.toString());
//      print("1");
//     });
//     return temp;
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class TambolaTicket extends StatefulWidget {
  final int rows;
  final int cols;
  Quiz quiz;
  String quizID;
  final databaseReference;
  int score;
  final int cornerPoints;
  final int rowPoints;
  final int fullHousePoints;
  //Quiz temp;

  TambolaTicket(
      {this.rows: 9,
      this.cols: 3,
      this.quiz,
      this.quizID = "0",
      this.databaseReference,
      this.score = 0,
      this.cornerPoints = 15,
      this.rowPoints = 15,
      this.fullHousePoints = 40});

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

    // _getJson().then((result) {
    //   setState(() {
    //     widget.quiz = result;
    //   });
    // });

    restart();
  }

  void restart() {
    initialTicket = generateTicket();
    pot = List<int>.generate(90, (i) => i + 1);
    crossedNumbers = [];
    correctAnswers = [];
    renderedTicket = [];
    if (widget.quiz != null) widget.quiz.reset();

    _isCornersButtonDisabled = false;
    _isRow1ButtonDisabled = false;
    _isRow2ButtonDisabled = false;
    _isRow3ButtonDisabled = false;
    _isFullHouseButtonDisabled = false;
    randomNumber = -1;
  }

  Future<Quiz> _getJson() async {
    Quiz temp;
    List<Questions> y = [];
    widget.databaseReference.once().then((DataSnapshot snapshot) {
      temp = Quiz.fromJson(
          Map<String, dynamic>.from(snapshot.value[widget.quizID]));
      for (int i = 0; i < 15; i++) {
        Questions x = Questions.fromJson(Map<String, dynamic>.from(
            snapshot.value[widget.quizID]['questions'][i]));
        y.add(x);
      }
      temp.questions = y;
      print("retrieved data: " + temp.toString());
    });
    return temp;
  }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.quiz.quizName),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Score: " + widget.score.toString(),
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),

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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.grey,
                      child: Text("Submit"),
                      onPressed: _submitFinal,
                    )
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
          if (getAnswerStatus(id) == 2) correctAnswers.add(value);
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
      if (widget.quiz.questions[id].isCorrect == 2) correctAnswers.add(id);
      /////////////////////////////////////////////////////////

      if (value == randomNumber) {
        if (isNumberPlaying(value)) {
          showQuestion(id, widget.quiz, context);
          resultText =
              resultText = Random.secure().nextBool() ? "Housie" : "Whoo";
          statusText = "Pull next number";
          crossedNumbers.add(value);
          if (widget.quiz.questions[id].isCorrect == 2) correctAnswers.add(id);
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

  void _submitFinal() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(
                  correctAnswers: correctAnswers,
                  crossedNumbers: crossedNumbers,
                  gotCorner: _isCornersButtonDisabled,
                  gotRow1: _isRow1ButtonDisabled,
                  gotRow2: _isRow2ButtonDisabled,
                  gotRow3: _isRow3ButtonDisabled,
                  gotFullHouse: _isFullHouseButtonDisabled,
                  score: widget.score,
                )));
  }

  Widget _buildCornersButton() {
    Text retText() {
      if (_isCornersButtonDisabled) {
        return new Text(
          "Call Corners",
          style: TextStyle(decoration: TextDecoration.lineThrough),
        );
      } else
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
      if (_isRow1ButtonDisabled) {
        return new Text(
          "Call Row 1",
          style: TextStyle(decoration: TextDecoration.lineThrough),
        );
      } else
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
      if (_isRow2ButtonDisabled) {
        return new Text(
          "Call Row 2",
          style: TextStyle(decoration: TextDecoration.lineThrough),
        );
      } else
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
      if (_isRow3ButtonDisabled) {
        return new Text(
          "Call Row 3",
          style: TextStyle(decoration: TextDecoration.lineThrough),
        );
      } else
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
      if (_isFullHouseButtonDisabled) {
        return new Text(
          "Call Full House",
          style: TextStyle(decoration: TextDecoration.lineThrough),
        );
      } else
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
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        if (tempTicket[i][j] != 0) temp.add(tempTicket[i][j]);
      }
    }

    List<int> newTemp = [temp[0], temp[4], temp[10], temp[14]];
    bool flag = true;
    newTemp.forEach((f) {
      if (!correctAnswers.contains(f)) flag = false;
    });

    print("correct: " + correctAnswers.toString());
    print("crossed: " + crossedNumbers.toString());
    print("corners: " + flag.toString());
    if (flag) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("You got corners!"),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 700),
      ));
      widget.score += widget.cornerPoints;
    } else
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("You didn\'t get corners"),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 700)));
    setState(() {
      _isCornersButtonDisabled = flag;
    });
  }

  void checkRow1() {
    List<int> temp = [];
    List<List<int>> tempTicket = transpose(initialTicket);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        if (tempTicket[i][j] != 0) temp.add(tempTicket[i][j]);
      }
    }

    List<int> newTemp = [temp[0], temp[1], temp[2], temp[3], temp[4]];
    bool flag = true;
    newTemp.forEach((f) {
      if (!correctAnswers.contains(f)) flag = false;
    });

    print("correct: " + correctAnswers.toString());
    print("crossed: " + crossedNumbers.toString());
    if (flag) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("You got row 1!"),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 700)));
      widget.score += widget.rowPoints;
    } else
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("You didn\'t get row 1"),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 700)));

    print("row1: " + flag.toString());
    setState(() {
      _isRow1ButtonDisabled = flag;
    });
  }

  void checkRow2() {
    List<int> temp = [];
    List<List<int>> tempTicket = transpose(initialTicket);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        if (tempTicket[i][j] != 0) temp.add(tempTicket[i][j]);
      }
    }

    List<int> newTemp = [temp[5], temp[6], temp[7], temp[8], temp[9]];
    bool flag = true;
    newTemp.forEach((f) {
      if (!correctAnswers.contains(f)) flag = false;
    });

    print("correct: " + correctAnswers.toString());
    print("crossed: " + crossedNumbers.toString());
    if (flag) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("You got row 2!"),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 700)));
      widget.score += widget.rowPoints;
    } else
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("You didn\'t get row 2"),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 700)));

    print("row2: " + flag.toString());
    setState(() {
      _isRow2ButtonDisabled = flag;
    });
  }

  void checkRow3() {
    List<int> temp = [];
    List<List<int>> tempTicket = transpose(initialTicket);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        if (tempTicket[i][j] != 0) temp.add(tempTicket[i][j]);
      }
    }

    List<int> newTemp = [temp[10], temp[11], temp[12], temp[13], temp[14]];
    bool flag = true;
    newTemp.forEach((f) {
      if (!correctAnswers.contains(f)) flag = false;
    });

    print("correct: " + correctAnswers.toString());
    print("crossed: " + crossedNumbers.toString());
    if (flag) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("You got row 3!"),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 700)));
      widget.score += widget.rowPoints;
    } else
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("You didn\'t get row 3"),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 700)));

    print("row3: " + flag.toString());
    setState(() {
      _isRow3ButtonDisabled = flag;
    });
  }

  void checkFullHouse() {
    List<int> temp = [];
    List<List<int>> tempTicket = transpose(initialTicket);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        if (tempTicket[i][j] != 0) temp.add(tempTicket[i][j]);
      }
    }

    bool flag = true;
    temp.forEach((f) {
      if (!correctAnswers.contains(f)) flag = false;
    });

    print("correct: " + correctAnswers.toString());
    print("crossed: " + crossedNumbers.toString());
    if (flag) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("You got full house!"),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 700)));
      widget.score += widget.fullHousePoints;
    } else
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("You didn\'t get full house"),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 700)));

    print("full house: " + flag.toString());
    setState(() {
      _isFullHouseButtonDisabled = flag;
    });
  }
}
