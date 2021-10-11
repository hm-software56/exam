import 'dart:io';
import 'dart:math';

import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:exam/absent/absent_history.dart';
import 'package:exam/activity/activity_histort.dart';
import 'package:exam/config/config.dart';
import 'package:exam/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
/**=========== List Class Room ===================*/
  var dataList = [];
  List<String> listCL = [];
  Future<void> listDataClassRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
      });
      var response =
          await Dio().post('${urlapi}api/listclassroom', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataList = response.data;
        for (var data in dataList) {
          listCL.add(data['class_room_name']);
        }
        setState(() {
          dataList;
          listCL;
          dataListStudent = [];
        });
      }
    } catch (e) {
      print('Wrong List class room');
      //AlertLoss();
    }
  }

  /**=========== List Subject ===================*/
  var dataListSubject = [];
  List<String> listSubject = [];
  var subject_id;
  var class_room_id;
  var class_room_names;
  var subject_titles;
  Future<void> listDataSubject(var class_room_name) async {
    listSubject = [];
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    for (var item in dataList) {
      if (item['class_room_name'] == class_room_name) {
        class_room_id = item['id'];
        class_room_names = class_room_name;
        setState(() {
          class_room_id;
          dataListStudent = [];
          class_room_names;
        });
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'class_room_id': class_room_id
      });
      var response = await Dio()
          .post('${urlapi}api/listsubjectbyclassroom', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataListSubject = response.data;
        for (var item in dataListSubject) {
          listSubject.add(item['title']);
        }
        setState(() {
          dataListSubject;
          listSubject;
        });
      }
    } catch (e) {
      print('Wrong List subject');
      //AlertLoss();
    }
    Navigator.pop(context);
  }

/**=========== List activity ===================*/
  var dataListActivity = [];
  List<String> listActivity = [];
  var activity_name;
  var activity_id;
  Future<void> listDataActivity() async {
    Loading();
    setState(() {
      dataListStudent = [];
      listActivity = [];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
      });
      var response =
          await Dio().post('${urlapi}api/listactivity', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataListActivity = response.data;
        for (var item in dataListActivity) {
          listActivity.add(item['name']);
        }
        setState(() {
          dataListActivity;
          listActivity;
        });
      }
    } catch (e) {
      print('Wrong List Activity');
    }
    Navigator.pop(context);
  }

  /**=========== List student ===================*/
  var dataListStudent = [];
  Future<void> listDataStudent(var subject_title) async {
    Loading();
    setState(() {
      dataListStudent = [];
      activityListDataScore = [];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    for (var item in dataListSubject) {
      if (item['title'] == subject_title) {
        setState(() {
          subject_id = item['id'];
        });
      }
    }
    for (var item in dataListActivity) {
      if (item['name'] == activity_name) {
        setState(() {
          activity_id = item['id'];
        });
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'class_room_id': class_room_id
      });
      var response =
          await Dio().post('${urlapi}api/liststudent', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataListStudent = response.data;
        setState(() {
          dataListStudent;
        });
        checkGenerateScore(dataListStudent);
      }
    } catch (e) {
      print('Wrong List Student');
      //AlertLoss();
    }
    Navigator.pop(context);
  }

  /**====================Check Generate score ============ */
  List activityListDataScore = [];
  Future<void> checkGenerateScore(var dataListStudent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'students': dataListStudent,
        'activity_id': activity_id
      });
      var response = await Dio()
          .post('${urlapi}api/activitycheckgeneratescore', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        if (response.data.length > 0) {
          activityListDataScore = response.data;
          setState(() {
            generatedScored = true;
            activityListDataScore;
          });
        } else {
          setState(() {
            generatedScored = false;
          });
        }
      }
    } catch (e) {
      print('Wrong check generadate date');
      //AlertLoss();
    }
  }

  /** ==========Generate Score ========== */
  bool generatedScored = false;
  Future<void> generateScore() async {
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'students': dataListStudent,
        'activity_id': activity_id
      });
      var response = await Dio()
          .post('${urlapi}api/activitygeneratescore', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        checkGenerateScore(dataListStudent);
      }
    } catch (e) {
      //print(e);
      print('Wrong generadate score');
    }
    Navigator.pop(context);
  }

  /** ==========Generate Check-In ========== */
  Future<void> deleteGenerateScore() async {
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'students': dataListStudent,
        'activity_id': activity_id,
      });
      var response =
          await Dio().post('${urlapi}api/deletegeneratescore', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          generatedScored = false;
          activityListDataScore = [];
        });
      }
    } catch (e) {
      print('Wrong reamve homwork');
      //AlertLoss();
    }
    Navigator.pop(context);
  }
  /** ==================== Edit edit Not Send Homwork ================= */

  Future<void> editNotSendHomwork(var value, var student) async {
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    int send = value ? 1 : 0;
    int score = value ? 1 : 0;
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'student_id': student['id'],
        'activity_id': activity_id,
        'send': send,
        'score': score
      });
      var response =
          await Dio().post('${urlapi}api/editnotsendhomwork', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        checkGenerateScore(dataListStudent);
      }
    } catch (e) {
      print('Wrong Edit not send home work');
      //AlertLoss();
    }
    Navigator.pop(context);
  }

