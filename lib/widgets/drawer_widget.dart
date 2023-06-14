import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haleness_care/screens/change_password.dart';
import 'package:haleness_care/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    var prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.get('userData').toString());
    setState(() {
      userName = userData['fld_customer_name'];
      userEmail = userData['fld_email_id'];
      userImage = userData['fld_image'];
    });
  }

  var userName = '';
  var userEmail = '';
  var userImage = 'https://worldtradekey.in/healthcrm/uploads/default.png';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: Text(
                  userName,
                  style: const TextStyle(color: Colors.white),
                ),
                accountEmail: Text(userEmail,
                    style: const TextStyle(color: Colors.white)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    userImage,
                  ),
                ),
              )),
          // ListTile(
          //   contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
          //   leading: const Icon(Icons.home),
          //   title: const Text('Home'),
          //   onTap: () {

          //   },
          // ),
          // const Divider(
          //   height: 5,
          // ),
          // ListTile(
          //   contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
          //   leading: const Icon(Icons.video_collection),
          //   title: const Text('Video'),
          //   onTap: () {},
          // ),
          // const Divider(
          //   height: 5,
          // ),
          // ListTile(
          //   contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
          //   leading: const Icon(Icons.collections),
          //   title: const Text('Blogs'),
          //   onTap: () {},
          // ),
          // const Divider(
          //   height: 5,
          // ),
          // ListTile(
          //   contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
          //   leading: const Icon(Icons.sports_gymnastics),
          //   title: const Text('Diets'),
          //   onTap: () {},
          // ),
          // const Divider(
          //   height: 5,
          // ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            leading: const Icon(Icons.lock_outline_sharp),
            title: const Text('Change Password'),
            onTap: () {
              Get.to(() => const ChangePassword());
            },
          ),
          const Divider(
            height: 5,
          ),

          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              var prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Get.off(() => const LoginScreen());
            },
          ),
          const Divider(
            height: 5,
          ),
        ],
      ),
    );
  }
}
