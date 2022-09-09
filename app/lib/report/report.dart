import 'package:dio/dio.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:exam/absent/absent_history.dart';
import 'package:exam/config/config.dart';
import 'package:exam/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
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

  /**=========== List student ===================*/
  var dataListStudent = [];
  Future<void> listDataStudent(var subject_title) async {
    Loading();
    setState(() {
      dataListStudent = [];
      dataScoreExam = null;
      dataScoreActivity = null;
      dataScoreClassRoom = null;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');

    for (var item in dataListSubject) {
      if (item['title'] == subject_title) {
        setState(() {
          subject_id = item['id'];
          subject_titles = subject_title;
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
        listScoreClassRoom(dataListStudent);
        listScoreActivity(dataListStudent);
        listScoreExam(dataListStudent);
        setState(() {
          dataListStudent;
        });
      }
    } catch (e) {
      print('Wrong List Student');
      //AlertLoss();
    }
    Navigator.pop(context);
  }

/**=========== List ScoreClassRoom ===================*/
  var dataScoreClassRoom;
  Future<void> listScoreClassRoom(var students) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'students': students,
        'subject_id': subject_id
      });
      var response =
          await Dio().post('${urlapi}api/sumscoreclassroom', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataScoreClassRoom = response.data;
        setState(() {
          dataScoreClassRoom;
        });
      }
    } catch (e) {
      print('Wrong List sum score class room');
      //AlertLoss();
    }
  }

/**=========== List Score Activity ===================*/
  var dataScoreActivity;
  Future<void> listScoreActivity(var students) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'students': students,
        'subject_id': subject_id
      });
      var response =
          await Dio().post('${urlapi}api/sumscoreactivity', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataScoreActivity = response.data;
        setState(() {
          dataScoreActivity;
        });
      }
    } catch (e) {
      print('Wrong List sum score activity');
      //AlertLoss();
    }
  }

  /**=========== List Score Exam ===================*/
  var dataScoreExam;
  Future<void> listScoreExam(var students) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'students': students,
        'subject_id': subject_id
      });
      var response =
          await Dio().post('${urlapi}api/sumscoreexam', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataScoreExam = response.data;
        setState(() {
          dataScoreExam;
        });
      }
    } on DioError catch (e) {
      print(e.response);
      print('Wrong List sum score exam');
      //AlertLoss();
    }
  }

  Widget scoreGPA(var score_class_room, var score_activity, var score_exam) {
    int a = score_class_room is int
        ? score_class_room
        : int.parse(score_class_room);
    int b = score_activity is int ? score_activity : int.parse(score_activity);
    int c = score_exam is int ? score_exam : int.parse(score_exam);

    final gpa = a + b + c;
    return Text(gpa.toString());
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
            child: Text(translate('Report Score')),
          ),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.blue, spreadRadius: 1),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        translate('Choose class room and subject'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Divider(
                        color: Colors.red,
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
                                    return translate(
                                        'Please select class room');
                                  }
                                  return null;
                                },
                                hint: translate("Select Class Room"),
                                dropdownSearchDecoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                showAsSuffixIcons: true,
                                showSelectedItems: true,
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
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                showAsSuffixIcons: true,
                                showSelectedItems: true,
                                items: listSubject,
                                label: translate("Subject"),
                                //selectedItem: subject_name,
                                showSearchBox: false,
                                onChanged: (value) {
                                  listDataStudent(value);
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
                                Table(
                                  //defaultColumnWidth: FixedColumnWidth(120.0),
                                  columnWidths: reportColumnWidths,
                                  border: TableBorder.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  children: [
                                    TableRow(children: [
                                      Column(children: [
                                        Container(
                                          alignment: Alignment.center,
                                          color: Colors.lightBlue,
                                          padding:
                                              EdgeInsets.fromLTRB(5, 2, 5, 2),
                                          child: Text(
                                            translate('No.'),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ]),
                                      Container(
                                        alignment: Alignment.center,
                                        color: Colors.lightBlue,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  translate('Full name'),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ]),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        color: Colors.lightBlue,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(children: [
                                            Text(
                                              translate('Score class room'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        color: Colors.lightBlue,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(children: [
                                            Text(
                                              translate('Score activity'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        color: Colors.lightBlue,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(children: [
                                            Text(
                                              translate('Score exam'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        color: Colors.green,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(children: [
                                            Text(translate('Score GPA'))
                                          ]),
                                        ),
                                      ),
                                    ]),
                                    for (var item in dataListStudent)
                                      tableItem(item)
                                  ],
                                ),
                              ],
                            ),
                    ],
                  )),
            ),
          ],
        ));
  }

  int i = 0;
  TableRow tableItem(var item) {
    i = i + 1;
    int j = i;
    if (i == dataListStudent.length) {
      i = 0;
    }

    return TableRow(children: [
      Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Center(child: Text(j.toString())),
        )
      ]),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text('${item['first_name']}' + " " + '${item['last_name']}'),
          )
        ]),
      ),
      Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Center(
              child: dataScoreClassRoom == null
                  ? SpinKitWave(
                      color: Colors.blue,
                      size: 10.0,
                    )
                  : Text(
                      '${dataScoreClassRoom[item['id'].toString()].toString()}')),
        )
      ]),
      Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Center(
              child: dataScoreActivity == null
                  ? SpinKitWave(
                      color: Colors.blue,
                      size: 10.0,
                    )
                  : Text(
                      '${dataScoreActivity[item['id'].toString()].toString()}')),
        )
      ]),
      Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Center(
              child: dataScoreExam == null
                  ? SpinKitWave(
                      color: Colors.blue,
                      size: 10.0,
                    )
                  : Text('${dataScoreExam[item['id'].toString()].toString()}')),
        )
      ]),
      Column(children: [
        dataScoreActivity == null ||
                dataScoreClassRoom == null ||
                dataScoreExam == null
            ? SpinKitWave(
                color: Colors.blue,
                size: 10.0,
              )
            : scoreGPA(
                dataScoreClassRoom[item['id'].toString()],
                dataScoreActivity[item['id'].toString()],
                dataScoreExam[item['id'].toString()])
      ]),
    ]);
  }
}
