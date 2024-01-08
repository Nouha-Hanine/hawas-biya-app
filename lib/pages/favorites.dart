import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'discover.dart';
import 'map.dart';
import 'profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Place {
  final String idPlace;
  final String namePlace;
  final String imageUrlPlace;
  final String detailsPlace;
  final String selectedCategoryId;
  final String selectedRegionId;

  Place({
    required this.idPlace,
    required this.namePlace,
    required this.imageUrlPlace,
    required this.detailsPlace,
    required this.selectedCategoryId,
    required this.selectedRegionId,
  });
}

class Utilisateur {
  final String uid;

  Utilisateur({required this.uid});
}

class Favorites extends StatefulWidget {
  final Utilisateur? utilisateur;
  final Place? place;

  Favorites({
    this.utilisateur,
    this.place,
  });

  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<Favorites> {
  List<Place> favorisPlaces = [];
  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();

    loadFavoris();
  }

  Future<void> loadFavoris() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String uid = currentUser.uid;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('favoris')
          .where('uid', isEqualTo: uid)
          .get();

      List<Place> places = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        String placeId = document['id-place'];

        DocumentSnapshot placeSnapshot = await FirebaseFirestore.instance
            .collection('places')
            .doc(placeId)
            .get();

        places.add(Place(
          idPlace: placeSnapshot['id-place'],
          namePlace: placeSnapshot['nom-place'],
          imageUrlPlace: placeSnapshot['photo-place'],
          detailsPlace: '',
          selectedCategoryId: '',
          selectedRegionId: '',

        ));
      }

      setState(() {
        favorisPlaces = places;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: favorisPlaces.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(
                      favorisPlaces[index].imageUrlPlace,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                    title: Text(favorisPlaces[index].namePlace),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('favoris')
                            .doc(favorisPlaces[index].idPlace)
                            .delete();
                        // Rechargez la liste des favoris
                        await loadFavoris();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


