import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:haleness_care/constants/api_path.dart';
import 'package:haleness_care/screens/dashboard_screen.dart';
import 'package:haleness_care/screens/login_screen.dart';
import 'package:haleness_care/screens/otp_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userId')) {
      Get.off(() => const LoginScreen());
    } else {
      var userId = jsonDecode(prefs.get('userId').toString());
      try {
        Response response = await post(Uri.parse(API_PATH + LOGGED_IN),
            body: {'userId': userId});
        if (response.statusCode == 200) {
          var myData = jsonDecode(response.body.toString());
          if (myData['response'] == 'success' && myData['status'] == 1) {
            var userData = myData['user'];
            var userId = userData['fld_profile_id'];
            prefs.setString('userId', jsonEncode(userId));
            prefs.setString('userData', jsonEncode(userData));
            Get.off(() => const DashboardScreen());
          } else {
            Get.off(() => const LoginScreen());
          }
        } else {
          Get.off(() => const LoginScreen());
        }
      } catch (e) {
        Get.off(() => const LoginScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -120,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(335 / 360),
              child: Image.asset(
                'assets/images/background.jpeg',
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 1.5,
                alignment: Alignment.bottomLeft,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                width: double.infinity,
              )
            ],
          ),
          Positioned(
            bottom: -100,
            right: -120,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(335 / 360),
              child: Image.asset(
                'assets/images/background.jpeg',
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 1.5,
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
