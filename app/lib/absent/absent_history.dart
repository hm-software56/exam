import 'dart:math';

import 'package:dio/dio.dart';
import '../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsentHistiry extends StatefulWidget {
  var class_room_id;
  var class_room_name;
  var subject_id;
  var subject_title;
  var student;
  AbsentHistiry(
      {Key? key,
      required this.class_room_id,
      required this.class_room_name,
      required this.subject_id,
      required this.subject_title,
      required this.student})
      : super(key: key);

  @override
  _AbsentHistiryState createState() => _AbsentHistiryState(this.class_room_id,
      this.class_room_name, this.subject_id, this.subject_title, this.student);
}

class _AbsentHistiryState extends State<AbsentHistiry> {
  var class_room_id;
  var class_room_name;
  var subject_id;
  var subject_title;
  var student;
  _AbsentHistiryState(this.class_room_id, this.class_room_name, this.subject_id,
      this.subject_title, this.student);

  /** ==================== List Absent by students ================= */
  List dataListHistoryAbsent = [];
  bool isloading = true;
  Future<void> listHistoryAbsent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'student_id': student['id'],
      });
      var response =
          await Dio().post('${urlapi}api/listhistoryabsent', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataListHistoryAbsent = response.data;
        setState(() {
          dataListHistoryAbsent;
          isloading = false;
        });
      }
    } catch (e) {
      print('Wrong List History Absent');
      //AlertLoss();
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    listHistoryAbsent();
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * .7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                translate('Subject') + ": ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                '${subject_title}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                translate('Name') + ": ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${student['first_name']}' +
                    " " +
                    '${student['last_name']}' +
                    ', ' +
                    '${class_room_name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            color: Colors.red,
          ),
          isloading
              ? SpinKitWave(
                  size: 30.0,
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.blue : Colors.white,
                      ),
                    );
                  },
                )
              : GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 5,
                  children: <Widget>[
                    for (var item in dataListHistoryAbsent)
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(item['date']),
                            Divider(
                              color: Colors.white,
                            ),
                            Icon(
                              item['absent'] == 1
                                  ? Icons.done_outline
                                  : Icons.close_sharp,
                              color: Colors.black,
                              size: 50,
                            ),
                            item['absent'] == 1
                                ? Text(translate('Come'))
                                : item['reason'] == 1
                                    ? Text(translate('Absence reason'))
                                    : Text(translate('Absence no reason'))
                          ],
                        ),
                        color: item['absent'] == 1
                            ? Colors.teal
                            : item['reason'] == 1
                                ? Colors.red[200]
                                : Colors.red,
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