/** ==================== Edit Input Score ================= */

  Future<void> editInputScore(var value, var student) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'student_id': student['id'],
        'activity_id': activity_id,
        'score': value
      });
      var response =
          await Dio().post('${urlapi}api/editinpuscore', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        print('done');
      }
    } catch (e) {
      print('Wrong Edit input score');
      //AlertLoss();
    }
  }

  /**============== CheckBox ============= */
  Widget checkBoxField(var student) {
    bool ischecked = false;
    for (var absent in activityListDataScore) {
      if (absent['student_id'] == student['id']) {
        if (absent['send'] == 1) {
          ischecked = true;
        }
      }
    }
    return generatedScored
        ? Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: ischecked,
            onChanged: (bool? value) {
              editNotSendHomwork(value, student);
            },
          )
        : Text('');
  }

  /**============== Input Score ============= */
  Widget textFieldScore(var student) {
    bool ischecked = false;
    int score = 0;
    for (var activity in activityListDataScore) {
      if (activity['student_id'] == student['id']) {
        if (activity['send'] == 1) {
          ischecked = true;
          score = activity['score'];
        }
      }
    }

    return ischecked
        ? TextField(
            maxLength: 2,
            controller: TextEditingController(text: '${score}'),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              counterText: "",
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              editInputScore(value, student);
            },
          )
        : Text('');
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

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

  /**======================== List student for not Q&A Class romm ================= */
  Widget tableListStudent() {
    return Table(
      //defaultColumnWidth: FixedColumnWidth(120.0),
      columnWidths: {
        0: FixedColumnWidth(70),
        1: FixedColumnWidth(70),
        2: FlexColumnWidth(),
        3: FixedColumnWidth(160),
      },
      border: TableBorder.all(
          color: Colors.black, style: BorderStyle.solid, width: 1),
      children: [
        TableRow(children: [
          Column(children: [
            Container(
              alignment: Alignment.center,
              color: Colors.lightBlue,
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                translate('Sent'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
          Column(children: [
            Container(
              alignment: Alignment.center,
              color: Colors.lightBlue,
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                translate('Score'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
          Column(children: [
            Container(
              alignment: Alignment.center,
              color: Colors.lightBlue,
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                translate('Full name'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
          Column(children: [
            Container(
              alignment: Alignment.center,
              color: Colors.green,
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: InkWell(
                onTap: () {
                  if (generatedScored) {
                    deleteGenerateScore();
                  } else {
                    generateScore();
                  }
                },
                child: generatedScored
                    ? Row(
                        children: [
                          Icon(
                            Icons.restore_page_sharp,
                            color: Colors.red,
                          ),
                          Text(
                            translate('Remove Homework'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.add_box_sharp,
                            color: Colors.deepOrange,
                          ),
                          Text(
                            translate('Score Homework'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            )
          ]),
        ]),
        for (var item in dataListStudent)
          TableRow(children: [
            Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Center(child: checkBoxField(item)),
              )
            ]),
            Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: textFieldScore(item),
              )
            ]),
            Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(
                    '${item['first_name']}' + " " + '${item['last_name']}'),
              )
            ]),
            Column(children: [
              TextButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      content: ActivityHistory(
                          activity_id: activity_id,
                          activity_name: activity_name,
                          class_room_id: class_room_id,
                          class_room_name: class_room_names,
                          subject_id: subject_id,
                          subject_title: subject_titles,
                          student: item)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      size: 20,
                    ),
                    Text(translate('History Score'))
                  ],
                ),
              ),
            ]),
          ]),
      ],
    );
  }

  bool isRandom = false;
  var studentSeleted = [];
  Future<void> randomStudent() async {
    setState(() {
      isRandom = true;
    });
    await Future.delayed(Duration(seconds: 5));
    var student = dataListStudent[Random().nextInt(dataListStudent.length)];
    studentSeleted.add(student);
    setState(() {
      isRandom = false;
    });
  }

  Future<void> randomStudentEnd() async {
    setState(() {
      studentSeleted = [];
      isRandom = false;
      student_answer = [];
    });
  }

/**============== Input textFieldAnswerScore ============= */
  Widget textFieldAnswerScore(var student) {
    var score = '';
    for (var item in student_answer) {
      if (student['id'].toString() == item['student_id'].toString()) {
        score = item['score'];
      }
    }
    return TextField(
      maxLength: 1,
      controller: TextEditingController(text: score),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        counterText: "",
        suffixIcon: IconButton(
          onPressed: () {},
          icon: score == ''
              ? Icon(Icons.keyboard)
              : Icon(
                  Icons.done,
                  color: Colors.green,
                ),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        InputQAScore(value, student);
      },
    );
  }

  /** ==================== Edit Input Score ================= */

  List student_answer = [];
  Future<void> InputQAScore(var value, var student) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    if (student_answer.length > 0) {
      var student_answers = student_answer;
      student_answer = [];
      for (var item in student_answers) {
        if (student['id'].toString() == item['student_id'].toString()) {
          print(item['id']);
          deleteQAScore(item['id']);
        } else {
          student_answer.add(item);
        }
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'student_id': student['id'],
        'activity_id': activity_id,
        'score': value
      });
      var response =
          await Dio().post('${urlapi}api/inputqascore', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        student_answer.add(response.data);
        setState(() {
          student_answer;
        });
      }
    } catch (e) {
      print('Wrong input Q&A score');
      setState(() {
        student_answer;
      });
      //AlertLoss();
    }
  }

/** ==================== Delete Input Score ================= */

  Future<void> deleteQAScore(var delete_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'delete_id': delete_id,
      });
      var response =
          await Dio().post('${urlapi}api/deleteqascore', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        print('delete');
      }
    } catch (e) {
      print('Wrong Delete Q&A score');
      //AlertLoss();
    }
  }

