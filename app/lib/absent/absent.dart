import 'package:dio/dio.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:exam/absent/absent_history.dart';
import 'package:exam/config/config.dart';
import 'package:exam/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Absent extends StatefulWidget {
  const Absent({Key? key}) : super(key: key);

  @override
  _AbsentState createState() => _AbsentState();
}

class _AbsentState extends State<Absent> {
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
        class_room_names=class_room_name;
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
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');

    for (var item in dataListSubject) {
      if (item['title'] == subject_title) {
        setState(() {
          subject_id = item['id'];
          subject_titles=subject_title;
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
        checkGenerateDate(dataListStudent);
      }
    } catch (e) {
      print('Wrong List Student');
      //AlertLoss();
    }
    Navigator.pop(context);
  }

  /**====================Check Generate date ============ */
  List absentListData = [];
  Future<void> checkGenerateDate(var dataListStudent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'students': dataListStudent
      });
      var response = await Dio()
          .post('${urlapi}api/absentcheckgeneratedate', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        if (response.data.length > 0) {
          absentListData = response.data;
          setState(() {
            generatedDate = true;
            absentListData;
          });
        } else {
          setState(() {
            generatedDate = false;
          });
        }
      }
    } catch (e) {
      print('Wrong check generadate date');
      //AlertLoss();
    }
  }

  /** ==========Generate Check-In ========== */
  bool generatedDate = false;
  Future<void> generateDate() async {
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'students': dataListStudent
      });
      var response =
          await Dio().post('${urlapi}api/absentgeneratedate', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        checkGenerateDate(dataListStudent);
      }
    } catch (e) {
      print('Wrong generadate date');
    }
    Navigator.pop(context);
  }

  /** ==========Generate Check-In ========== */
  Future<void> deleteGenerateDate() async {
    Loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'students': dataListStudent
      });
      var response = await Dio()
          .post('${urlapi}api/deleteabsentgeneratedate', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          generatedDate = false;
          absentListData = [];
        });
      }
    } catch (e) {
      print('Wrong delete generadate date');
      //AlertLoss();
    }
    Navigator.pop(context);
  }
  /** ==================== Edit Absent ================= */

  Future<void> editAbsent(var value, var student) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    int absent = value ? 1 : 0;
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'student_id': student['id'],
        'absent': absent
      });
      var response =
          await Dio().post('${urlapi}api/editabsent', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        checkGenerateDate(dataListStudent);
      }
    } catch (e) {
      print('Wrong Edit Absent');
      //AlertLoss();
    }
  }

  /** ==================== Edit Absent ================= */

  Future<void> editAbsentReason(var value, var student) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    int reason = value ? 1 : 0;
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'student_id': student['id'],
        'reason': reason
      });
      var response =
          await Dio().post('${urlapi}api/editabsentreason', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        checkGenerateDate(dataListStudent);
      }
    } catch (e) {
      print('Wrong Edit Absent');
      //AlertLoss();
    }
  }

  /**============== CheckBox ============= */
  Widget checkBoxField(var student) {
    bool ischecked = false;
    for (var absent in absentListData) {
      if (absent['student_id'] == student['id']) {
        if (absent['absent'] == 1) {
          ischecked = true;
        }
      }
    }
    return generatedDate
        ? Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: ischecked,
            onChanged: (bool? value) {
              editAbsent(value, student);
            },
          )
        : Text('');
  }

  /**============== CheckBox ============= */
  Widget checkBoxFieldReason(var student) {
    bool ischecked = false;
    bool is_come=true;
    for (var absent in absentListData) {
      if (absent['student_id'] == student['id']) {
        if (absent['reason'] == 1) {
          ischecked = true;
        }
        if (absent['absent'] == 1) {
          is_come = false;
        }
      }
    }
    return generatedDate && is_come
        ? Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: ischecked,
            onChanged: (bool? value) {
              editAbsentReason(value, student);
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
          child: Text(translate('Check Absent')),
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
                Text(
                  translate('Choose class room and subject'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Divider(
                            color: Colors.red,
                          ),
                          Table(
                            //defaultColumnWidth: FixedColumnWidth(120.0),
                            columnWidths: {
                              0: FixedColumnWidth(70),
                              1: FixedColumnWidth(90),
                              2: FlexColumnWidth(),
                              3: FixedColumnWidth(110),
                            },
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
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                    child: Text(
                                      translate('Check Name'),
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
                                      translate('Reason'),
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
                                        if (generatedDate) {
                                          deleteGenerateDate();
                                        } else {
                                          generateDate();
                                        }
                                      },
                                      child: generatedDate
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.restore_page_sharp,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  translate('Remove Form'),
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
                                                  translate('Generate From'),
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
                                      child: Center(child: checkBoxFieldReason(item)),
                                    )
                                  ]),
                                  Column(children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                      child: Text('${item['first_name']}' +
                                          " " +
                                          '${item['last_name']}'),
                                    )
                                  ]),
                                  Column(children: [
                                    TextButton(
                                      onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                                content: AbsentHistiry(
                                                    class_room_id:
                                                        class_room_id,
                                                    class_room_name:class_room_names,
                                                    subject_id: subject_id,
                                                    subject_title:subject_titles,
                                                    student: item)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.history,
                                            size: 20,
                                          ),
                                          Text(translate('History'))
                                        ],
                                      ),
                                    ),
                                  ]),
                                ]),
                            ],
                          ),
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
