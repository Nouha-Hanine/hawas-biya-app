import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hawas_biya_algeria_guide/appPages/discover_page.dart';
import 'package:hawas_biya_algeria_guide/appPages/favorite_page.dart';
import 'package:hawas_biya_algeria_guide/appPages/map_page.dart';
import 'package:hawas_biya_algeria_guide/appPages/profile_page.dart';
import 'package:hawas_biya_algeria_guide/models/user.dart';
import 'package:hawas_biya_algeria_guide/services/database.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState();
}

class _HomePageState extends State {
  int _selectedTab = 0;

  List _pages = [
    DiscoverPage(),//TODO add for discover nouha, name of user
    MapPage(),
    Favorites(),//TODO add users X places for nouha favorites
    ProfilePage(),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    if (user != null) {
      print("user is loged in");
      String? name = user.displayName;
      String? email = user.email;
      //Uri? photoUrl = user.photoURL;
      String? uid = user.uid;
    } else {
      print("user is  NOT loged in");
    }


    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
        selectedItemColor: Color(0xFF0A8B0E),
        unselectedItemColor: Color(0xFFD2BD4D),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: "Discover"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map",),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}


