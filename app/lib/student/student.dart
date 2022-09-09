import 'package:dio/dio.dart';
import 'dart:io';
import '../config/config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Student extends StatefulWidget {
  var data;
  Student({Key? key, required this.data}) : super(key: key);

  @override
  _StudentState createState() => _StudentState(this.data);
}

class _StudentState extends State<Student> {
  var data;
  _StudentState(this.data);

  final formKey = GlobalKey<FormState>();
  final studentCodeController = TextEditingController();
  final studentfirstnameCodeController = TextEditingController();
  final studentlastnameCodeController = TextEditingController();

/**================ Add Student =====================*/
  Future<void> addClassRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'student_code': studentCodeController.text,
        'first_name': studentfirstnameCodeController.text,
        'last_name': studentlastnameCodeController.text,
        'class_room_id': data['id']
      });
      var response =
          await Dio().post('${urlapi}api/addstudent', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataList.insert(0, response.data);
        studentCodeController.value = TextEditingValue.empty;
        studentfirstnameCodeController.value = TextEditingValue.empty;
        studentlastnameCodeController.value = TextEditingValue.empty;
        setState(() {
          dataList;
        });
      }
    } catch (e) {
      print('Wrong add student');
      //AlertLoss();
    }
  }

  /**================ edit Student=====================*/
  bool isedit = false;
  int id_edit = 0;
  Future<void> selecteditStudent(var item) async {
    studentCodeController.value = TextEditingValue(text: item['student_code']);
    studentfirstnameCodeController.value =
        TextEditingValue(text: item['first_name']);
    studentlastnameCodeController.value =
        TextEditingValue(text: item['last_name']);
    setState(() {
      isedit = true;
      id_edit = item['id'];
    });
  }

  Future<void> editStudent(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'student_code': studentCodeController.text,
        'first_name': studentfirstnameCodeController.text,
        'last_name': studentlastnameCodeController.text,
        'class_room_id': data['id'],
        'id': id
      });
      var response =
          await Dio().post('${urlapi}api/editstudent', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        studentCodeController.value = TextEditingValue.empty;
        studentfirstnameCodeController.value = TextEditingValue.empty;
        studentlastnameCodeController.value = TextEditingValue.empty;
        listDataStudent();
        setState(() {
          isedit = false;
        });
      }
    } catch (e) {
      print('Wrong edit Student');
      //AlertLoss();
    }
  }

  /**=========== List student ===================*/
  var dataList;
  Future<void> listDataStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'class_room_id': data['id']
      });
      var response =
          await Dio().post('${urlapi}api/liststudent', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataList = response.data;
        setState(() {
          dataList;
        });
      }
    } catch (e) {
      print('Wrong List Student');
      //AlertLoss();
    }
  }

/**=========== delete Class Room ===================*/
  Future<void> deleteStudent(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap(
          {'tokenID': apitoken, 'id': id, 'class_room_id': data['id']});
      var response =
          await Dio().post('${urlapi}api/deletestudent', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        listDataStudent();
      }
    } catch (e) {
      print('Wrong delete class room');
      //AlertLoss();
    }
  }

  Future<void> importExcel() async {
    Loading();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String path_file_name = result.files.single.path.toString();
      String extension = result.names[0].toString().split('.').last;
      List exts = ['xlsx', 'xls', 'XLSX', 'XLS'];
      if (exts.contains(extension)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final apitoken = await prefs.getString('apitoken');
        final user_id = await prefs.getInt('user_id');
        try {
          var formData = FormData.fromMap({
            'tokenID': apitoken,
            'class_room_id': data['id'],
            'upfile': await MultipartFile.fromFile(path_file_name,
                filename: result.names[0]),
          });
          var response =
              await Dio().post('${urlapi}api/importcsv', data: formData);
          if (response.statusCode == 200 && response.data != null) {
            listDataStudent();
            Navigator.pop(context); // closs loading
          }
        } on DioError catch(e) {
          print(e.response);
          print('Wrong import csv student');
          Navigator.pop(context); // closs loading
          importError(translate(
              'Your file format is incorrect\nPlease check your file and reimport'));
        }
      } else {
        // Errors valudate extension
        print('Errors valudate extension');
        Navigator.pop(context); // closs loading
        importError(
            translate('Your file is not excel file\nThen extension xlsx, xls'));
      }
    } else {
      // User canceled the picker
      Navigator.pop(context); // closs loading
    }
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

  Future<void> importError(String msg) async {
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

  Future<void> seeFormatImport() async {
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
                  child: Image.asset('assets/images/formatimport.png'),
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
    listDataStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
              translate('Class Room') + ' - ' + '${data['class_room_name']}'),
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
                       BoxShadow(color: Colors.blue, spreadRadius: 1),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              translate('Add New Student'),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                importExcel();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.file_copy, color: Colors.white),
                                    Text(
                                      translate('Import Exel File'),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.redAccent),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                seeFormatImport();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.help_outline,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    Text(
                                      translate('See format'),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.lightBlue,
                        ),
                        TextFormField(
                          controller: studentCodeController,
                          decoration: InputDecoration(
                              labelText: translate('Input student code')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('Please enter student code');
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
                                child: TextFormField(
                                  controller: studentfirstnameCodeController,
                                  decoration: InputDecoration(
                                      labelText: translate(
                                          'Input student first name')),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return translate(
                                          'Please enter student first name');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                                child: TextFormField(
                                  controller: studentlastnameCodeController,
                                  decoration: InputDecoration(
                                      labelText:
                                          translate('Input student last name')),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return translate(
                                          'Please enter student last name');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (isedit) {
                                editStudent(id_edit);
                              } else {
                                addClassRoom();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey
                            ),
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
                                  isedit
                                      ? translate('Edit Student')
                                      : translate('Add Student'),
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
                        translate('List students'),
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
                                  0: FixedColumnWidth(100),
                                  1: FlexColumnWidth(),
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
                                        alignment: Alignment.center,
                                        color: Colors.lightBlue,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Text(
                                          translate('Code'),
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
                                        padding:
                                            EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        child: Text(
                                          translate('Full name'),
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
                                            '${item['student_code']}',
                                          ),
                                        )
                                      ]),
                                      Column(children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              EdgeInsets.fromLTRB(5, 2, 5, 2),
                                          child: Text('${item['first_name']}' +
                                              " " +
                                              '${item['last_name']}'),
                                        )
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
                                                  deleteStudent(item['id']);
                                                },
                                                child: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Text(' | '),
                                              InkWell(
                                                  onTap: () {
                                                    selecteditStudent(item);
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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
