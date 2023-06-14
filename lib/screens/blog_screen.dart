import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:haleness_care/constants/api_path.dart';
import 'package:haleness_care/screens/blog_detail_screen.dart';
import 'package:http/http.dart';
import 'package:shimmer/shimmer.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});
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
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    getInitalData();
  }

  Future<void> getInitalData() async {
    try {
      Response response = await post(Uri.parse(API_PATH + GET_BLOGS), body: {});
      if (response.statusCode == 200) {
        var myData = jsonDecode(response.body.toString());
        setState(() {
          _isLoading = false;
          userBlogs = myData['blog'];
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

  Future<List<Blog>> getAllBlogs() async {
    List<Blog> blogs = [];
    for (var i in userBlogs) {
      Blog blog = Blog(
          i['fld_blog_id'],
          i['fld_blog_title'],
          i['fld_blog_slug'],
          i['fld_blog_image'],
          i['fld_blog_description'],
          i['fld_time']);
      blogs.add(blog);
    }
    return blogs;
  }

  var userBlogs = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder(
              future: getAllBlogs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return _shimmerEffect();
                    },
                  );
                } else {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.data!.isEmpty) {
                    return !_isLoading
                        ? const Center(child: Text('No Blogs Available...'))
                        : ListView.builder(
                            itemCount: 7,
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
                          var title = snapshot.data![index].fld_blog_title;
                          return _singleBlog(
                              snapshot.data![index].fld_blog_image,
                              'Health Advice',
                              snapshot.data![index].fld_blog_description,
                              snapshot.data![index].fld_time,
                              snapshot.data![index].fld_blog_id);
                        },
                      ),
                    );
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _singleBlog(image, category, title, date, id) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  color: Colors.black,
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.dstATop),
                      image: NetworkImage(image),
                      fit: BoxFit.cover),
                ),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        date,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )),
              )),
              Expanded(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          category,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const BlogDetail(), arguments: id);
                          },
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 16, color: BlogScreen.mycolor),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const BlogDetail(), arguments: id);
                          },
                          child: Text(
                            'Read More...',
                            style: TextStyle(color: BlogScreen.mycolor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ))
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
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.dstATop),
                      image: AssetImage('assets/images/background.jpeg'),
                      fit: BoxFit.cover),
                ),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
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
                    )),
              )),
              Expanded(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15)),
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
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
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
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {},
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
                      ),
                    )
                  ],
                ),
              ))
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

class Blog {
  final String fld_blog_id;
  final String fld_blog_title;
  final String fld_blog_slug;
  final String fld_blog_image;
  final String fld_blog_description;
  final String fld_time;
  Blog(this.fld_blog_id, this.fld_blog_title, this.fld_blog_slug,
      this.fld_blog_image, this.fld_blog_description, this.fld_time);
}
