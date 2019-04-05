import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'quizquestions.dart';

//class to handle all Quiz to JSON and vice-versa
class JSONHandler {
  File jsonFile;
  Directory dir;
  String fileName;
  bool fileExists = false;
  Map<String, dynamic> _fileContent;
  

  JSONHandler({this.fileName = "quizJSONfile.json"}) {
    getApplicationDocumentsDirectory().then((Directory directory) {
      this.dir = directory;
      print(directory);
      this.jsonFile = new File(this.dir.path + "/" + this.fileName);
      print(this.jsonFile);
      fileExists = jsonFile.existsSync();
      print(fileExists);
      if (fileExists)
        this._fileContent = jsonDecode(jsonFile.readAsStringSync());
    });
  }

  //create new json
  void createFile(Map<String, dynamic> content) {
    JSONHandler();
    jsonFile.writeAsStringSync(jsonEncode(content));
  }

  //write to JSON
  void writeToFile(Quiz quiz) {
    if (fileExists)
      jsonFile.writeAsStringSync(jsonEncode(quiz.toJson()));
    else {
      createFile(quiz.toJson());
    }
    _fileContent = jsonDecode(jsonFile.readAsStringSync());
  }

  //read data from current JSON
  Quiz getData() {
    return Quiz.fromJson(_fileContent);
  }

  Map<String, dynamic> getFileContent() {
    return _fileContent;
  }
}