/**======================== List student for not Q&A Class romm ================= */
  Widget tableListStudentSeleted() {
    return Table(
      columnWidths: {
        0: FixedColumnWidth(100),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(160),
      },
      border: TableBorder.all(
          color: Colors.black, style: BorderStyle.solid, width: 1),
      children: [
        TableRow(children: [
          Column(children: [
            Container(
              alignment: Alignment.center,
              color: Colors.lightBlue,
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                translate('Score'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
          Column(children: [
            Container(
              alignment: Alignment.center,
              color: Colors.lightBlue,
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                translate('Full name'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
          Column(children: [
            Container(
                alignment: Alignment.center,
                color: Colors.lightBlue,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(''))
          ]),
        ]),
        for (var item in studentSeleted)
          TableRow(children: [
            Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: textFieldAnswerScore(item),
              )
            ]),
            Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(
                    '${item['first_name']}' + " " + '${item['last_name']}'),
              )
            ]),
            Column(children: [
              TextButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      content: ActivityHistory(
                          activity_id: activity_id,
                          activity_name: activity_name,
                          class_room_id: class_room_id,
                          class_room_name: class_room_names,
                          subject_id: subject_id,
                          subject_title: subject_titles,
                          student: item)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      size: 20,
                    ),
                    Text(translate('History Score'))
                  ],
                ),
              ),
            ]),
          ]),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    listDataClassRoom();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Center(
          child: Text(translate('Activities')),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.green, spreadRadius: 2),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Text(
                      translate('Choose class room and subject'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Divider(
                      color: Colors.red,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          validator: (dynamic value) {
                            if (value == null || value.isEmpty) {
                              return translate('Please select class room');
                            }
                            return null;
                          },
                          hint: translate("Select Class Room"),
                          dropdownSearchDecoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          showAsSuffixIcons: true,
                          showSelectedItem: true,
                          items: listCL,
                          label: translate("Class Room"),
                          showSearchBox: false,
                          onChanged: (value) {
                            listDataSubject(value);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          validator: (dynamic value) {
                            if (value == null || value.isEmpty) {
                              return translate('Please select subject');
                            }
                            return null;
                          },
                          hint: translate("Select Subject"),
                          dropdownSearchDecoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          showAsSuffixIcons: true,
                          showSelectedItem: true,
                          items: listSubject,
                          label: translate("Subject"),
                          showSearchBox: false,
                          onChanged: (value) {
                            setState(() {
                              subject_titles = value;
                            });
                            listDataActivity();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          validator: (dynamic value) {
                            if (value == null || value.isEmpty) {
                              return translate('Please select activity');
                            }
                            return null;
                          },
                          hint: translate("Select Activity"),
                          dropdownSearchDecoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          showAsSuffixIcons: true,
                          showSelectedItem: true,
                          items: listActivity,
                          label: translate("Activity"),
                          showSearchBox: false,
                          onChanged: (value) {
                            setState(() {
                              activity_name = value;
                            });
                            listDataStudent(subject_titles);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                dataListStudent.length == 0
                    ? SizedBox()
                    : Column(
                        children: [
                          activity_id == 1
                              ? Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        translate(
                                            'Choose student answer question'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.red,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: isRandom
                                                      ? Colors.green
                                                      : Colors.blue),
                                              child: Container(
                                                height: 100,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: isRandom
                                                    ? SpinKitSquareCircle(
                                                        color: Colors.white,
                                                        size: 50.0,
                                                      )
                                                    : Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.update,
                                                            size: 50,
                                                          ),
                                                          Text(
                                                            translate(
                                                                'Random Student'),
                                                            style: TextStyle(),
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                              onPressed: () {
                                                randomStudent();
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red),
                                              child: Container(
                                                height: 100,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.stop_circle_outlined,
                                                      size: 50,
                                                    ),
                                                    Text(
                                                      translate('End'),
                                                      style: TextStyle(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onPressed: () {
                                                randomStudentEnd();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        translate('List Students'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.red,
                                    ),
                                    tableListStudentSeleted()
                                  ],
                                )
                              : Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        translate('List Students'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.red,
                                    ),
                                    tableListStudent(),
                                  ],
                                )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
