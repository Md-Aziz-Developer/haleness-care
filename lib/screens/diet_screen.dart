import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haleness_care/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart';
import 'package:url_launcher/link.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});
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
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    getInitalData();
  }

  Future<void> getInitalData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = jsonDecode(prefs.get('userId').toString());
    try {
      Response response =
          await post(Uri.parse(API_PATH + GET_DIETS), body: {'userId': userId});
      if (response.statusCode == 200) {
        var myData = jsonDecode(response.body.toString());
        setState(() {
          _isLoading = false;
          userDiets = myData['diet'];
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Diet>> getUserDiets() async {
    List<Diet> diets = [];
    for (var i in userDiets) {
      Diet diet = Diet(
          i['fld_diet_id'],
          i['fld_feedback'],
          i['fld_diet_number'],
          i['fld_weight_update'],
          i['fld_image_update'],
          i['fld_diet_plan_attachment'],
          i['fld_from_date'],
          i['fld_to_date'],
          i['fld_remarks']);
      diets.add(diet);
    }
    return diets;
  }

  var userDiets = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/images/Chat_back.png'),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: FutureBuilder(
              future: getUserDiets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _shimmerEffect();
                    },
                  );
                } else {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.data!.isEmpty) {
                    return !_isLoading
                        ? const Center(child: Text('No Diets Available...'))
                        : ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return _shimmerEffect();
                            },
                          );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          getInitalData();
                        });
                      },
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _singleDietDeisgn(
                              snapshot.data![index].fld_diet_id,
                              snapshot.data![index].fld_weight_update,
                              snapshot.data![index].fld_from_date,
                              snapshot.data![index].fld_to_date,
                              snapshot.data![index].fld_feedback,
                              snapshot.data![index].fld_remarks,
                              snapshot.data![index].fld_image_update,
                              snapshot.data![index].fld_diet_plan_attachment);
                          //return _singleDietDeisgn();
                        },
                      ),
                    );
                  }
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget _singleDiet(index, weight, from, to, feedback, remarks, image, diet) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(54, 130, 127, 0.1),
                  Colors.white,
                ],
                begin: FractionalOffset(1.0, 0.0),
                end: FractionalOffset(0.0, 1.0),
                stops: [0.5, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Diet Number',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const Text(' - ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        Text(
                          index,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Weight Update',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const Text(' - ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        Text(
                          weight,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Image Update',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const Text(' - ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        image != ''
                            ? Link(
                                uri: Uri.parse(image),
                                target: LinkTarget.blank,
                                builder: (context, followLink) {
                                  return GestureDetector(
                                    onTap: followLink,
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: DietScreen.mycolor,
                                    ),
                                  );
                                })
                            : const Text(''),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Diet Plan',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const Text(' - ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        diet != ''
                            ? Link(
                                uri: Uri.parse(diet),
                                target: LinkTarget.blank,
                                builder: (context, followLink) {
                                  return GestureDetector(
                                    onTap: followLink,
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      color: DietScreen.mycolor,
                                    ),
                                  );
                                })
                            : const Text(''),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('From',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const Text(' - ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        Text(
                          from,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('To',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const Text(' - ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        Text(
                          to,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                      flex: 3,
                      child: Text('Feedback',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600))),
                  const Expanded(
                      flex: 1,
                      child: Text(' - ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600))),
                  Expanded(flex: 7, child: Text(feedback))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                      flex: 3,
                      child: Text('Remarks',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600))),
                  const Expanded(
                      flex: 1,
                      child: Text(' - ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600))),
                  Expanded(flex: 7, child: Text(remarks))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _singleDietDeisgn(
      index, weight, from, to, feedback, remarks, image, diet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Diet No - $index',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '$from',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Feedback ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  image != ''
                      ? Link(
                          uri: Uri.parse(image),
                          target: LinkTarget.blank,
                          builder: (context, followLink) {
                            return GestureDetector(
                              onTap: followLink,
                              child: Icon(
                                Icons.picture_in_picture_alt,
                                color: DietScreen.mycolor,
                              ),
                            );
                          })
                      : const Text('')
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  feedback,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Remarks ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  diet != ''
                      ? Link(
                          uri: Uri.parse(diet),
                          target: LinkTarget.blank,
                          builder: (context, followLink) {
                            return GestureDetector(
                              onTap: followLink,
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: DietScreen.mycolor,
                              ),
                            );
                          })
                      : const Text('')
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  remarks,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weight Update - $weight Kg',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '$to',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _shimmerEffect() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(54, 130, 127, 0.1),
                  Colors.white,
                ],
                begin: FractionalOffset(1.0, 0.0),
                end: FractionalOffset(0.0, 1.0),
                stops: [0.5, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.25),
                              highlightColor: Colors.white.withOpacity(0.6),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.25),
                              highlightColor: Colors.white.withOpacity(0.6),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.25),
                              highlightColor: Colors.white.withOpacity(0.6),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.25),
                              highlightColor: Colors.white.withOpacity(0.6),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.25),
                              highlightColor: Colors.white.withOpacity(0.6),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.25),
                              highlightColor: Colors.white.withOpacity(0.6),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                height: 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.25),
                        highlightColor: Colors.white.withOpacity(0.6),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          height: 18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.25),
                        highlightColor: Colors.white.withOpacity(0.6),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          height: 18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class Diet {
  final String fld_diet_id;
  final String fld_feedback;
  final String fld_diet_number;
  final String fld_weight_update;
  final String fld_image_update;
  final String fld_diet_plan_attachment;
  final String fld_from_date;
  final String fld_to_date;
  final String fld_remarks;
  Diet(
      this.fld_diet_id,
      this.fld_feedback,
      this.fld_diet_number,
      this.fld_weight_update,
      this.fld_image_update,
      this.fld_diet_plan_attachment,
      this.fld_from_date,
      this.fld_to_date,
      this.fld_remarks);
}
