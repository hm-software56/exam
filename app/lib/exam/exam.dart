import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:exam/classroom/class_roor.dart';
import 'package:exam/config/config.dart';
import 'package:exam/exam/question.dart';
import 'package:exam/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class Exam extends StatefulWidget {
  const Exam({Key? key}) : super(key: key);

  @override
  _ExamState createState() => _ExamState();
}

class _ExamState extends State<Exam> {
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

/**=========== List Exam room===================*/
  var dataListExam = [];
  bool isShowForm = true;
  Future<void> listDataExam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    var subject_id;
    for (var item in dataListSubject) {
      if (item['title'] == subjectTitleController.text) {
        subject_id = item['id'];
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id
      });
      var response = await Dio().post('${urlapi}api/listexam', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataListExam = response.data;
        if (dataListExam.length == 0) {
          isShowForm = true;
        }
        setState(() {
          dataListExam;
          isShowForm;
        });
      }
    } catch (e) {
      print('Wrong List Exam');
      //AlertLoss();
    }
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
  var class_room_id;
  Future<void> listDataSubject(var class_room_name) async {
    listSubject = [];
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    for (var item in dataList) {
      if (item['class_room_name'] == class_room_name) {
        class_room_id = item['id'];
        setState(() {
          class_room_id;
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

  codeGenerateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    String code =
        List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();

    codeURLController.value = TextEditingValue(text: code);
  }

  totalTimeExam() {
    final start_time = DateTime.parse(startDateController.text);
    final end_time = DateTime.parse(endDateController.text);
    var total = end_time.difference(start_time).inMinutes;
    timeAnswerController.value = TextEditingValue(text: total.toString());
  }

  final formKey = GlobalKey<FormState>();
  final classRoomController = TextEditingController();
  final subjectTitleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final codeURLController = TextEditingController();
  final timeAnswerController = TextEditingController();
  Future<void> creatExamRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    var subject_id;
    for (var item in dataListSubject) {
      if (item['title'] == subjectTitleController.text) {
        subject_id = item['id'];
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'url_answer': codeURLController.text,
        'time_answer': timeAnswerController.text
      });
      var response =
          await Dio().post('${urlapi}api/createexam', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        listDataExam();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Question(
                  data: response.data,
                  subject_title: subjectTitleController.text,
                  class_room_name: classRoomController.text)),
        );
      }
    } catch (e) {
      print('Wrong Create Exam');
      //AlertLoss();
    }
  }

  Future<void> resetAllFieldToNull() async {
    setState(() {
      subjectTitleController.value = TextEditingValue.empty;
      classRoomController.value = TextEditingValue.empty;
      startDateController.value = TextEditingValue.empty;
      endDateController.value = TextEditingValue.empty;
      codeURLController.value = TextEditingValue.empty;
      timeAnswerController.value = TextEditingValue.empty;
    });
  }

  int exam_id = 0;
  Future<void> selecteditExam(var item) async {
    listDataSubject(item['subject']['classRoom']['class_room_name']);
    setState(() {
      isShowForm = true;
      exam_id = int.parse(item['id']);
      subjectTitleController.value =
          TextEditingValue(text: item['subject']['title']);
      classRoomController.value = TextEditingValue(
          text: item['subject']['classRoom']['class_room_name']);
      startDateController.value = TextEditingValue(text: item['start_time']);
      endDateController.value = TextEditingValue(text: item['end_time']);
      codeURLController.value = TextEditingValue(text: item['url_answer']);
      timeAnswerController.value = TextEditingValue(text: item['time_answer']);
    });
  }

  Future<void> editExamRoom() async {
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    var subject_id;
    for (var item in dataListSubject) {
      if (item['title'] == subjectTitleController.text) {
        subject_id = item['id'];
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'url_answer': codeURLController.text,
        'time_answer': timeAnswerController.text,
        'exam_id': exam_id
      });
      var response = await Dio().post('${urlapi}api/editexam', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        listDataExam();
        Navigator.pop(context);
        AlertDone(translate('Successfull Edited.!'));
        resetAllFieldToNull();
        codeGenerateRandomString(10);
        setState(() {
          isShowForm = true;
          exam_id = 0;
        });
      }
    } on DioError catch (e) {
      Navigator.pop(context);
      // print(e.response);
      print('Wrong Edit Exam.!');
      //AlertLoss();
    }
  }

  Future<void> deleteExamRoom(var item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap(
          {'tokenID': apitoken, 'teacher_id': user_id, 'exam_id': item['id']});
      var response =
          await Dio().post('${urlapi}api/deleteexam', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        listDataExam();
        AlertDone(translate('Successfull Deleted.!'));
      }
    } catch (e) {
      print('Wrong Delete Exam');
      //AlertLoss();
    }
  }

  Future<void> duplicateExam(var item) async {
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    codeGenerateRandomString(10);
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'exam_id': item['id'],
        'url_answer': codeURLController.text,
      });
      var response =
          await Dio().post('${urlapi}api/duplicateexam', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        listDataExam();
        Navigator.pop(context);
        AlertDone(translate('Successfull Duplicated.!'));
        codeGenerateRandomString(10);
      }
    } catch (e) {
      print('Wrong duplicate Exam');
      //AlertLoss();
    }
  }

  @override
  void initState() {
    super.initState();
    listDataClassRoom();
    codeGenerateRandomString(10);
    listDataExam();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Center(
          child: Text(translate('Class exam')),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          color: Colors.white,
          child: Container(
            //height: MediaQuery.of(context).size.height - 90,
            // width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.blue, spreadRadius: 1),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Visibility(
                      visible: isShowForm,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                translate('Choose class room and subject'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: DropdownSearch<String>(
                                    //searchBoxController: classRoomController,
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
                                    selectedItem: classRoomController.text,
                                    label: translate("Class Room"),
                                    showSearchBox: false,
                                    onChanged: (value) {
                                      classRoomController.value =
                                          TextEditingValue(text: '${value}');
                                      listDataSubject(value);
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: DropdownSearch<String>(
                                    //searchBoxController: subjectTitleController,
                                    mode: Mode.MENU,
                                    validator: (dynamic value) {
                                      if (value == null || value.isEmpty) {
                                        return translate(
                                            'Please select subject');
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
                                    selectedItem: subjectTitleController.text,
                                    label: translate("Subject"),
                                    showSearchBox: false,
                                    onChanged: (value) {
                                      subjectTitleController.value =
                                          TextEditingValue(text: '${value}');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DateTimePicker(
                            controller: startDateController,
                            type: DateTimePickerType.dateTimeSeparate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: translate('Start Date'),
                            timeLabelText: translate("Hour"),
                            selectableDayPredicate: (date) {
                              // Disable weekend days to select from the calendar
                              if (date.weekday == 6 || date.weekday == 7) {
                                return true;
                              }
                              return true;
                            },
                            onChanged: (val) {
                              totalTimeExam();
                            },
                            validator: (val) {
                              if (val!.length < 16) {
                                return translate(
                                    'Please select  start date and time');
                              }
                              return null;
                            },
                            //onSaved: (val) => print(val),
                          ),
                          DateTimePicker(
                            controller: endDateController,
                            type: DateTimePickerType.dateTimeSeparate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: translate('End Date'),
                            timeLabelText: translate("Hour"),
                            selectableDayPredicate: (date) {
                              // Disable weekend days to select from the calendar
                              if (date.weekday == 6 || date.weekday == 7) {
                                return true;
                              }
                              return true;
                            },
                            onChanged: (val) {
                              totalTimeExam();
                            },
                            validator: (val) {
                              if (val!.length < 16) {
                                return translate(
                                    'Please select  end date and time');
                              }
                              return null;
                            },
                            //onSaved: (val) => print(val),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: timeAnswerController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: translate('Total Time'),
                                  ),
                                  validator: (val) {
                                    if (int.parse(timeAnswerController.text) <=
                                        0) {
                                      return translate(
                                          'Please check you start time or end time incorrect');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: codeURLController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: translate('Code Exam'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (exam_id == 0) {
                                  creatExamRoom();
                                } else {
                                  editExamRoom();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: exam_id == 0
                                  ? Colors.blueAccent
                                  : Colors.deepPurple, // Background color
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    exam_id == 0
                                        ? translate('Create Exam')
                                        : translate('Edit Exam'),
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
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          translate('Class Exam Room'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isShowForm) {
                              isShowForm = false;
                            } else {
                              isShowForm = true;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(color: Colors.indigo, spreadRadius: 2),
                            ],
                          ),
                          child: Row(
                            children: [
                              isShowForm ? Icon(Icons.remove) : Icon(Icons.add),
                              Text(
                                isShowForm
                                    ? translate('Hidden Form')
                                    : translate('Create Exam Room'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.red,
                  ),
                  Table(
                    columnWidths: examColumnWidths,
                    border: TableBorder.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1),
                    children: [
                      TableRow(children: [
                        Container(
                          color: Colors.lightBlue,
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(children: [
                              Text(
                                translate('Class room'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ]),
                          ),
                        ),
                        Container(
                          color: Colors.lightBlue,
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(children: [
                              Text(
                                translate('Subject'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ]),
                          ),
                        ),
                        Container(
                          color: Colors.lightBlue,
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(children: [
                              Text(
                                translate('Date Exam'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ]),
                          ),
                        ),
                        Container(
                          color: Colors.lightBlue,
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(children: [
                              Text(
                                translate('Time Exam'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ]),
                          ),
                        ),
                        Container(
                          color: Colors.lightBlue,
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(children: [
                              Text(
                                translate('Code Exam'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ]),
                          ),
                        ),
                        Container(
                          color: Colors.lightBlue,
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(children: [
                              Text(
                                translate('Question'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]),
                          ),
                        ),
                        Column(children: [
                          Text('', style: TextStyle(fontSize: 20.0))
                        ]),
                      ]),
                      for (var item in dataListExam) tableListExam(item)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow tableListExam(var item) {
    final now = DateTime.now();
    final end_time = DateTime.parse(item['end_time']);
    var endExam = end_time.difference(now).inMinutes;

    return TableRow(children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(
              '${item['subject']['classRoom']['class_room_name']}',
              style: TextStyle(),
            ),
          )
        ]),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(
              '${item['subject']['title']}',
              style: TextStyle(),
            ),
          )
        ]),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text('${item['start_time'].toString().substring(0, 10)}'),
          )
        ]),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(
              '${item['start_time'].toString().substring(10, 16)}' +
                  ' -' +
                  '${item['end_time'].toString().substring(10, 16)}',
              style: TextStyle(),
            ),
          )
        ]),
      ),
      Column(children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  child: Text(
                    '${item['url_answer']}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(2),
              child: InkWell(
                child: Icon(
                  Icons.copy_rounded,
                  size: 20,
                ),
                onTap: () {
                  AlertDone(translate('Coppied code exam.!'));
                  Clipboard.setData(ClipboardData(text: item['url_answer']));
                },
              ),
            ),
          ],
        ),
      ]),
      Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Question(
                          data: item,
                          subject_title: item['subject']['title'],
                          class_room_name: item['subject']['classRoom']
                              ['class_room_name'])),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Icon(
                  Icons.quiz_sharp,
                  color: Colors.brown,
                ),
              ),
            ))
      ]),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: endExam <= 0
                ? InkWell(
                    onTap: () {
                      duplicateExam(item);
                    },
                    child: Icon(
                      Icons.control_point_duplicate_outlined,
                      color: Colors.grey,
                    ),
                  )
                : Row(
                    children: [
                      InkWell(
                        onTap: () {
                          deleteExamRoom(item);
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
      ),
    ]);
  }
}
