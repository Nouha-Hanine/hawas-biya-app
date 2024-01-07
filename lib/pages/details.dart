import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'discover.dart';
import 'favorites.dart';

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

class DetailsPage extends StatefulWidget {
  final String imageUrlPlace;
  final String namePlace;
  final String detailsPlace;
  final Utilisateur? utilisateur;
  final Place? place;

  DetailsPage({
    required this.imageUrlPlace,
    required this.namePlace,
    required this.detailsPlace,
     this.utilisateur,
     this.place,
  });
  @override
  _DetailsPageState createState() => _DetailsPageState();

}

class _DetailsPageState extends State<DetailsPage> {
  bool isFavorite = false;
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    Future<void> addToFavorites() async {

      Utilisateur? utilisateur = widget.utilisateur;
      Place? place = widget.place;
      if (utilisateur != null && place != null) {
      await FirebaseFirestore.instance.collection('favoris').add({
        'uid': utilisateur.uid,
        'id-place': place.idPlace,
      });
    }}
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              alignment: Alignment.topRight,
              children: [
                Image.network(
                  widget.imageUrlPlace,
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                    size: 40.0,
                  ),
                  onPressed: () async {
                    await addToFavorites();

                    setState(() {
                      isFavorite = true;
                    });
                  },



                ),

              ],
            ),
            // Place details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.namePlace,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: List.generate(
                      5,
                          (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: index < rating ? Colors.yellow : Colors.grey,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.detailsPlace,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What people said',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  for (int i = 0; i < 3; i++)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [

                          Container(
                            width: 50.0,
                            height: 50.0,
                            color: Colors.grey,
                            // TODO: Load photo from Firestore 
                          ),
                          SizedBox(width: 16.0),
                          // Text for comment
                          Expanded(
                            child: Text(
                              ' Comment ',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            //
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Add your comment...',
                  border: OutlineInputBorder(),
                ),
                // TODO: Implement logic to add user comments to Firestore
              ),
            ),
          ],
        ),
      ),
    );
  }
}
