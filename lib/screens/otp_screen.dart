import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haleness_care/screens/dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  static MaterialColor mycolor = MaterialColor(
    const Color.fromRGBO(254, 114, 91, 1).value,
    const <int, Color>{
      50: Color.fromRGBO(254, 114, 91, 0.098),
      100: Color.fromRGBO(254, 114, 91, 0.2),
      200: Color.fromRGBO(254, 114, 91, 0.3),
      300: Color.fromRGBO(254, 114, 91, 0.4),
      400: Color.fromRGBO(254, 114, 91, 0.5),
      500: Color.fromRGBO(254, 114, 91, 0.6),
      600: Color.fromRGBO(254, 114, 91, 0.7),
      700: Color.fromRGBO(254, 114, 91, 0.8),
      800: Color.fromRGBO(254, 114, 91, 0.9),
      900: Color.fromRGBO(254, 114, 91, 1),
    },
  );

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _isLoading = false;
  var otpdigit1 = '';
  var otpdigit2 = '';
  var otpdigit3 = '';
  var otpdigit4 = '';
  void verifyOtp() {
    if (otpdigit1.isEmpty ||
        otpdigit2.isEmpty ||
        otpdigit3.isEmpty ||
        otpdigit4.isEmpty) {
      Get.snackbar('Ohh!!', "Enter OTP To Proceed!!!",
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      //print(otpdigit1 + otpdigit2 + otpdigit3 + otpdigit4);
      Get.off(() => const DashboardScreen());
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                        color: OtpScreen.mycolor,
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        }
                      },
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(OtpScreen.mycolor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
    );
  }
}
