import 'package:exam/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DoneExam extends StatefulWidget {
  const DoneExam({Key? key}) : super(key: key);
  @override
  _DoneExamState createState() => _DoneExamState();
}

class _DoneExamState extends State<DoneExam> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.red, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.timer_off,
                size: 50,
                color: Colors.redAccent,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                translate('Exam Time Finished.!'),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Home()),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[900]),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        translate('Back Home'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
