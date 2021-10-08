import 'dart:async';
import 'dart:convert';

import 'package:avatar_view/avatar_view.dart';
import 'package:exam/absent/absent.dart';
import 'package:exam/classroom/class_roor.dart';
import 'package:exam/home/home.dart';
import 'package:exam/subject/subject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  /**======= show data user login========= */
  var user;
  listUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user');
    user = JsonDecoder(user);
  }

  /*================= Switch language =============*/
  Future<void> SwitchLang(context, var lang) async {
    changeLocale(context, lang);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', lang);
    if (lang == 'en') {
      await prefs.setString('lang_code', lang);
    } else {
      await prefs.setString('lang_code', lang);
    }
  }

  @override
  void initState() {
    //listUser();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                SizedBox(height: 7),
                Center(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                ),
                SizedBox(height: 4),
                Center(
                  child: Text(
                    translate('Exam System Online'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.home,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            trailing: Icon(Icons.navigate_next),
            title: Text(
              translate('Home'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) => Home()), (route) => false);
            },
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.class__outlined,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            trailing: Icon(Icons.navigate_next),
            title: Text(
              translate('Class Room'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => ClassRoom()),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.subject_outlined,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            trailing: Icon(Icons.navigate_next),
            title: Text(
              translate('Subject'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Subject()),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.subject_outlined,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            trailing: Icon(Icons.navigate_next),
            title: Text(
              translate('Check Absent'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) =>Absent()),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.subject_outlined,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            trailing: Icon(Icons.navigate_next),
            title: Text(
              translate('Activity'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.subject_outlined,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            trailing: Icon(Icons.navigate_next),
            title: Text(
              translate('Exam'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.help_outline,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            trailing: Icon(Icons.navigate_next),
            title: Text(
              translate('About App'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onTap: () {},
          ),
          Divider(
            color: Colors.grey,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        SwitchLang(context, 'en');
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
                        SwitchLang(context, 'lo');
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
          ),
        ],
      ),
    );
  }
}
