import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final List correctAnswers;
  final List crossedNumbers;
  final bool gotCorner;
  final bool gotRow1;
  final bool gotRow2;
  final bool gotRow3;
  final bool gotFullHouse;
  final int score;

  const ResultPage({
    Key key,
    this.correctAnswers,
    this.crossedNumbers,
    this.gotCorner = false,
    this.gotRow1 = false,
    this.gotRow2 = false,
    this.gotRow3 = false,
    this.gotFullHouse = false,
    this.score = 0,
  }) : super(key: key);

  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            //questions attempted
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Total Questions Attempted: " +
                        widget.crossedNumbers.length.toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),

            //correct answers
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Correct Answers: ",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    widget.correctAnswers.length.toString(),
                    style: TextStyle(color: Colors.green, fontSize: 20.0),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                children: [
                  TableRow(children: [
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("You got: ",
                                    style: TextStyle(fontSize: 20.0))
                              ],
                            ),
                          ],
                        )),
                    TableCell(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Corners\n",
                              style: TextStyle(
                                  color: widget.gotCorner
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Row 1\n",
                              style: TextStyle(
                                  color: widget.gotRow1
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Row 2\n",
                              style: TextStyle(
                                  color: widget.gotRow2
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Row 3\n",
                              style: TextStyle(
                                  color: widget.gotRow3
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Full House",
                              style: TextStyle(
                                  color: widget.gotFullHouse
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 20.0),
                            ),
                          ],
                        )
                      ],
                    ))
                  ])
                ],
              ),
            ),

            //Total Score
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Total Score: ",
                    style: TextStyle(fontSize: 30.0),
                  ),
                  Text(widget.score.toString(),
                      style: TextStyle(color: Colors.green, fontSize: 30.0)),
                  Text(
                    "/100",
                    style: TextStyle(fontSize: 30.0),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.grey,
                    child: Text("Exit"),
                    onPressed: () {Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
