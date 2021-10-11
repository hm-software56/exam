import 'package:exam/login/login.dart';
import 'package:exam/menu/menu.dart';
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
      body: SingleChildScrollView(
        child: Container(
          padding:EdgeInsets.all(8),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('dddddddddd')
            ],
          ),
        ),
      ),
    );
  }
}
