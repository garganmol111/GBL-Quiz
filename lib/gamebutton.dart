import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  final int id;
  final Function(int, int) onPressed;
  final bool playing;
  final bool crossed;
  final int value;

  const GameButton({
    Key key,
    this.id,
    this.onPressed,
    this.playing,
    this.crossed,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(this.value != 0) {
      return FlatButton(
        color: decideColor(),
        onPressed: (){onPressed(this.value, this.id);}, 
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: crossed,
              child: Icon(
                Icons.done,
                size: 48,
                color: Colors.brown,
              )
            ),
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
      return Colors.yellow;
    } 
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