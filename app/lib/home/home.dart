import 'package:exam/absent/absent.dart';
import 'package:exam/activity/activity.dart';
import 'package:exam/classroom/class_roor.dart';
import 'package:exam/exam/exam.dart';
import 'package:exam/report/report.dart';
import 'package:exam/subject/subject.dart';

import '../login/login.dart';
import '../menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> checkLoginned() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    changeLocale(context, 'lo');
    await prefs.setString('lang', 'Lao');
    await prefs.setString('lang_code', 'lo');
    final user_id = await prefs.getInt('user_id');
    if (user_id == null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => Login()), (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginned();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Center(child: Text(translate('Home'))),
      ),
      body:Container(
        margin: EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.blueGrey, spreadRadius: 2),
                    ],
                  ),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //ROW1
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.blue.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        color: Colors.transparent,
                        child: FlatButton(
                          onPressed: () => {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => ClassRoom(),
                              ),
                            )
                          },
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 29),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.groups_outlined,
                                size: 60,
                                color: Color(0xff008fd4),
                              ),
                              Text(
                                translate('Class Room'),
                                style: TextStyle(
                                  color: Color(0xff008fd4),
                                  //fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.blue.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        color: Colors.transparent,
                        child: FlatButton(
                          onPressed: () => {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>Subject(),
                              ),
                            )
                          },
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 29),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.auto_stories,
                                size: 60,
                                color: Color(0xff008fd4),
                              ),
                              Text(
                                translate('Subject'),
                                style: TextStyle(
                                  color: Color(0xff008fd4),
                                  //fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.blue.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        color: Colors.transparent,
                        child: FlatButton(
                          onPressed: () => {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => Absent(),
                              ),
                            )
                          },
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 29),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.add_business_outlined,
                                size: 60,
                                color: Color(0xff008fd4),
                              ),
                              Text(
                                translate('Check Absent'),
                                style: TextStyle(
                                  color: Color(0xff008fd4),
                                  //fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.blue.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        color: Colors.transparent,
                        child: FlatButton(
                          onPressed: () => {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>Activity(),
                              ),
                            )
                          },
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 29),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.local_activity,
                                size: 60,
                                color: Color(0xff008fd4),
                              ),
                              Text(
                                translate('Activity'),
                                style: TextStyle(
                                  color: Color(0xff008fd4),
                                  //fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.blue.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        color: Colors.transparent,
                        child: FlatButton(
                          onPressed: () => {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => Exam(),
                              ),
                            )
                          },
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 29),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.text_fields,
                                size: 60,
                                color: Color(0xff008fd4),
                              ),
                              Text(
                                translate('Exam'),
                                style: TextStyle(
                                  color: Color(0xff008fd4),
                                  //fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.blue.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        color: Colors.transparent,
                        child: FlatButton(
                          onPressed: () => {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>Report(),
                              ),
                            )
                          },
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 29),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.bar_chart,
                                size: 60,
                                color: Color(0xff008fd4),
                              ),
                              Text(
                                translate('Report'),
                                style: TextStyle(
                                  color: Color(0xff008fd4),
                                  //fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
