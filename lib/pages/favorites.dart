import 'package:flutter/material.dart';
import 'map.dart';
import 'discover.dart';
import 'profile.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}
class _FavoritesState extends  State<Favorites> {
  int selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text('An adventure country is waiting for you , Here you will find all your favorites corners , let start with "LIKE" some places you would like to visit it' ,
          textAlign: TextAlign.center, // Alignement du texte au centre
         style: TextStyle(
          color: Colors.green, // Changer la couleur du texte
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ))
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
      case 2:
      // Vous êtes déjà sur la page Discover, donc pas besoin de navigation ici
        break;
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DiscoverPage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Map()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile()));
        break;
      default:
        break;
    }
  }
}

