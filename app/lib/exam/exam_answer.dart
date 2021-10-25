import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:exam/config/config.dart';
import 'package:exam/exam/done_exam.dart';
import 'package:exam/home/home.dart';
import 'package:exam/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamAnswer extends StatefulWidget {
  var exam;
  var student;
  ExamAnswer({Key? key, required this.exam, required this.student})
      : super(key: key);

  @override
  _ExamAnswerState createState() => _ExamAnswerState(this.exam, this.student);
}

class _ExamAnswerState extends State<ExamAnswer> {
  var exam;
  var student;
  _ExamAnswerState(this.exam, this.student);

  var dataQuestion = [];
  int countQuestion=0;
  Future<void> listDataQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'exam_id': exam['id'],
        'subject_id': exam['subject']['id']
      });
      var response =
          await Dio().post('${urlapi}api/studentexam', data: formData);
      if (response.statusCode == 200 && response.data.length > 1) {
        dataQuestion = response.data;
        countQuestion=dataQuestion.length;
        listDataStudentAnswer(dataQuestion);
        setState(() {
          dataQuestion;
          countQuestion;
        });
      }
    } catch (e) {
      print('Wrong List Question');
    }
  }

  List<String> listAnswer = [
    translate('A'),
    translate('B'),
    translate('C'),
    translate('D'),
  ];
  Map<int, int> radioValuesChoice = {};
  Future<void> listDataStudentAnswer(var question) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'question': question,
        'student_id': student['id']
      });
      var response =
          await Dio().post('${urlapi}api/liststudentanswer', data: formData);
      if (response.statusCode == 200 && response.data.length > 1) {
        response.data.forEach((key, value) {
          Map<int, int> choiced = {int.parse(key): int.parse(value)};
          radioValuesChoice.addAll(choiced);
        });
        setState(() {
          radioValuesChoice;
        });
      }
    } on DioError catch (e) {
      print(e.response);
      print('Wrong List Student Answer');
    }
  }

  Widget timeExam() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final end_time = DateTime.parse(exam['end_time']);
        var endExam = end_time.difference(now).inMinutes;
        if (endExam < 1) {
          return DoneExam();
        } else {
          var text = translate("Time");
          if (endExam <= 5) {
            text = translate('Still time');
          }
          return Container(
              padding: EdgeInsets.all(2),
              color: endExam <= 5 ? Colors.amber[900] : Colors.green[900],
              child: Text(
                text + " " + endExam.toString() + " " + translate('Minutes'),
                style: TextStyle(color: Colors.white),
              ));
        }
      },
    );
  }

  bool timEnd = true;
  Future<void> checkTimeEnd() async {
    final now = DateTime.now();
    final end_time = DateTime.parse(exam['end_time']);
    var endExam = end_time.difference(now).inMinutes;
    if (endExam < 1) {
      timEnd = false;
    }
    setState(() {
      timEnd;
    });
  }

  Future<void> answerQuestion(var question_id, var answer_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'question_id': question_id,
        'answer_id': answer_id,
        'student_id': student['id'],
        'count_question':countQuestion,
        'exam_id':exam['id']
      });
      var response =
          await Dio().post('${urlapi}api/answerquestion', data: formData);
      if (response.statusCode == 200) {
          print('answer');
        //print(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
      print('Wrong Answer Question');
    }
  }

  Map<int, bool> visibleAnswer = {};

  /** =================AlertDone =============== */
  Future<void> AlertDone(var data) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.done_all,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(
                        data,
                      ),
                      Divider(
                        color: Colors.red,
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Home()),
                                  (route) => false);
                            },
                            color: Colors.green[900],
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.done_outline,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    translate('Exam done'),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.indigo,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    translate('Check answer more'),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkTimeEnd();
    listDataQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(translate('Start Exam')))),
      floatingActionButton: timeExam(),
      body: dataQuestion.length == 0
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.blue, spreadRadius: 2),
                ],
              ),
              child: timEnd == false
                  ? Stack()
                  : ListView(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: dataQuestion.length,
                          itemBuilder: (BuildContext context, int index) {
                            final question = dataQuestion[index];
                            var add = visibleAnswer[int.parse(question['id'])];
                            return ListTile(
                                //leading: Text((index + 1).toString()),
                                trailing: InkWell(
                                    onTap: () {
                                      bool vsb = false;
                                      if (visibleAnswer[
                                              int.parse(question['id'])] ==
                                          false) {
                                        vsb = true;
                                      }
                                      Map<int, bool> visible = {
                                        int.parse(question['id']): vsb
                                      };
                                      visibleAnswer.addAll(visible);
                                      setState(() {
                                        visibleAnswer;
                                      });
                                    },
                                    child: Icon(
                                      Icons.unfold_less,
                                      color: visibleAnswer[
                                                  int.parse(question['id'])] ==
                                              false
                                          ? Colors.red
                                          : Colors.grey,
                                    )),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text((index + 1).toString() + '. '),
                                        Expanded(
                                            child: Text(
                                                "${question['question']}")),
                                      ],
                                    ),
                                    Visibility(
                                      visible: visibleAnswer[
                                                  int.parse(question['id'])] ==
                                              false
                                          ? false
                                          : true,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: question['answers'].length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final answer =
                                                question['answers'][index];
                                            return ListTile(
                                                leading: Radio(
                                                  value:
                                                      int.parse(answer['id']),
                                                  groupValue: radioValuesChoice[
                                                      int.parse(
                                                          question['id'])],
                                                  onChanged: (val) {
                                                    checkTimeEnd();
                                                    if (timEnd) {
                                                      Map<int, int> choiced = {
                                                        int.parse(
                                                                question['id']):
                                                            int.parse(
                                                                answer['id'])
                                                      };
                                                      radioValuesChoice
                                                          .addAll(choiced);
                                                      answerQuestion(
                                                          question['id'],
                                                          answer['id']);
                                                      setState(() {
                                                        radioValuesChoice;
                                                      });
                                                    }
                                                  },
                                                ),
                                                title: Row(
                                                  children: [
                                                    Text(
                                                        "${listAnswer[index]}" +
                                                            ". "),
                                                    Expanded(
                                                        child: Text(
                                                            "${answer['answer']}")),
                                                  ],
                                                ));
                                          }),
                                    ),
                                  ],
                                ));
                          },
                        ),
                        radioValuesChoice.length != dataQuestion.length
                            ? SizedBox()
                            : Column(
                                children: [
                                  Divider(
                                    color: Colors.red,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      onPressed: () {
                                        AlertDone(translate(
                                            'You have done answer question\nGood luck to you.!'));
                                      },
                                      color: Colors.lightBlue[900],
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              translate('Answer done'),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ],
                    )),
    );
  }
}
