import 'package:flutter/material.dart';
import 'map.dart';
import 'favorites.dart';
import 'discover.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends  State<Profile> {
  int selectedIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('Profile Page Content'),
            // Barre de navigation

          ],
        ),
      ),
      bottomNavigationBar: _BottomNavigationBar(context),
    );
  }



  Widget _BottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.explore,color: Colors.green),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map,color: Colors.green),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite,color: Colors.green),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person,color: Colors.green),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.red,
      onTap: onItemTapped,
    );
  }


// Fonction appelée lorsqu'un élément de la barre de navigation est cliqué
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;

    });

    // Utilisez Navigator pour naviguer vers la page correspondante
    switch (index) {
      case 3:
      // Vous êtes déjà sur la page Discover, donc pas besoin de navigation ici
        break;
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DiscoverPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Favorites()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Map()));
        break;
      default:
        break;
    }
  }
}
