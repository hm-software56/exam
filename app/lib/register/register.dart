import 'package:dio/dio.dart';
import 'package:exam/home/home.dart';
import '../config/config.dart';
import '../login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  /** =================== Submit Signup ========================= */
  Future<void> submitSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'first_name': firstnameController.text,
        'last_name': lastnameController.text,
        'phone_number': phoneController.text,
        'email': emailController.text,
        'username': usernameController.text,
        'password': passwordController.text
      });
      var response =
          await Dio().post('${urlapi}api/submitsignup', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        AlertDone();
      }
    } catch (e) {
      print('Wrong submit first use');
      //AlertLoss();
    }
  }

  /** =================AlertDone =============== */
  Future<void> AlertDone() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.done_all,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(
                        translate(
                            'You have completed registration as a teacher.!'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.red,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => Login()),
                              (route) => false);
                        },
                        color: Colors.blue[900],
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.login,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                translate('Login'),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Center(child: Text(translate('Sign up for teacher')))),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.blueGrey, spreadRadius: 2),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        translate('General Infomation'),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.lightBlue,
                      ),
                      TextFormField(
                        controller: firstnameController,
                        decoration:
                            InputDecoration(labelText: translate('First Name')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('Please enter first name');
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: lastnameController,
                        decoration:
                            InputDecoration(labelText: translate('Last Name')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('Please enter last name');
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            labelText: translate('Phone Number')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('Please enter phone number');
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration:
                            InputDecoration(labelText: translate('Email')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('Please enter email');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.blueGrey, spreadRadius: 2),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        translate('Set Usernam and Password'),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Divider(
                        color: Colors.lightBlue,
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration:
                            InputDecoration(labelText: translate('Username')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('Please enter username');
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: translate('Password')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return translate('Please enter Password');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      submitSignUp();
                    }
                  },
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translate('Sign Up'),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
