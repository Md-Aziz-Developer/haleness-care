import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart' hide Response;
import 'package:haleness_care/constants/api_path.dart';
import 'package:http/http.dart';

class BlogDetail extends StatefulWidget {
  const BlogDetail({super.key});
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
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  final blogId = Get.arguments;
  @override
  void initState() {
    super.initState();
    getBlogById();
  }

  Future<void> getBlogById() async {
    try {
      Response response = await post(Uri.parse(API_PATH + GET_BLOG_BY_ID),
          body: {'blogId': blogId});
      if (response.statusCode == 200) {
        var myData = jsonDecode(response.body.toString());
        setState(() {
          _isLoading = false;
          _htmlContent = myData['blog']['fld_blog_details'];
          image = myData['blog']['fld_blog_image'];
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

  bool _isLoading = true;

  var _htmlContent = '';
  var image = 'https://worldtradekey.in/healthcrm/uploads/default.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: BlogDetail.mycolor,
          title: const Text(
            'Blog Details',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 10, vertical: 5),
                      height: 200,
                      width: double.infinity,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/background.png',
                        image: image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 10),
                      child: Html(
                          style: {'p': Style(textAlign: TextAlign.justify)},
                          data: _htmlContent),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
