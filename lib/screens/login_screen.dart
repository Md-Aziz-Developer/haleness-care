import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:haleness_care/constants/api_path.dart';
import 'package:haleness_care/screens/dashboard_screen.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
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
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void loginNow() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Timer(const Duration(milliseconds: 10), () {
      //   Get.off(() => const DashboardScreen());
      // });
      try {
        Response response = await post(Uri.parse(API_PATH + LOGIN), body: {
          'email': email.text.toString(),
          'password': password.text.toString()
        });
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });
          var myData = jsonDecode(response.body.toString());
          if (myData['response'] == 'success' && myData['status'] == 1) {
            var userData = myData['user'];
            var userId = userData['fld_profile_id'];
            var prefs = await SharedPreferences.getInstance();
            prefs.setString('userId', jsonEncode(userId));
            prefs.setString('userData', jsonEncode(userData));
            Get.off(() => const DashboardScreen());
          } else {
            Get.snackbar('Ohh!!', myData['message'],
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } else {
          Get.snackbar('Ohh!!', "Invalid Request!!!",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } catch (e) {
        Get.snackbar('Ohh!!', "Invalid Request!!!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 2.0,
                          width: 50.0,
                          color: LoginScreen.mycolor,
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          border: InputBorder.none,
                          hintText: 'Enter Email Id',
                          labelText: 'Email Id',
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Email Id is Required!!!';
                          } else {
                            return null;
                          }
                        },
                      )),
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
                            controller: password,
                            obscureText: !_showPassword ? true : false,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              hintText: 'Enter Password',
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Password is required!!!';
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
                      backgroundColor:
                          MaterialStateProperty.all<Color>(LoginScreen.mycolor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                    ),
                    onPressed: () {
                      loginNow();
                    },
                    child: !_isLoading
                        ? Text('Login',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.white))
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
                  height: MediaQuery.of(context).size.height * 0.30,
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
