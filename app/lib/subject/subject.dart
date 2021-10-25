import 'package:dio/dio.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import '../config/config.dart';
import '../menu/menu.dart';
import '../student/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subject extends StatefulWidget {
  const Subject({Key? key}) : super(key: key);

  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final classRoomIDController = TextEditingController();
  final scoreClassRoomController = TextEditingController();
  final scoreActivityController = TextEditingController();
  final scoreExamController = TextEditingController();
  /**================ Add subject =====================*/
  Future<void> addSubject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    var class_room_id;
    for (var item in dataList) {
      if (item['class_room_name'] == classRoomIDController.text) {
        class_room_id = item['id'];
      }
    }
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'class_room_id': class_room_id,
        'title': titleController.text,
        'score_class_room': scoreClassRoomController.text,
        'score_activity': scoreActivityController.text,
        'score_exam': scoreExamController.text,
      });
      var response =
          await Dio().post('${urlapi}api/addsubject', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        //dataList.insert(0, response.data);
        titleController.value = TextEditingValue.empty;
        classRoomIDController.value = TextEditingValue.empty;
        scoreClassRoomController.value = TextEditingValue.empty;
        scoreActivityController.value = TextEditingValue.empty;
        scoreExamController.value = TextEditingValue.empty;
        listDataSubject();
        setState(() {
          class_room_name = '';
        });
      }
    } catch (e) {
      print('Wrong add subject');
      //AlertLoss();
    }
  }

  /**================ edit Class Room =====================*/
  bool isedit = false;
  int id_edit = 0;
  var class_room_name = '';
  Future<void> selecteditSubject(var data) async {
    titleController.value = TextEditingValue(text: data['title']);
    scoreClassRoomController.value =
        TextEditingValue(text: data['score_class_room']);
    scoreActivityController.value =
        TextEditingValue(text: data['score_activity']);
    scoreExamController.value = TextEditingValue(text: data['score_exam']);
    classRoomIDController.value =
        TextEditingValue(text: data['classRoom']['class_room_name']);
    setState(() {
      isedit = true;
      id_edit = int.parse(data['id']);
      class_room_name = data['classRoom']['class_room_name'];
    });
  }

  Future<void> editSubject(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    var class_room_id;
    for (var item in dataList) {
      if (item['class_room_name'] == classRoomIDController.text) {
        class_room_id = item['id'];
      }
    }

    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'class_room_id': class_room_id,
        'title': titleController.text,
        'score_class_room': scoreClassRoomController.text,
        'score_activity': scoreActivityController.text,
        'score_exam': scoreExamController.text,
        'id': id
      });
      var response =
          await Dio().post('${urlapi}api/editsubject', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        titleController.value = TextEditingValue.empty;
        classRoomIDController.value = TextEditingValue.empty;
        scoreClassRoomController.value = TextEditingValue.empty;
        scoreActivityController.value = TextEditingValue.empty;
        scoreExamController.value = TextEditingValue.empty;
        listDataSubject();
        setState(() {
          isedit = false;
          class_room_name = '';
        });
      }
    } catch (e) {
      print('Wrong edit subject');
      //AlertLoss();
    }
  }

/**=========== List Subject ===================*/
  var dataListSubject;
  Future<void> listDataSubject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
      });
      var response =
          await Dio().post('${urlapi}api/listsubject', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataListSubject = response.data;
        setState(() {
          dataListSubject;
        });
      }
    } catch (e) {
      print('Wrong List subject');
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

/**=========== delete Class Room ===================*/
  Future<void> deleteSubject(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'id': id,
      });
      var response =
          await Dio().post('${urlapi}api/deletesubject', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        listDataSubject();
      }
    } catch (e) {
      print('Wrong delete class room');
      //AlertLoss();
    }
  }

  @override
  void initState() {
    listDataClassRoom();
    listDataSubject();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Center(
          child: Text(translate('Subject')),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.blueGrey, spreadRadius: 2),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        translate('Add Subject'),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.lightBlue,
                      ),
                      DropdownSearch<String>(
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
                        selectedItem: class_room_name,
                        showSearchBox: false,
                        onChanged: (value) {
                          classRoomIDController.value =
                              TextEditingValue(text: '${value}');
                        },
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                            labelText: translate('Input Subject')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('Please enter subject');
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: scoreClassRoomController,
                              decoration: InputDecoration(
                                  labelText:
                                      translate('Input score class room')),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return translate(
                                      'Please enter score class room');
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: scoreActivityController,
                                decoration: InputDecoration(
                                    labelText:
                                        translate('Input score activity')),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return translate(
                                        'Please enter score activity');
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: scoreExamController,
                              decoration: InputDecoration(
                                  labelText: translate('Input score exam')),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return translate('Please enter score exam');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (isedit) {
                              editSubject(id_edit);
                            } else {
                              addSubject();
                            }
                          }
                        },
                        color: Colors.blueGrey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                isedit ? translate('Edit') : translate('Add'),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        translate('Item Subjects'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.red,
                      ),
                      dataListSubject == null
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
                          : Table(
                              //defaultColumnWidth: FixedColumnWidth(120.0),
                              columnWidths: subJectColumnWidths,
                              border: TableBorder.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1),
                              children: [
                                TableRow(children: [
                                  Container(
                                    alignment: Alignment.center,
                                    color: Colors.lightBlue,
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(children: [
                                        Text(
                                          translate('Class room'),
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
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(children: [
                                        Text(
                                          translate('Subject'),
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
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
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
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
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
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
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
                                    color: Colors.lightBlue,
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(children: [
                                        Text(
                                          translate('Students'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                  Column(children: [Text('')]),
                                ]),
                                for (var item in dataListSubject)
                                  TableRow(children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              EdgeInsets.fromLTRB(5, 2, 5, 2),
                                          child: Text(
                                            '${item['classRoom']['class_room_name']}',
                                          ),
                                        )
                                      ]),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              EdgeInsets.fromLTRB(5, 2, 5, 2),
                                          child: Text(
                                            '${item['title']}',
                                          ),
                                        )
                                      ]),
                                    ),
                                    Column(children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Text(
                                          '${item['score_class_room']}',
                                        ),
                                      )
                                    ]),
                                    Column(children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Text(
                                          '${item['score_activity']}',
                                        ),
                                      )
                                    ]),
                                    Column(children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Text(
                                          '${item['score_exam']}',
                                        ),
                                      )
                                    ]),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            padding:
                                                EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Student(
                                                              data: item[
                                                                  'classRoom'])),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                      '${item['classRoom']['count_student']}'),
                                                  Icon(Icons
                                                      .settings_accessibility)
                                                ],
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black12),
                                              ),
                                            ))
                                      ]),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(children: [
                                        Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2, 5, 2),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  deleteSubject(
                                                      int.parse(item['id']));
                                                },
                                                child: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Text(' | '),
                                              InkWell(
                                                  onTap: () {
                                                    selecteditSubject(item);
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
                                  ]),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
