import 'package:dio/dio.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:exam/config/config.dart';
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
      answers = item['answers'];
      int i = 0;
      for (var ans in item['answers']) {
        i = i + 1;
        if (i == 1) {
          answer1Controller.value = TextEditingValue(text: ans['answer']);
        } else if (i == 2) {
          answer2Controller.value = TextEditingValue(text: ans['answer']);
        } else if (i == 3) {
          answer3Controller.value = TextEditingValue(text: ans['answer']);
        } else {
          answer4Controller.value = TextEditingValue(text: ans['answer']);
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
            padding: EdgeInsets.all(10.0),
            child: Container(
                padding: EdgeInsets.all(10.0),
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          color: Colors.red,
                        ),
                        TextFormField(
                          controller: questionController,
                          minLines: 3,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: translate('Question'),
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
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: answer1Controller,
                                      decoration: InputDecoration(
                                        labelText: translate('Answer A'),
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
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: answer2Controller,
                                      decoration: InputDecoration(
                                        labelText: translate('Answer B'),
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
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: answer3Controller,
                                      decoration: InputDecoration(
                                        labelText: translate('Answer C'),
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
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: answer4Controller,
                                      decoration: InputDecoration(
                                        labelText: translate('Answer D'),
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
            child: Text(
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
                Text(
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
    return Row(
      children: [
        qa['answer_true'] == '0'
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${an}'),
              )
            : Container(
                decoration:
                    BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${an}'),
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${qa['answer']}'),
        ),
      ],
    );
  }
}
