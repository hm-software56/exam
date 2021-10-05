import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String os = Platform.operatingSystem; //in your code
/*================= Switch language =============*/
  Future<void> SwitchLang(var lang) async {
    changeLocale(context, lang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text(translate('Exam Online')))),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: os == 'windows' ? 450 : null,
            child: Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
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
                                        imagePath: "assets/icons/flags/en.png",
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(translate('English')),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                        imagePath: "assets/icons/flags/lo.png",
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
                                        padding: const EdgeInsets.all(8.0),
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
                          decoration:
                              InputDecoration(labelText: translate('E-mail')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('Please enter email');
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration:
                              InputDecoration(labelText: translate('Password')),
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
                        RaisedButton(
                          onPressed: () {
                            if (loginFormKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            }
                          },
                          color: Colors.blueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  translate('Sign up for teacher'),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(translate('Exam for student'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
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
