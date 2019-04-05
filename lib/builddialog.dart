import 'package:flutter/material.dart';
import 'dart:convert';
import 'jsonhandler.dart';
import 'quizquestions.dart';

class BuildDialog extends StatefulWidget {
  const BuildDialog({Key key, this.title, this.ID, this.quiz}) : super(key: key);

  final String title;
  final int ID;
  final Quiz quiz;
 
  @override
  _BuildDialogState createState() => new _BuildDialogState();
}

class _BuildDialogState extends State<BuildDialog>{
  int _radioValue = -1;

  //JSONHandler jsonHandler = new JSONHandler();

  void _handleRadioValueChange(int value) {
    setState(() {
     _radioValue = value; 
    });
  }
  @override
  Widget build(BuildContext context){

    //Quiz quiz = jsonHandler.getData();

    void checkAnswer() {
      if(_radioValue == widget.quiz.questions[widget.ID].answer);
    }

    return new SimpleDialog(
      title: Text("Question ${widget.ID}"),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.quiz.questions[widget.ID].question, style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                  new Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile(
                          title: Text(widget.quiz.questions[widget.ID].options[0], style: TextStyle(fontSize: 14.0)),
                          value: 0, 
                          groupValue: _radioValue,
                          onChanged: (val) {_handleRadioValueChange(val);},
                        ),
                      )
                    ],
                  ),
                  new Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile(
                          title: Text(widget.quiz.questions[widget.ID].options[1], style: TextStyle(fontSize: 14.0)),
                          value: 1, 
                          groupValue: _radioValue,
                          onChanged: (val) {_handleRadioValueChange(val);},
                        ),
                      )
                    ],
                  ),
                  new Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile(
                          title: Text(widget.quiz.questions[widget.ID].options[2], style: TextStyle(fontSize: 14.0)),
                          value: 2, 
                          groupValue: _radioValue,
                          onChanged: (val) {_handleRadioValueChange(val);},
                        ),
                      )
                    ],
                  ),
                  new Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile(
                          title: Text(widget.quiz.questions[widget.ID].options[3], style: TextStyle(fontSize: 14.0)),
                          value: 3, 
                          groupValue: _radioValue,
                          onChanged: (val) {_handleRadioValueChange(val);},
                        ),
                      )
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Submit"),
                        onPressed: checkAnswer,
                      )
                    ],
                  ),
                ],
              ),
        )
      ],
    );
  
    
  }
}