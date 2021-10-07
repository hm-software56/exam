import 'package:exam/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
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
