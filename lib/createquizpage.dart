import 'package:flutter/material.dart';
import 'jsonhandler.dart';
import 'quizquestions.dart';
import 'tambola.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({Key key}) : super(key: key);

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

int qID = 1;

class _CreateQuizPageState extends State<CreateQuizPage> {
  JSONHandler jsonFile = new JSONHandler();

  //Text controllers for input fields
  TextEditingController quizIDController = new TextEditingController();
  TextEditingController quizNameController = new TextEditingController();
  TextEditingController questionController = new TextEditingController();
  TextEditingController op1Controller = new TextEditingController();
  TextEditingController op2Controller = new TextEditingController();
  TextEditingController op3Controller = new TextEditingController();
  TextEditingController op4Controller = new TextEditingController();
  TextEditingController answerController = new TextEditingController();

  bool flag1 = false;

  Quiz newQuiz;
  List<Questions> questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Quiz!"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(hintText: "Enter quiz ID"),
                      controller: quizIDController,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(hintText: "Enter quiz name"),
                      controller: quizNameController,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Enter Questions"),
                      onPressed: (){setState(() {
                        flag1=true;
                      });},
                      color: Colors.grey,
                    )
                  )
                ],
              ),
              Container(
                child: returnCard(qID),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget returnCard(int id) {
    if(flag1)
      return Card(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Enter Question $qID/15", style: TextStyle(fontSize: 20.0),),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "Enter question"),
                        controller: questionController,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "Enter option 1"),
                        controller: op1Controller,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "Enter option 2"),
                        controller: op2Controller,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "Enter option 3"),
                        controller: op3Controller,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "Enter option 4"),
                        controller: op4Controller,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "Enter Answer no."),
                        keyboardType: TextInputType.number,
                        controller: answerController,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getButton()
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.grey,
                      onPressed: reset,
                      child: Text("Reset"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.grey,
                      onPressed: def,
                      child: Text("fill default"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    else  return Text("");
  }

  void def() {
      questionController.text = "question $qID";
      op1Controller.text = "op 1";
      op2Controller.text = "op 2";
      op3Controller.text = "op 3";
      op4Controller.text = "op 4";
      answerController.text = "2";
      if(qID >= 15) submit();
      onPressedNext();
  }

  RaisedButton getButton() {
    if(qID >= 15) {
      return RaisedButton(
        child: Text("Submit"),
        onPressed: submit,
        color: Colors.grey,
      );
    }
    else {
      return RaisedButton(
        child: Text("Next"),
        onPressed: onPressedNext,
        color: Colors.grey,
      );
    }
  }

  void submit() {
    newQuiz = new Quiz(quizID: quizIDController.text, quizName: quizNameController.text, questions: questions);
    //jsonFile.writeToFile(newQuiz);
    //Navigator.of(context).pop();

    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TambolaTicket(quiz: newQuiz)
    ));
  }

  void onPressedNext() {
    setState(() {
      Questions temp = new Questions(
          qID: qID,
          question: questionController.text,
          options: [
            op1Controller.text,
            op2Controller.text,
            op3Controller.text,
            op4Controller.text
          ],
          answer: int.parse(answerController.text));
      questions.add(temp);
      qID++;
      clearTextFieldsFromCard();
    });
  }

  void clearTextFieldsFromCard() {
      questionController.clear();
      op1Controller.clear();
      op2Controller.clear();
      op3Controller.clear();
      op4Controller.clear();
      answerController.clear();
  }

  void reset() {
    setState(() {
      qID=1;
      questions.clear();
      clearTextFieldsFromCard();
      quizIDController.clear();
      quizNameController.clear();
      flag1 = false;
    });
  }
} 





// class CheckPage extends StatefulWidget {

//   CheckPage();

  

//   @override
//   _CheckPageState createState() => _CheckPageState();
// }

// class _CheckPageState extends State<CheckPage> {

//   JSONHandler handler;

//   Quiz quiz;

//   @override
//   Widget build(BuildContext context) {
//     setState(() {
//       handler = new JSONHandler();
//       quiz = handler.getData();
//     });

    
 
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("check")
//       ),
//       body: Container(
//         child: Text(handler.fileExists.toString()),
//       ),
//     );
//   }

// }