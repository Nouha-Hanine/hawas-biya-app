import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'map.dart';
import 'favorites.dart';
import 'profile.dart';
import 'details.dart';
class Region {
  final String idr;
  final String idReg;
  final String namer;
  final String photoReg;

  Region({required this.idr,required this.idReg, required this.namer, required this.photoReg});
}

class RegionCard extends StatefulWidget {
  final Region region;

  RegionCard({super.key, required this.region});

  @override
  State<StatefulWidget> createState() {
    return _RegionCardState();
  }
}

class _RegionCardState extends State<RegionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      child: Column(
        children: [
          Container(
            width: 110.0,
            height: 150.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.orangeAccent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
              image: widget.region.photoReg.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(widget.region.photoReg),
                fit: BoxFit.cover,
              )
                  : const DecorationImage(
                image: AssetImage('hawas-biya-logo-rm.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            widget.region.namer,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}




class Category {
  final String id;
  final String name;
  final String idCat;
  final String photoCat;

  Category({required this.id,required this.idCat, required this.name, required this.photoCat});
}
class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard({super.key, required this.category});

  @override
  State<StatefulWidget> createState() {
    return _CategoryCardState();
  }
}



class _CategoryCardState extends State<CategoryCard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      child: Column(
        children: [
          Container(
            width: 110.0,
            height: 150.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.orangeAccent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
              image: widget.category.photoCat.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(widget.category.photoCat),
                fit: BoxFit.cover,
              )
                  : const DecorationImage(
                image: AssetImage('hawas-biya-logo-rm.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            widget.category.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}
class _DiscoverPageState extends  State<DiscoverPage> {
  int selectedIndex = 0;
  Future<List<Region>> getRegions() async {
    try {
      // Récupérez la référence de la collection 'regions' dans Firestore
      QuerySnapshot regionsSnapshot =
      await FirebaseFirestore.instance.collection('regions').get();

      // Mappez les documents Firestore en objets Region
      List<Region> regions = regionsSnapshot.docs
          .map((doc) => Region(
        id: doc.id,
        idReg: doc['id-reg'] as String? ?? '',
        name: doc['nom-reg'] as String? ?? '',
        imageUrl: doc['photo-reg'] as String? ?? '',
      ))
          .toList();

      return regions;
    } catch (e) {
      print('Error getting regions: $e');
      return []; // Gestion de l'erreur
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      // Récupérez la référence de la collection 'categories' dans Firestore
      QuerySnapshot categorySnapshot =
      await FirebaseFirestore.instance.collection('categories').get();

      // Mappez les documents Firestore en objets Category
      List<Category> categories = categorySnapshot.docs
          .map((doc) => Category(
        id: doc.id,
        idCat: doc['id-cat'] as String? ?? '',
        name: doc['nom-cat'] as String? ?? '',
        imageUrl: doc['photo-cat'] as String? ?? '',
      ))
          .toList();

      return categories;
    } catch (e) {
      print('Error getting categories: $e');
      return []; // Gestion de l'erreur
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),


      ),
      body:  SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section de l'utilisateur
            UserSection(),

            // Barre de recherche
            buildSearchBar(),

            // Section des régions
            RegionSection(),

            // Section des catégories
            CategorySection(),

            // Section des résultats
            ResultsSection(context),

          ],
        ),
      ),
      bottomNavigationBar: _BottomNavigationBar(context),
    );
  }

  Widget UserSection() {
    // Ici, vous pouvez récupérer les informations de l'utilisateur depuis Firebase
    // (photo, nom, etc.) et les afficher.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container pour la photo
          Container(
            width: 50.0, // Ajustez la largeur selon vos besoins
            height: 50.0, // Ajustez la hauteur selon vos besoins
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.orangeAccent,
                width: 2.0, // Ajustez la largeur de la bordure selon vos besoins
              ),
              shape: BoxShape.rectangle,
              color: Colors.grey, // Vous pouvez remplacer cela par la vraie image
            ),
            // Placeholder pour la photo de l'utilisateur
            child: Icon(
              Icons.person, // Vous pouvez remplacer cela par la vraie image
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10.0), // Marge entre la photo et le texte

          // Container pour le texte "HELLO" et le nom d'utilisateur
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HELLO',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Nom d\'utilisateur', // Remplacez cela par le vrai nom d'utilisateur
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search a place you want to visit...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        onChanged: (value) {
          // Mettez en œuvre votre logique de filtrage ici en fonction de la valeur saisie
          // par l'utilisateur (value).
          // Par exemple, vous pouvez mettre à jour une liste filtrée.
        },
      ),
    );
  }


  Widget RegionSection() {
    return FutureBuilder<List<Region>>(
      future: getRegions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(); // Gestion du cas où il n'y a pas de données
        } else {
          List<Region> regions = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
                width: 2.0, // Ajustez la largeur de la bordure selon vos besoins
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                // Titre de la section
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'REGIONS',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Utilisation de SingleChildScrollView pour permettre le défilement vertical
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: regions.map((region) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RegionCard(region: region),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }


  Widget CategorySection() {
    return FutureBuilder<List<Category>>(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(); // Gestion du cas où il n'y a pas de données
        } else {
          List<Category> categories = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
                width: 2.0, // Ajustez la largeur de la bordure selon vos besoins
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                // Titre de la section
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'CATEGORIES',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Utilisation de SingleChildScrollView pour permettre le défilement vertical
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CategoryCard(category: category),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }



  Widget ResultsSection(BuildContext context) {
    // Ici, vous pouvez récupérer les résultats depuis Firebase en fonction
    // de la région et de la catégorie sélectionnées, et les afficher.
    // Utilisez un StreamBuilder pour mettre à jour l'interface utilisateur en temps réel.
    return Container(
      // Placeholder pour la section des résultats
    );
  }

  Widget _BottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
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
    case 0:
    // Vous êtes déjà sur la page Discover, donc pas besoin de navigation ici
      break;
    case 1:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Map()));
      break;
    case 2:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Favorites()));
      break;
    case 3:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile()));
      break;
    default:
      break;
  }
}
}
