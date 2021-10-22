import 'package:avatar_view/avatar_view.dart';
import 'package:dio/dio.dart';
import 'package:exam/exam/exam_student.dart';
import '../config/config.dart';
import '../home/home.dart';
import '../register/register.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  CheckPlatform() {
    try {
      return Platform.operatingSystem; //in your code
    } catch (e) {
      return null; //in your code
    }
  }

/*================= Switch language =============*/
  Future<void> SwitchLang(var lang) async {
    changeLocale(context, lang);
  }

  bool isloading = true;
  var tokenID;
  Future<void> ApiToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response_token = await Dio().get('${urlapi}api/apitoken');
      if (response_token.statusCode == 200) {
        await prefs.setString('apitoken', response_token.data);
        if (!mounted) return;
        setState(() {
          tokenID = response_token.data;
          isloading = false;
        });
      }
    } catch (e) {
      print('Errors api token');
      AlertLoss();
    }
  }

/** =========== Alert ================= */
  AlertLoss() async {
    return Alert(
      context: context,
      type: AlertType.warning,
      onWillPopActive: true,
      closeFunction: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      },
      title: translate('Loss network connection.!'),
      content: Icon(Icons.network_wifi, color: Colors.grey),
      buttons: [
        DialogButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        )
      ],
    ).show();
  }

  /**=============== Login ================ */
  bool isloging = false;
  bool iswronglogin = false;
  Future<void> submitLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apitoken = await prefs.getString('apitoken');
    try {
      var formData = FormData.fromMap({
        'tokenID': apitoken,
        'username': emailController.text,
        'password': passwordController.text
      });
      var response = await Dio().post('${urlapi}api/login', data: formData);
      if (response.statusCode == 200 && response.data.length > 1) {
        var user = response.data;
        await prefs.setInt('user_id', user['id']);
        await prefs.setString('user', jsonEncode(user));
        setState(() {
          isloging = false;
        });
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Home()), (route) => false);
      } else {
        setState(() {
          iswronglogin = true;
          isloging = false;
        });
      }
    } catch (e) {
      print('Wrong Login');
      setState(() {
        iswronglogin = true;
        isloging = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    ApiToken();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(child: Text(translate('Management Student System')))),
        body: Center(
          child: isloading
              ? Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: SpinKitWave(
                    size: 30.0,
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.blue : Colors.white,
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(16.0),
                  width: CheckPlatform() == 'windows' ? 450 : null,
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(color: Colors.blue, spreadRadius: 2),
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          SwitchLang('en');
                                        },
                                        child: Row(
                                          children: [
                                            AvatarView(
                                              radius: 15,
                                              borderColor: Colors.yellow,
                                              isOnlyText: false,
                                              avatarType: AvatarType.CIRCLE,
                                              backgroundColor: Colors.red,
                                              imagePath:
                                                  "assets/icons/flags/en.png",
                                              placeHolder: Container(
                                                child: Icon(
                                                  Icons.flag,
                                                  size: 15,
                                                ),
                                              ),
                                              errorWidget: Container(
                                                child: Icon(
                                                  Icons.error,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(translate('English')),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    child: Text(
                                      '|',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          SwitchLang('lo');
                                        },
                                        child: Row(
                                          children: [
                                            AvatarView(
                                              radius: 15,
                                              borderColor: Colors.yellow,
                                              isOnlyText: false,
                                              avatarType: AvatarType.CIRCLE,
                                              backgroundColor: Colors.red,
                                              imagePath:
                                                  "assets/icons/flags/lo.png",
                                              placeHolder: Container(
                                                child: Icon(
                                                  Icons.flag,
                                                  size: 15,
                                                ),
                                              ),
                                              errorWidget: Container(
                                                child: Icon(
                                                  Icons.error,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(translate('Lao')),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    labelText: translate('Username')),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('Please enter username');
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                    labelText: translate('Password')),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('Please enter password');
                                  }
                                  return null;
                                },
                                obscureText: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              isloging == true
                                  ? SpinKitWave(
                                      size: 30.0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: index.isEven
                                                ? Colors.blue
                                                : Colors.white,
                                          ),
                                        );
                                      },
                                    )
                                  : RaisedButton(
                                      onPressed: () {
                                        if (loginFormKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            isloging = true;
                                          });
                                          submitLogin();
                                        }
                                      },
                                      color: Colors.blueAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              translate('Login'),
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
                              iswronglogin
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      child: Text(
                                        translate(
                                            'Username and password incorrect.!'),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : SizedBox(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Register()),
                                        );
                                      },
                                      child: Text(
                                        translate('Sign up for teacher'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ExamStudent()),
                                        );
                                      },
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                              translate('Exam for student'),
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
