import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    Center( //call class discover de la page discover
      child: Text("Discover "), //TODO add for discover nouha, name of user
    ),
    MapPage(),
    Center( //same here tu peux appeler la class Favorite() que tu as codé
      child: Text("Favorites"), //TODO add users X places for nouha favorites
    ),
    ProfilePage(),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //partie base de données
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
      //une bottomnavigationbbar unique 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.airplanemode_active), label: "Discover"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),//you can change the icons par rapport à ce que tu as deja choisis
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: "Profile"),
        ],
      ),
    );
  }
}


