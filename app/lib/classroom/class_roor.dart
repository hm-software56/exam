import 'package:dio/dio.dart';
import '../config/config.dart';
import '../menu/menu.dart';
import '../student/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassRoom extends StatefulWidget {
  const ClassRoom({Key? key}) : super(key: key);

  @override
  _ClassRoomState createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  final formKey = GlobalKey<FormState>();
  final classroomnameController = TextEditingController();
  /**================ Add Class Room =====================*/
  Future<void> addClassRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'class_room_name': classroomnameController.text
      });
      var response =
          await Dio().post('${urlapi}api/addclassroom', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataList.insert(0, response.data);
        classroomnameController.value = TextEditingValue.empty;
        setState(() {
          dataList;
        });
      }
    } catch (e) {
      print('Wrong add class room');
      //AlertLoss();
    }
  }

  /**================ edit Class Room =====================*/
  bool isedit = false;
  int id_edit = 0;
  String name = '';
  Future<void> selecteditClassRoom(int id, String name) async {
    classroomnameController.value = TextEditingValue(text: name);
    setState(() {
      isedit = true;
      id_edit = id;
    });
  }

  Future<void> editClassRoom(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'class_room_name': classroomnameController.text,
        'id': id
      });
      var response =
          await Dio().post('${urlapi}api/editclassroom', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        classroomnameController.value = TextEditingValue.empty;
        listDataClassRoom();
        setState(() {
          isedit = false;
        });
      }
    } catch (e) {
      print('Wrong edit class room');
      //AlertLoss();
    }
  }

  /**=========== List Class Room ===================*/
  var dataList;
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
        setState(() {
          dataList;
        });
      }
    } catch (e) {
      print('Wrong List class room');
      //AlertLoss();
    }
  }

/**=========== delete Class Room ===================*/
  Future<void> deleteDataClassRoom(int id) async {
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
          await Dio().post('${urlapi}api/deleteclassroom', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        print(response.data);
        listDataClassRoom();
      }
    } catch (e) {
      print('Wrong delete class room');
      //AlertLoss();
    }
  }

  @override
  void initState() {
    listDataClassRoom();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Center(
          child: Text(translate('Class room')),
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
            mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        translate('Add Class Room'),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.lightBlue,
                      ),
                      TextFormField(
                        controller: classroomnameController,
                        decoration: InputDecoration(
                            labelText: translate('Input class room')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('Please enter class room');
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (isedit) {
                              editClassRoom(id_edit);
                            } else {
                              addClassRoom();
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
                        translate('Item Class Room'),
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.red,
                      ),
                      dataList == null
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
                              columnWidths: {
                                0: FlexColumnWidth(),
                                1: FixedColumnWidth(100),
                                2: FixedColumnWidth(100),
                              },
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
                                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                      child: Text(
                                        translate('Class room'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                                  Column(children: [
                                    Container(
                                      color: Colors.lightBlue,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                      child: Text(
                                        translate('Students'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ]),
                                  Column(children: [
                                    Text('', style: TextStyle(fontSize: 20.0))
                                  ]),
                                ]),
                                for (var item in dataList)
                                  TableRow(children: [
                                    Column(children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Text(
                                          '${item['class_room_name']}',
                                          
                                        ),
                                      )
                                    ]),
                                    Column(children: [
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
                                                        Student(data: item)),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                    '${item['count_student']}'),
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
                                    Column(children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 2, 5, 2),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                deleteDataClassRoom(item['id']);
                                              },
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(' | '),
                                            InkWell(
                                                onTap: () {
                                                  selecteditClassRoom(
                                                      item['id'],
                                                      item['class_room_name']);
                                                },
                                                child: Icon(
                                                  Icons.border_color,
                                                  color: Colors.blueAccent,
                                                )),
                                          ],
                                        ),
                                      )
                                    ]),
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
