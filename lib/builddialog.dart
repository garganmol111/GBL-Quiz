import 'package:flutter/material.dart';

class BuildDialog extends StatefulWidget {
  BuildDialog({Key key, this.title, this.ID}) : super(key: key);

  final String title;
  int ID;
 
  @override
  _BuildDialogState createState() => new _BuildDialogState();
}

class _BuildDialogState extends State<BuildDialog>{
  int _radioValue = -1;

  void _handleRadioValueChange(int value) {
    setState(() {
     _radioValue = value; 
    });
  }
  @override
  Widget build(BuildContext context){

    return new SimpleDialog(
      title: Text("Question"),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Question", style: TextStyle(fontSize: 14.0))
                    ],
                  ),
                  new Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile(
                          title: const Text("Option 1", style: TextStyle(fontSize: 14.0)),
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
                          title: const Text("Option 2", style: TextStyle(fontSize: 14.0)),
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
                          title: const Text("Option 3", style: TextStyle(fontSize: 14.0)),
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
                          title: const Text("Option 4", style: TextStyle(fontSize: 14.0)),
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
                        onPressed: (){},
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