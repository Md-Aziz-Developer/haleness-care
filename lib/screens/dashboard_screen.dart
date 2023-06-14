import 'package:flutter/material.dart';
import 'package:haleness_care/screens/blog_screen.dart';
import 'package:haleness_care/screens/diet_screen.dart';
import 'package:haleness_care/screens/home_screen.dart';
import 'package:haleness_care/screens/profile_screen.dart';
import 'package:haleness_care/screens/video_screen.dart';
import 'package:haleness_care/widgets/drawer_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
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
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final tabs = [
    const HomeScreen(),
    const VideoScreen(),
    const BlogScreen(),
    const DietScreen(),
    const ProfileScreen()
  ];
  final pageTitles = ['Health Advice', 'Videos', 'Blogs', 'Diets', 'Profile'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: DashboardScreen.mycolor,
          title: Text(
            pageTitles[_currentIndex],
            style: const TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      drawer: const DrawerWidget(),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: DashboardScreen.mycolor,
        items: [
          BottomNavigationBarItem(
              label: 'Home',
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              backgroundColor: DashboardScreen.mycolor),
          BottomNavigationBarItem(
              label: 'Video',
              icon: const Icon(Icons.video_collection),
              tooltip: 'Video',
              backgroundColor: DashboardScreen.mycolor),
          BottomNavigationBarItem(
            label: 'Blogs',
            icon: const Icon(Icons.collections),
            tooltip: 'Blogs',
            backgroundColor: DashboardScreen.mycolor,
          ),
          BottomNavigationBarItem(
            label: 'Diets',
            icon: const Icon(Icons.sports_gymnastics),
            tooltip: 'Diets',
            backgroundColor: DashboardScreen.mycolor,
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            backgroundColor: DashboardScreen.mycolor,
          ),
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
