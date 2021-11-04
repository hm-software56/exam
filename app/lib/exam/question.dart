import 'package:dio/dio.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:exam/config/config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Question extends StatefulWidget {
  var data;
  var subject_title;
  var class_room_name;
  Question(
      {Key? key,
      required this.data,
      required this.subject_title,
      this.class_room_name})
      : super(key: key);

  @override
  _QuestionState createState() =>
      _QuestionState(this.data, this.subject_title, this.class_room_name);
}

class _QuestionState extends State<Question> {
  var data;
  var subject_title;
  var class_room_name;
  _QuestionState(this.data, this.subject_title, this.class_room_name);

  final formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();
  final answer3Controller = TextEditingController();
  final answer4Controller = TextEditingController();
  final answerCorrectController = TextEditingController();
  List<String> answerCorrect = [
    translate('A'),
    translate('B'),
    translate('C'),
    translate('D'),
  ];

  /** =================Loading =============== */
  Future<void> Loading() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(translate('Loading...')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

/** =================AlertDone =============== */
  Future<void> AlertDone(String msg) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.done_all_outlined,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(msg)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> creatQuestion() async {
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    int answer_correct = 0;
    int i = 0;
    for (var item in answerCorrect) {
      i = i + 1;
      if (item == answerCorrectController.text) {
        answer_correct = i;
        break;
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': data['subject_id'],
        'exam_id': data['id'],
        'question': questionController.text,
        'answer1': answer1Controller.text,
        'answer2': answer2Controller.text,
        'answer3': answer3Controller.text,
        'answer4': answer4Controller.text,
        'answer_correct': answer_correct
      });
      var response =
          await Dio().post('${urlapi}api/creatquestion', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        ListQuestion();
        resetAllFieldToNull();
      }
    } catch (e) {
      print('Wrong Create Question');
      //AlertLoss();
    }
    Navigator.pop(context);
  }

  int question_id = 0;
  var answers;
  Future<void> selecteditExam(var item) async {
    setState(() {
      question_id = int.parse(item['id']);
      questionController.value = TextEditingValue(text: item['question']);
      String extension = item['question'].toString().split('.').last;
      if (exts.contains(extension)) {
        qtImg = item['question'];
      }
      answers = item['answers'];
      int i = 0;
      for (var ans in item['answers']) {
        i = i + 1;
        if (i == 1) {
          answer1Controller.value = TextEditingValue(text: ans['answer']);
          String extension = ans['answer'].toString().split('.').last;
          if (exts.contains(extension)) {
            asw1Img = ans['answer'];
          }
        } else if (i == 2) {
          answer2Controller.value = TextEditingValue(text: ans['answer']);
          String extension = ans['answer'].toString().split('.').last;
          if (exts.contains(extension)) {
            asw2Img = ans['answer'];
          }
        } else if (i == 3) {
          answer3Controller.value = TextEditingValue(text: ans['answer']);
          String extension = ans['answer'].toString().split('.').last;
          if (exts.contains(extension)) {
            asw3Img = ans['answer'];
          }
        } else {
          answer4Controller.value = TextEditingValue(text: ans['answer']);
          String extension = ans['answer'].toString().split('.').last;
          if (exts.contains(extension)) {
            asw4Img = ans['answer'];
          }
        }
        if (int.parse(ans['answer_true']) == 1) {
          answerCorrectController.value =
              TextEditingValue(text: answerCorrect[i - 1]);
        }
      }
    });
  }

