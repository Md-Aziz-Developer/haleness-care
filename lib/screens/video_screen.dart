import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haleness_care/constants/api_path.dart';
import 'package:http/http.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/link.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});
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
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    getInitalData();
  }

  Future<void> getInitalData() async {
    try {
      Response response =
          await post(Uri.parse(API_PATH + GET_VIDEOS), body: {});
      if (response.statusCode == 200) {
        var myData = jsonDecode(response.body.toString());
        setState(() {
          _isLoading = false;
          userVideos = myData['video'];
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

  Future<List<Video>> getUserVideos() async {
    List<Video> videos = [];
    for (var i in userVideos) {
      Video video = Video(i['fld_video_id'], i['fld_video_code'],
          i['fld_title'], i['fld_thumbnail']);
      videos.add(video);
    }
    return videos;
  }

  var userVideos = [];
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
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                future: getUserVideos(),
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
                          getInitalData();
                        },
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _singleVideo(
                                snapshot.data![index].fld_video_code,
                                snapshot.data![index].fld_title,
                                snapshot.data![index].fld_thumbnail);
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
      ),
    );
  }

  Widget _singleVideo(code, title, image) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              //border: Border.all(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.dstATop),
                      image: NetworkImage(image),
                      fit: BoxFit.cover),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Link(
                    uri: Uri.parse(code),
                    target: LinkTarget.self,
                    builder: (context, followLink) {
                      return GestureDetector(
                        onTap: followLink,
                        child: Container(
                          height: 50,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    style: TextStyle(color: VideoScreen.mycolor, fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _shimmerEffect() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.25),
                    highlightColor: Colors.white.withOpacity(0.6),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.25),
                      highlightColor: Colors.white.withOpacity(0.6),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class Video {
  final String fld_video_id;
  final String fld_video_code;
  final String fld_title;
  final String fld_thumbnail;
  Video(this.fld_video_id, this.fld_video_code, this.fld_title,
      this.fld_thumbnail);
}
