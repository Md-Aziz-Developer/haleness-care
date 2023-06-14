import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:haleness_care/constants/api_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
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
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // var _selectedGender = 'male';
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var userId = '';
  var userImage = 'https://worldtradekey.in/healthcrm/uploads/default.png';
  File? image;
  final _picker = ImagePicker();
  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {}
  }

  TextEditingController username = TextEditingController();
  TextEditingController useremail = TextEditingController();
  TextEditingController dateofbirth = TextEditingController();
  TextEditingController userheight = TextEditingController();
  TextEditingController userweight = TextEditingController();
  TextEditingController userbmi = TextEditingController();
  TextEditingController usernumber = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.get('userData').toString());
    //print(userData);
    setState(() {
      username.text = userData['fld_customer_name'];
      useremail.text = userData['fld_email_id'];
      dateofbirth.text = userData['fld_date_of_birth'];
      userweight.text = userData['fld_starting_weight'];
      userheight.text = userData['fld_height'];
      userbmi.text = userData['fld_starting_bmi'];
      usernumber.text = userData['fld_mobile_no'];
      userId = userData['fld_profile_id'];
      userImage = userData['fld_image'];
    });
  }

  void updateUser() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        var uri = Uri.parse(API_PATH + PROFILE_UPDATE);
        var request = http.MultipartRequest('POST', uri);
        request.fields['userId'] = userId;
        request.fields['name'] = username.text.toString();
        request.fields['email'] = useremail.text.toString();
        request.fields['number'] = usernumber.text.toString();
        request.fields['dob'] = dateofbirth.text.toString();
        request.fields['height'] = userheight.text.toString();
        request.fields['weight'] = userweight.text.toString();
        request.fields['bmi'] = userbmi.text.toString();
        image != null
            ? request.files.add(http.MultipartFile.fromBytes(
                'image', File(image!.path).readAsBytesSync(),
                filename: image!.path))
            : 0;
        var response = await request.send();
        var responsed = await http.Response.fromStream(response);
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });
          var myData = jsonDecode(responsed.body.toString());
          if (myData['response'] == 'success' && myData['status'] == 1) {
            var userData = myData['user'];
            var userId = userData['fld_profile_id'];
            var prefs = await SharedPreferences.getInstance();
            prefs.setString('userId', jsonEncode(userId));
            prefs.setString('userData', jsonEncode(userData));
            setState(() {});
            Get.snackbar('Success :)', myData['message'],
                backgroundColor: Colors.green, colorText: Colors.white);
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
        body: SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: image == null
                          ?
                          //Image.network(
                          //     userImage,
                          //     height: 100,
                          //     width: 100,
                          //     fit: BoxFit.cover,
                          //   )
                          //   FadeInImage(placeholder: 'assets/image/default.png', image: userImage)
                          FadeInImage.assetNetwork(
                              placeholder: 'assets/images/default.png',
                              image: userImage,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(image!.path).absolute,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: username,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          border: InputBorder.none,
                          hintText: 'Enter Your Name',
                          labelText: 'Your Name',
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Name is Required!!!';
                          } else {
                            return null;
                          }
                        },
                      )),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: useremail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          border: InputBorder.none,
                          hintText: 'Enter Your Email',
                          labelText: 'Your Email',
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Email is Required!!!';
                          } else {
                            return null;
                          }
                        },
                      )),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Number',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: usernumber,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          border: InputBorder.none,
                          hintText: 'Enter Your Number',
                          labelText: 'Your Number',
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Number is Required!!!';
                          } else if (value!.length < 10 || value.length > 10) {
                            return 'Number is not Valid!!!';
                          } else {
                            return null;
                          }
                        },
                      )),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Date Of Birth',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: dateofbirth,
                        decoration: const InputDecoration(
                          labelText: "Select Date",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Date is required';
                          }
                          return null;
                        },
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1947),
                              lastDate: DateTime.now());
                          if (pickedDate != null) {
                            setState(() {
                              dateofbirth.text =
                                  DateFormat('dd-MMM-yyyy').format(pickedDate);
                            });
                          }
                        },
                      )),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Height (cm)',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: userheight,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    border: InputBorder.none,
                                    hintText: 'Enter Your Height',
                                    labelText: 'Your Height',
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Height is Required!!!';
                                    } else {
                                      return null;
                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Weight (Kg)',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: userweight,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    border: InputBorder.none,
                                    hintText: 'Enter Your Weight',
                                    labelText: 'Your Weight',
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Weight is Required!!!';
                                    } else {
                                      return null;
                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'BMI',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: userbmi,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          border: InputBorder.none,
                          hintText: 'Enter Your BMI',
                          labelText: 'Your BMI',
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'BMI is Required!!!';
                          } else {
                            return null;
                          }
                        },
                      )),
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
                          ProfileScreen.mycolor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                    ),
                    onPressed: () {
                      updateUser();
                    },
                    child: !_isLoading
                        ? Text('Update',
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
          )),
    ));
  }
}
