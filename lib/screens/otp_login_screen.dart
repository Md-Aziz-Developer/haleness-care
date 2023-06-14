import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haleness_care/screens/dashboard_screen.dart';

class OtpLogin extends StatefulWidget {
  const OtpLogin({super.key});
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
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  bool _isLoading = false;
  bool _isOtpSend = false;
  var otpdigit1 = '';
  var otpdigit2 = '';
  var otpdigit3 = '';
  var otpdigit4 = '';
  TextEditingController number = TextEditingController();
  void verifyOtp() {
    if (otpdigit1.isEmpty ||
        otpdigit2.isEmpty ||
        otpdigit3.isEmpty ||
        otpdigit4.isEmpty) {
      Get.snackbar('Ohh!!', "Enter OTP To Proceed!!!",
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      print(otpdigit1 +
          otpdigit2 +
          otpdigit3 +
          otpdigit4 +
          number.text.toString());
      Get.off(() => const DashboardScreen());
    }
  }

  void sendOtp() async {
    var userNumber = number.text.toString();
    if (userNumber.isEmpty) {
      Get.snackbar('Ohh!!', "Enter Mobile Number To Proceed!!!",
          backgroundColor: Colors.red, colorText: Colors.white);
    } else if (userNumber.length < 10 || userNumber.length > 10) {
      Get.snackbar('Ohh!!', "Enter Valid Mobile Number To Proceed!!!",
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      setState(() {
        _isOtpSend = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          _isOtpSend
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enter OTP',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 2.0,
                              width: 100.0,
                              color: OtpLogin.mycolor,
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  otpdigit1 = '';
                                });
                              } else {
                                setState(() {
                                  otpdigit1 = value;
                                });
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              hintText: '*',
                              labelText: ' ',
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  otpdigit2 = '';
                                });
                                FocusScope.of(context).previousFocus();
                              } else {
                                setState(() {
                                  otpdigit2 = value;
                                });
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              hintText: '*',
                              labelText: ' ',
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  otpdigit3 = '';
                                });
                                FocusScope.of(context).previousFocus();
                              } else {
                                setState(() {
                                  otpdigit3 = value;
                                });
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              hintText: '*',
                              labelText: ' ',
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  otpdigit4 = '';
                                });
                                FocusScope.of(context).previousFocus();
                              } else {
                                setState(() {
                                  otpdigit4 = value;
                                });
                                FocusScope.of(context).unfocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              hintText: '*',
                              labelText: ' ',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              OtpLogin.mycolor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          verifyOtp();
                        },
                        child: !_isLoading
                            ? Text('Verify Otp',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, color: Colors.white))
                            : const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 3,
                                ),
                              ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enter Mobile Number',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 2.0,
                              width: 100.0,
                              color: OtpLogin.mycolor,
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    controller: number,
                                    keyboardType: TextInputType.number,
                                    // maxLength: 10,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      border: InputBorder.none,
                                      hintText: 'Enter Mobile Number',
                                      labelText: 'Mobile Number',
                                    ),
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return 'Mobile Number is Required!!!';
                                      } else if (value!.length < 10) {
                                        return 'Invalid Mobile Number!!!';
                                      } else {
                                        return null;
                                      }
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              OtpLogin.mycolor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          sendOtp();
                        },
                        child: !_isLoading
                            ? Text('Send Otp',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, color: Colors.white))
                            : const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
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
    );
  }
}
