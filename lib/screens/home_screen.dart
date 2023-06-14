import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haleness_care/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      Response response = await post(Uri.parse(API_PATH + GET_ADVICES),
          body: {'userId': userId});
      if (response.statusCode == 200) {
        var myData = jsonDecode(response.body.toString());
        setState(() {
          _isLoading = false;
          userAdvices = myData['advice'];
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

  Future<List<Advice>> getUserAdvices() async {
    List<Advice> advices = [];
    for (var i in userAdvices) {
      Advice advice = Advice(
          i['fld_advice_id'],
          i['fld_profile_id'],
          i['fld_advice'],
          i['fld_time'],
          i['fld_advice_by_id'],
          i['fld_advice_by_name']);
      advices.add(advice);
    }
    return advices;
  }

  var userAdvices = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/images/Chat_back.png'),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: FutureBuilder(
                future: getUserAdvices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: 10,
                      itemBuilder: (context, int index) {
                        var myIndex = index + 1;
                        var even = myIndex % 2;

                        return even == 0
                            ? _shimmerLeftEffect()
                            : _shimmerRightEffect();
                      },
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.data!.isEmpty) {
                      return !_isLoading
                          ? const Center(
                              child: Text('No Advice Given By Dietitian...'))
                          : ListView.builder(
                              reverse: true,
                              itemCount: 10,
                              itemBuilder: (context, int index) {
                                var myIndex = index + 1;
                                var even = myIndex % 2;

                                return even == 0
                                    ? _shimmerLeftEffect()
                                    : _shimmerRightEffect();
                              },
                            );
                    } else {
                      return RefreshIndicator(
                          onRefresh: () async {
                            getInitalData();
                          },
                          child: ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              var myIndex = index + 1;
                              var even = myIndex % 2;
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  even == 0
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              bottom: 5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: const Color.fromRGBO(
                                                      146, 146, 146, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot.data![index]
                                                        .fld_advice_by_name,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data![index].fld_time,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .grey.shade500),
                                                  ),
                                                ],
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(snapshot
                                                    .data![index].fld_advice),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          margin: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              bottom: 5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: const Color.fromRGBO(
                                                      146, 146, 146, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot.data![index]
                                                        .fld_advice_by_name,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data![index].fld_time,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .grey.shade500),
                                                  ),
                                                ],
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(snapshot
                                                    .data![index].fld_advice),
                                              )
                                            ],
                                          ),
                                        )
                                ],
                              );
                            },
                          ));
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _shimmerLeftEffect() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(146, 146, 146, 1)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.25),
                      highlightColor: Colors.white.withOpacity(0.6),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 18,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                      )),
                  Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.25),
                      highlightColor: Colors.white.withOpacity(0.6),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 18,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                      )),
                ],
              ),
              Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.25),
                  highlightColor: Colors.white.withOpacity(0.6),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: 18,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shimmerRightEffect() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          margin:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(146, 146, 146, 1)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.25),
                      highlightColor: Colors.white.withOpacity(0.6),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 18,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                      )),
                  Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.25),
                      highlightColor: Colors.white.withOpacity(0.6),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 18,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                      )),
                ],
              ),
              Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.25),
                  highlightColor: Colors.white.withOpacity(0.6),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: 18,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class Advice {
  final String fld_advice_id;
  final String fld_profile_id;
  final String fld_advice;
  final String fld_time;
  final String fld_advice_by_id;
  final String fld_advice_by_name;
  Advice(this.fld_advice_id, this.fld_profile_id, this.fld_advice,
      this.fld_time, this.fld_advice_by_id, this.fld_advice_by_name);
}
