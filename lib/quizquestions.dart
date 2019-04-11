class Quiz {
  String quizID;
  String quizName;
  List<Questions> questions;

  Quiz({this.quizID, this.quizName, this.questions});

  Quiz.fromJson(Map<String, dynamic> json) {
    quizID = json['quizID'];
    quizName = json['quizName'];
    if (json['quizQuestions'] != null) {
      questions = new List<Questions>();
      json['quizQuestions'].forEach((v) {
        questions.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quizID'] = this.quizID;
    data['quizName'] = this.quizName;
    if (this.questions != null) {
      data['questions'] =
          this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    String temp = (
      "quizID: " + quizID +
      "\nQuiz Name: " + quizName  
    );

    questions.forEach((v) {
      temp += v.toString();
    });
    return temp;
  }

  void reset() {
    for(int i=0; i<15; i++) {
      this.questions[i].isCorrect = 0;
    }
  }
}

class Questions {
  int qID;
  String question;
  List<String> options;
  int answer;
  int isCorrect = 0;
  
  Questions({this.qID, this.question, this.options, this.answer});

  Questions.fromJson(Map<String, dynamic> json) {
    qID = json['qID'];
    question = json['question'];
    options = json['options'].cast<String>();
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qID'] = this.qID;
    data['question'] = this.question;
    data['options'] = this.options;
    data['answer'] = this.answer;
    return data;
  }

  @override
  String toString() {
    return (
      "\nQuestion $qID: " + question +
      "\nOptions: " + options[0] + " | " + options[1] + " | " + options[2] + " | " + options[3] + "." +
      "\nAnswer: " + answer.toString()
    );
  }
}