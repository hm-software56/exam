import 'dart:math';

import 'package:dio/dio.dart';
import 'package:exam/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityHistory extends StatefulWidget {
  var activity_id;
  var activity_name;
  var class_room_id;
  var class_room_name;
  var subject_id;
  var subject_title;
  var student;
  ActivityHistory(
      {Key? key,
      required this.activity_id,
      required this.activity_name,
      required this.class_room_id,
      required this.class_room_name,
      required this.subject_id,
      required this.subject_title,
      required this.student})
      : super(key: key);

  @override
  _ActivityHistoryState createState() => _ActivityHistoryState(
      this.activity_id,
      this.activity_name,
      this.class_room_id,
      this.class_room_name,
      this.subject_id,
      this.subject_title,
      this.student);
}

class _ActivityHistoryState extends State<ActivityHistory> {
  var activity_id;
  var activity_name;
  var class_room_id;
  var class_room_name;
  var subject_id;
  var subject_title;
  var student;
  _ActivityHistoryState(
      this.activity_id,
      this.activity_name,
      this.class_room_id,
      this.class_room_name,
      this.subject_id,
      this.subject_title,
      this.student);

  /** ==================== List activity score by students ================= */
  List dataListHistoryActivityScore= [];
  bool isloading = true;
  Future<void> listHistoryActivityScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    final user_id = await prefs.getInt('user_id');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'teacher_id': user_id,
        'subject_id': subject_id,
        'student_id': student['id'],
        'activity_id':activity_id
      });
      var response =
          await Dio().post('${urlapi}api/listhistoryactivity', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        dataListHistoryActivityScore = response.data;
        setState(() {
          dataListHistoryActivityScore;
          isloading = false;
        });
      }
    } catch (e) {
      print('Wrong List History Activity Score');
      //AlertLoss();
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    listHistoryActivityScore();
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
                translate('Score') + ": ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                '${activity_name}',
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
              Text(
                ", " + translate('Subject') + ": " + translate(subject_title),
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
                    for (var item in dataListHistoryActivityScore)
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(item['date'].substring(0,item['date'].length-8)),
                            Divider(
                              color: Colors.white,
                            ),
                            Icon(
                              item['send'] == 1
                                  ? Icons.done_outline
                                  : Icons.close_sharp,
                              color: Colors.black,
                              size: 50,
                            ),
                            item['send'] == 1
                                ? Text(translate('Sent/Joined'))
                                : Text(translate('Not send/join')),
                            Text(translate('Score')+": "+item['score'].toString()),
                          ],
                        ),
                        color: item['send'] == 1
                            ? Colors.teal
                            : Colors.red,
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
