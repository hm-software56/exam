import 'package:dio/dio.dart';
import 'package:exam/config/config.dart';
import 'package:exam/exam/exam_answer.dart';
import 'package:flutter/material.dart';

import 'dart:io' show Platform;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamStudent extends StatefulWidget {
  const ExamStudent({Key? key}) : super(key: key);

  @override
  _ExamStudentState createState() => _ExamStudentState();
}

class _ExamStudentState extends State<ExamStudent> {
  final loginFormKey = GlobalKey<FormState>();
  final codeStudentController = TextEditingController();
  final codeExamController = TextEditingController();

  /**=============== Login ================ */
  bool isProccess = false;
  bool iswrong = false;
  Future<void> submitCheckExam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'code_student': codeStudentController.text,
        'code_exam': codeExamController.text
      });
      var response = await Dio().post('${urlapi}api/checkexam', data: formData);
      if (response.statusCode == 200 && response.data.length > 1) {
        //print(response.data);
        AlertDone(response.data);
        setState(() {
          isProccess = false;
          iswrong = false;
        });
      } else {
        setState(() {
          iswrong = true;
          isProccess = false;
        });
      }
    } catch (e) {
      print('Wrong check Exam');
      setState(() {
        iswrong = true;
        isProccess = false;
      });
    }
  }

  bool timStart = false;
  Future<void> checkTimeStart(var data) async {
    final now = DateTime.now();
    final startTime = DateTime.parse(data['start_time']);
    var startExam = startTime.difference(now).inMinutes;
    print(startExam);
    if (startExam < 1) {
      timStart = true;
    }
    setState(() {
      timStart;
    });
  }

  /** =================AlertDone =============== */
  Future<void> AlertDone(var data) async {
    checkTimeStart(data['exam']);
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
                    Icons.warning,
                    size: 50,
                    color: Colors.yellow,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(
                        translate('Subject Exam') +
                            ": " +
                            data['exam']['subject']['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(translate('Time exam') +
                          ": " +
                          DateFormat('MM/dd/yyyy hh:mm:ss').format(
                              DateTime.parse(data['exam']['start_time'])) +
                          " - " +
                          DateFormat('hh:mm:ss').format(
                              DateTime.parse(data['exam']['end_time'])) + " "+translate('Clock'), style: TextStyle(color: Colors.pink[900]),),
                      Divider(
                        color: Colors.red,
                      ),
                      Text(
                        translate('Name') +
                            ": " +
                            data['student']['first_name'] +
                            " " +
                            data['student']['last_name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        translate('Code') +
                            ": " +
                            data['student']['student_code'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.red,
                      ),
                      timStart
                          ? Text(
                              translate(
                                  'Please check you name is correct or not?'),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(
                              translate('It is not yet time exam.!'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      timStart == false
                          ? RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      translate('Close'),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          translate('Incorrect'),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ExamAnswer(
                                                exam: data['exam'],
                                                student: data['student'],
                                              )),
                                    );
                                  },
                                  color: Colors.green,
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
                                          translate('Correct'),
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

  CheckPlatform() {
    try {
      return Platform.operatingSystem; //in your code
    } catch (e) {
      return null; //in your code
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Center(child: Text(translate('Exam Class Room')))),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: CheckPlatform() == 'windows' ? 450 : null,
            child: Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: Colors.blue, spreadRadius: 2),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Center(
                              child: Text(
                                DateFormat('MM/dd/yyyy hh:mm:ss')
                                    .format(DateTime.now()),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          color: Colors.red,
                        ),
                        TextFormField(
                          controller: codeStudentController,
                          decoration: InputDecoration(
                              labelText: translate('Student Code')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('Please enter student code');
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: codeExamController,
                          decoration: InputDecoration(
                              labelText: translate('Exam Code')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate(
                                  'Please enter exam class room code');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        isProccess == true
                            ? SpinKitWave(
                                size: 30.0,
                                itemBuilder: (BuildContext context, int index) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: index.isEven
                                          ? Colors.blue
                                          : Colors.white,
                                    ),
                                  );
                                },
                              )
                            : RaisedButton(
                                onPressed: () {
                                  if (loginFormKey.currentState!.validate()) {
                                    setState(() {
                                      isProccess = true;
                                    });
                                    submitCheckExam();
                                  }
                                },
                                color: Colors.blueAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        translate('Exam Room'),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        iswrong
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Text(
                                  translate('Code student or exam incorrect.!'),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
