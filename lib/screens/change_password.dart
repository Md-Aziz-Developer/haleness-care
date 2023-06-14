import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:haleness_care/constants/api_path.dart';
import 'package:haleness_care/screens/login_screen.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  static MaterialColor mycolor = MaterialColor(
    const Color.fromRGBO(54, 130, 127, 1).value,
    const <int, Color>{
      50: Color.fromRGBO(54, 130, 127, 0.098),
      100: Color.fromRGBO(54, 130, 127, 0.2),
      200: Color.fromRGBO(54, 130, 127, 0.3),
      300: Color.fromRGBO(54, 130, 127, 0.4),
      400: Color.fromRGBO(54, 130, 127, 0.5),
      500: Color.fromRGBO(54, 130, 127, 0.6),
      600: Color.fromRGBO(54, 130, 127, 0.7),
      700: Color.fromRGBO(54, 130, 127, 0.8),
      800: Color.fromRGBO(54, 130, 127, 0.9),
      900: Color.fromRGBO(54, 130, 127, 1),
    },
  );
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _isLoading = false;
  void changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = jsonDecode(prefs.getString('userId').toString());
        Response response =
            await post(Uri.parse(API_PATH + CHANGE_PASSWORD), body: {
          'userId': userId,
          'currentPassword': currentPassword.text.toString(),
          'newPassword': newPassword.text.toString()
        });
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });
          var myData = jsonDecode(response.body.toString());
          if (myData['response'] == 'success' && myData['status'] == 1) {
            Get.snackbar('Success:)', myData['message'],
                backgroundColor: Colors.green, colorText: Colors.white);
            Timer(const Duration(seconds: 1), () {
              prefs.clear();
              Get.off(() => const LoginScreen());
            });
          } else {
            Get.snackbar('Ohh!!', myData['message'],
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          Get.snackbar('Ohh!!', "Invalid Request!!!",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar('Ohh!!', "Invalid Request!!!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: ChangePassword.mycolor,
          title: const Text(
            'Change Password',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -120,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(335 / 360),
                child: Image.asset(
                  'assets/images/background.jpeg',
                  height: MediaQuery.of(context).size.height * 0.22,
                  width: MediaQuery.of(context).size.width * 1.5,
                  alignment: Alignment.bottomLeft,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 2.0,
                          width: 50.0,
                          color: ChangePassword.mycolor,
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: currentPassword,
                            obscureText: !_showPassword ? true : false,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              hintText: 'Enter Current Password',
                              labelText: 'Current Password',
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Current Password is required!!!';
                              } else {
                                return null;
                              }
                            },
                          )),
                    ),
                    Positioned(
                      right: 25,
                      top: 25,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: !_showPassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                    )
                  ],
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: newPassword,
                            obscureText: !_showPassword ? true : false,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              hintText: 'Enter New Password',
                              labelText: 'New Password',
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'New Password is required!!!';
                              } else if (value!.length < 8) {
                                return 'New Password is to short!!!';
                              } else {
                                return null;
                              }
                            },
                          )),
                    ),
                    Positioned(
                      right: 25,
                      top: 25,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: !_showPassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                    )
                  ],
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: confirmPassword,
                            obscureText: !_showPassword ? true : false,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              hintText: 'Enter Confirm Password',
                              labelText: 'Confirm Password',
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Confirm Password is required!!!';
                              } else if (value != null &&
                                  value != newPassword.text.toString()) {
                                return 'Confirm Password not Matched with new Password';
                              } else {
                                return null;
                              }
                            },
                          )),
                    ),
                    Positioned(
                      right: 25,
                      top: 25,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: !_showPassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ChangePassword.mycolor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                    ),
                    onPressed: () {
                      changePassword();
                    },
                    child: !_isLoading
                        ? const Text('Change Password',
                            style: TextStyle(fontSize: 18, color: Colors.white))
                        : const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: -100,
              right: -120,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(335 / 360),
                child: Image.asset(
                  'assets/images/background.jpeg',
                  height: MediaQuery.of(context).size.height * 0.22,
                  width: MediaQuery.of(context).size.width * 1.5,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
