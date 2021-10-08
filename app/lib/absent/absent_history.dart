import 'package:flutter/material.dart';
class AbsentHistiry extends StatefulWidget {
  var class_room_id;
  var subject_id;
  var student_id;
  AbsentHistiry({ Key? key, required  this.class_room_id, required this.subject_id, required this.student_id}) : super(key: key);

  @override
  _AbsentHistiryState createState() => _AbsentHistiryState(this.class_room_id,this.subject_id,this.student_id);
}

class _AbsentHistiryState extends State<AbsentHistiry> {
   var class_room_id;
  var subject_id;
  var student_id;
  _AbsentHistiryState(this.class_room_id,this.subject_id,this.student_id);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('xxxxxxxxxx')
        ],
      ),
    );
  }
}