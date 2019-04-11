import 'package:flutter/material.dart';
import 'quizquestions.dart';

class GameButton extends StatelessWidget {
  final int id;
  final Function(int, int, BuildContext) onPressed;
  final bool playing;
  final bool crossed;
  final int answerStatus;
  final int value;
  final Questions ques;
 
  const GameButton({
    Key key,
    this.id,
    this.onPressed,
    this.playing,
    this.crossed,
    this.value,
    this.ques,
    this.answerStatus
  } ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(this.value != 0) {
      return FlatButton(
        color: decideColor(),
        onPressed: (){onPressed(this.value, this.id, context);}, 
        child: Stack(
          children: <Widget>[
            // Visibility(
            //   visible: crossed,
            //   child: Icon(
            //     Icons.done,
            //     size: 48,
            //     color: Colors.brown,
            //   )
            // ),
            decideText()
            
          ],
        ),
      );
    } else {
      return Text("");
    }
  }

  Color decideColor() {
    if(!this.playing)
      return Colors.white;
    else if(this.crossed) {
      if(answerStatus == 0)
        return Colors.white;
      else if(answerStatus == 1) 
        return Colors.red;
      else  return Colors.green;
    }
    else
      return Colors.white;
  }

  Text decideText() {
    if(this.value==0) return Text(''); 
    else return Text("${this.value}");
    // return Text(
    //   playing ? "${this.value}" : '',
    //   style: TextStyle(
    //     color: crossed ? Colors.green : Colors.black,
    //   ),
    // );
  }

}