  Future<void> editQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    int answer_correct = 0;
    int i = 0;
    for (var item in answerCorrect) {
      i = i + 1;
      if (item == answerCorrectController.text) {
        answer_correct = i;
        break;
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': data['subject_id'],
        'exam_id': data['id'],
        'question': questionController.text,
        'answer1': answer1Controller.text,
        'answer2': answer2Controller.text,
        'answer3': answer3Controller.text,
        'answer4': answer4Controller.text,
        'answer_correct': answer_correct,
        'question_id': question_id,
        'answers': answers
      });
      var response =
          await Dio().post('${urlapi}api/editquestion', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        ListQuestion();
        resetAllFieldToNull();
        AlertDone(translate('Successfull Edited.!'));
      }
    } catch (e) {
      print('Wrong Create Question');
      //AlertLoss();
    }
  }

  Future<void> resetAllFieldToNull() async {
    setState(() {
      questionController.value = TextEditingValue.empty;
      answer1Controller.value = TextEditingValue.empty;
      answer2Controller.value = TextEditingValue.empty;
      answer3Controller.value = TextEditingValue.empty;
      answer4Controller.value = TextEditingValue.empty;
      answerCorrectController.value = TextEditingValue.empty;
      qtImg = null;
      asw1Img = null;
      asw2Img = null;
      asw3Img = null;
      asw4Img = null;
      question_id = 0;
      answers = [];
    });
  }

  Future<void> deleteQuestion(var item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'question_id': item['id']
      });
      var response =
          await Dio().post('${urlapi}api/deletequestion', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        ListQuestion();
        AlertDone(translate('Successfull Deleted.!'));
      }
    } catch (e) {
      print('Wrong Delete Question');
      //AlertLoss();
    }
  }

  /**=================== List Question =================== */
  var listDataQuestion = [];
  Future<void> ListQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    int answer_correct = 0;
    int i = 0;
    for (var item in answerCorrect) {
      i = i + 1;
      if (item == answerCorrectController.text) {
        answer_correct = i;
        break;
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': data['subject_id'],
        'exam_id': data['id'],
      });
      var response =
          await Dio().post('${urlapi}api/listquestion', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        listDataQuestion = response.data;
        setState(() {
          listDataQuestion;
        });
      }
    } catch (e) {
      print('Wrong List Question');
      //AlertLoss();
    }
  }

  var qtImg;
  var asw1Img;
  var asw2Img;
  var asw3Img;
  var asw4Img;
  List exts = ['png', 'jpg', 'PNG', 'JPG'];
  Future<void> uploadImage(var type) async {
    Loading();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String path_file_name = result.files.single.path.toString();
      String extension = result.names[0].toString().split('.').last;

      if (exts.contains(extension)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final apitoken = await prefs.getString('apitoken');
        final user_id = await prefs.getInt('user_id');
        try {
          var formData = FormData.fromMap({
            'tokenID': apitoken,
            'class_room_id': data['id'],
            'uploadimg': await MultipartFile.fromFile(path_file_name,
                filename: result.names[0]),
          });
          var response =
              await Dio().post('${urlapi}api/uploadimage', data: formData);
          if (response.statusCode == 200 && response.data != null) {
            if (type == 'qt') {
              questionController.value = TextEditingValue(text: response.data);
              setState(() {
                qtImg = response.data;
              });
            } else if (type == 'asw1') {
              answer1Controller.value = TextEditingValue(text: response.data);
              setState(() {
                asw1Img = response.data;
              });
            } else if (type == 'asw2') {
              answer2Controller.value = TextEditingValue(text: response.data);
              setState(() {
                asw2Img = response.data;
              });
            } else if (type == 'asw3') {
              answer3Controller.value = TextEditingValue(text: response.data);
              setState(() {
                asw3Img = response.data;
              });
            } else if (type == 'asw4') {
              answer4Controller.value = TextEditingValue(text: response.data);
              setState(() {
                asw4Img = response.data;
              });
            }

            print(response.data);
            Navigator.pop(context); // closs loading
          }
        } on DioError catch (e) {
          print(e.response);
          print('Wrong Upload images');
          Navigator.pop(context); // closs loading
        }
      } else {
        // Errors valudate extension
        print('Errors valudate extension');
        Navigator.pop(context); // closs loading
        uploadError(
            translate('Your file is not image file\nThen extension png, jpg'));
      }
    } else {
      // User canceled the picker
      Navigator.pop(context); // closs loading
    }
  }

  Future<void> uploadError(String msg) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msg, style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> removeImage(var type) async {
    if (type == 'qt') {
      questionController.value = TextEditingValue.empty;
      setState(() {
        qtImg = null;
      });
    } else if (type == 'asw1') {
      answer1Controller.value = TextEditingValue.empty;
      setState(() {
        asw1Img = null;
      });
    } else if (type == 'asw2') {
      answer2Controller.value = TextEditingValue.empty;
      setState(() {
        asw2Img = null;
      });
    } else if (type == 'asw3') {
      answer3Controller.value = TextEditingValue.empty;
      setState(() {
        asw3Img = null;
      });
    } else if (type == 'asw4') {
      answer4Controller.value = TextEditingValue.empty;
      setState(() {
        asw4Img = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ListQuestion();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(translate('Questions')),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10.0),
            child: Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.blueGrey, spreadRadius: 2),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            translate('Class Room') +
                                ": " +
                                class_room_name +
                                ", " +
                                translate('Suject Exam') +
                                ": " +
                                subject_title +
                                ", " +
                                translate('Exam Code') +
                                ": " +
                                data['url_answer'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(
                          color: Colors.red,
                        ),
                        qtImg != null
                            ? Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(translate('Question')),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          removeImage('qt');
                                        },
                                        child: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                  Image.network("$urlfile/$qtImg"),
                                  const Divider()
                                ],
                              )
                            : TextFormField(
                                controller: questionController,
                                minLines: 3,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: translate('Question'),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      uploadImage('qt');
                                    },
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return translate('Please input question');
                                  }
                                  return null;
                                },
                              ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 18, 8, 0),
                                    child: Text(
                                      translate('A') + ":",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: asw1Img != null
                                        ? Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(translate('Answer A')),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      removeImage('asw1');
                                                    },
                                                    child: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Image.network(
                                                  "$urlfile/$asw1Img"),
                                              const Divider()
                                            ],
                                          )
                                        : TextFormField(
                                            controller: answer1Controller,
                                            decoration: InputDecoration(
                                              labelText: translate('Answer A'),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  uploadImage('asw1');
                                                },
                                                child: const Icon(
                                                  Icons.image,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return translate(
                                                    'Please input answer A');
                                              }
                                              return null;
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 18, 8, 0),
                                    child: Text(
                                      translate('B') + ":",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: asw2Img != null
                                        ? Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(translate('Answer B')),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      removeImage('asw2');
                                                    },
                                                    child: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Image.network(
                                                  "$urlfile/$asw2Img"),
                                              const Divider()
                                            ],
                                          )
                                        : TextFormField(
                                            controller: answer2Controller,
                                            decoration: InputDecoration(
                                              labelText: translate('Answer B'),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  uploadImage('asw2');
                                                },
                                                child: const Icon(
                                                  Icons.image,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return translate(
                                                    'Please input answer B');
                                              }
                                              return null;
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 18, 8, 0),
                                    child: Text(
                                      translate('C') + ":",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: asw3Img != null
                                        ? Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(translate('Answer C')),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      removeImage('asw3');
                                                    },
                                                    child: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Image.network(
                                                  "$urlfile/$asw3Img"),
                                                  const Divider()
                                            ],
                                          )
                                        : TextFormField(
                                            controller: answer3Controller,
                                            decoration: InputDecoration(
                                              labelText: translate('Answer C'),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  uploadImage('asw3');
                                                },
                                                child: const Icon(
                                                  Icons.image,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return translate(
                                                    'Please input answer C');
                                              }
                                              return null;
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 18, 8, 0),
                                    child: Text(
                                      translate('D') + ":",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: asw4Img != null
                                        ? Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(translate('Answer D')),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      removeImage('asw4');
                                                    },
                                                    child: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Image.network(
                                                  "$urlfile/$asw4Img"),
                                                  const Divider()
                                            ],
                                          )
                                        : TextFormField(
                                            controller: answer4Controller,
                                            decoration: InputDecoration(
                                              labelText: translate('Answer D'),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  uploadImage('asw4');
                                                },
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return translate(
                                                    'Please input answer D');
                                              }
                                              return null;
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        DropdownSearch<String>(
                          //searchBoxController: answerCorrectController,
                          stickMenuToBorder: true,
                          mode: Mode.MENU,
                          validator: (dynamic value) {
                            if (value == null || value.isEmpty) {
                              return translate('Please select correct answer');
                            }
                            return null;
                          },
                          hint: translate("Select correct answer"),
                          dropdownSearchDecoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          showAsSuffixIcons: true,
                          showSelectedItem: true,
                          items: answerCorrect,
                          selectedItem: answerCorrectController.text,
                          label: translate("Select correct answer"),
                          showSearchBox: false,
                          onChanged: (value) {
                            answerCorrectController.value =
                                TextEditingValue(text: '${value}');
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (question_id == 0) {
                                creatQuestion();
                              } else {
                                editQuestion();
                              }
                            }
                          },
                          color: question_id == 0
                              ? Colors.blueAccent
                              : Colors.pink,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  question_id == 0
                                      ? translate('Create question')
                                      : translate('Edit question'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          translate('List question and answer'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: Colors.red,
                        ),
                        listDataQuestion.length == 0
                            ? SizedBox()
                            : Table(
                                columnWidths: questionColumnWidths,
                                border: TableBorder.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1),
                                children: [
                                  TableRow(children: [
                                    Column(children: [
                                      Container(
                                        color: Colors.lightBlue,
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Text(
                                          translate('No.'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ]),
                                    Column(children: [
                                      Container(
                                        color: Colors.lightBlue,
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Text(
                                          translate('Question'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ]),
                                    Column(children: [
                                      Container(
                                        color: Colors.lightBlue,
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Text(
                                          translate('View Answer'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ]),
                                    Column(children: [Text('')]),
                                  ]),
                                  for (var item in listDataQuestion)
                                    Question(item)
                                ],
                              ),
                      ],
                    ),
                  ),
                )),
          ),
        ));
  }

  int i = 0;
  TableRow Question(var item) {
    int number = listDataQuestion.length - i;
    i = i + 1;
    if (number < 2) {
      i = 0;
    }
    String extension = item['question'].toString().split('.').last;
    bool questionImage = false;
    if (exts.contains(extension)) {
      questionImage = true;
    }
    return TableRow(children: [
      Column(children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Text(
            '${number.toString()}',
            style: TextStyle(),
          ),
        )
      ]),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: questionImage
                ? Image.network("$urlfile/${item['question']}")
                : Text(
                    '${item['question']}',
                  ),
          )
        ]),
      ),
      Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: TextButton(
              onPressed: () {
                Answer(item);
              },
              child: Row(
                children: [Icon(Icons.question_answer_sharp)],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black12),
              ),
            ))
      ]),
      Column(children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  deleteQuestion(item);
                },
                child: Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              ),
              Text(' | '),
              InkWell(
                  onTap: () {
                    selecteditExam(item);
                  },
                  child: Icon(
                    Icons.border_color,
                    color: Colors.blueAccent,
                  )),
            ],
          ),
        )
      ]),
    ]);
  }

  /** =================Loading =============== */
  Future<void> Answer(var item) async {
    String extension = item['question'].toString().split('.').last;
    bool questionImage = false;
    if (exts.contains(extension)) {
      questionImage = true;
    }

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                questionImage
                    ? Image.network("$urlfile/${item['question']}")
                    : Text(
                        '${item['question']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                Divider(
                  color: Colors.red,
                ),
                for (var qa in item['answers']) answerChoice(qa)
              ],
            ),
          ),
        );
      },
    );
  }

  int n = 0;
  Widget answerChoice(var qa) {
    String an = answerCorrect[n];
    n = n + 1;
    if (n == 4) {
      n = 0;
    }

    String extension = qa['answer'].toString().split('.').last;
    bool answerImage = false;
    if (exts.contains(extension)) {
      answerImage = true;
    }

    return Row(
      children: [
        qa['answer_true'] == '0'
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${an}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.green),
                  borderRadius: const BorderRadius.all(Radius.circular(
                          50) //                 <--- border radius here
                      ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${an}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: answerImage
              ? Image.network("$urlfile/${qa['answer']}")
              : Text('${qa['answer']}'),
        ),
      ],
    );
  }
}
