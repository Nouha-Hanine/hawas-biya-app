import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'map.dart';
import 'favorites.dart';
import 'profile.dart';
import 'details.dart';
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


class PlaceCard extends StatelessWidget {
  final Place place;

  PlaceCard({required this.place});

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
              image: DecorationImage(
                image: NetworkImage(place.imageUrlPlace),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            place.namePlace,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(imageUrlPlace: place.imageUrlPlace,
                    namePlace: place.namePlace,
                    detailsPlace: place.detailsPlace,),
                ),
              );
            },
            child: Text('More Details'),
          ),
        ],
      ),
    );
  }
}
class Region {
  final String idr;
  final String idReg;
  final String namer;
  final String photoReg;

  Region({required this.idr,required this.idReg, required this.namer, required this.photoReg});
}

class RegionCard extends StatefulWidget {
  final Region region;
  final Function(String) onRegionSelected;
  RegionCard({super.key, required this.region,required this.onRegionSelected});

  @override
  State<StatefulWidget> createState() {
    return _RegionCardState();
  }
}

class _RegionCardState extends State<RegionCard> {
  late String selectedRegionId;
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onRegionSelected(widget.region.idReg);
        setState(() {
          selectedRegionId = widget.region.idReg;
          isSelected = true;

        }); // Appel de la fonction lors du clic
      },
      child: Container(
        width: 100.0,
        child: Column(
          children: [
            Container(
              width: 110.0,
              height: 150.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.orangeAccent,
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
  final Function(String) onCategorySelected; // Ajout de la fonction de gestion du clic

  CategoryCard({required this.category, required this.onCategorySelected});

  @override
  State<StatefulWidget> createState() {
    return _CategoryCardState();
  }
}



class _CategoryCardState extends State<CategoryCard> {
  bool isSelected = false;
  late String selectedCategoryId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCategorySelected(widget.category.idCat);
        setState(() {
          selectedCategoryId = widget.category.idCat;
          isSelected = true;

        }); // Appel de la fonction lors du clic
      },
      child: Container(
        width: 100.0,
        child: Column(
          children: [
            Container(
              width: 110.0,
              height: 150.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.orangeAccent,
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
  late String selectedRegionId= '';
  late String selectedCategoryId= '';
  Future<List<Region>> getRegions() async {
    try {
      // Récupérez la référence de la collection 'regions' dans Firestore
      QuerySnapshot regionsSnapshot =
      await FirebaseFirestore.instance.collection('regions').get();
      print('Regions snapshot: $regionsSnapshot');
      // Mappez les documents Firestore en objets Region
      List<Region> regions = regionsSnapshot.docs
          .map((doc) {
        final imageUrl = doc['photo-reg'] as String? ?? '';
        print('Image URL for region ${doc['nom-reg']}: $imageUrl');
        return Region(
          idr: doc.id,
          idReg: doc['id-reg'] as String? ?? '',
          namer: doc['nom-reg'] as String? ?? '',
          photoReg: imageUrl,
        );
      })
          .toList();


      return regions;
    } catch (e) {
      print('Error getting regions: $e');
      return []; // Gestion de l'erreur
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      // Récupérez la référence de la collection 'regions' dans Firestore
      QuerySnapshot categoriesSnapshot =
      await FirebaseFirestore.instance.collection('categories').get();
      print('Regions snapshot: $categoriesSnapshot');

      // Mappez les documents Firestore en objets Category
      List<Category> categories = categoriesSnapshot.docs
          .map((doc) {
        final imageUrl = doc['photo-cat'] as String? ?? '';
        print('Image URL for category ${doc['nom-cat']}: $imageUrl');
        return Category(
          id: doc.id,
          idCat: doc['id-cat'] as String? ?? '',
          name: doc['nom-cat'] as String? ?? '',
          photoCat: imageUrl,
        );
      })
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

            // Afficher un message
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Please choose a region and a category to explore the available places within that region and category ',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.green,
                ),
              ),
            ),

            // Section des régions
            regionSection(),
            // Section des catégories
            CategorySection(),

            // Section des résultats
        ResultsSection(context, selectedRegionId, selectedCategoryId),
        

          ],
        ),
      ),
      bottomNavigationBar: _BottomNavigationBar(context),
    );
  }

  Widget UserSection() {
   
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container pour la photo
          Container(
            width: 50.0, 
            height: 50.0, 
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.orangeAccent,
                width: 2.0, 
              ),
              shape: BoxShape.rectangle,
              color: Colors.grey,
            ),
           
            child: Icon(
              Icons.person, 
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
                  'Nom d\'utilisateur', 
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
         
        },
      ),
    );
  }


  Widget regionSection() {
    return FutureBuilder<List<Region>>(
      future: getRegions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            child: Text(
              'REGIONS',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          List<Region> regions = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
                width: 2.0,
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
                        child: RegionCard(
                          region: region,
                          onRegionSelected: (selectedRegionId) {
                            setState(() {
                              // Mise à jour de selectedRegionId
                              this.selectedRegionId = selectedRegionId;
                            });
                          },
                        ),
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
          return Container();
        } else {
          List<Category> categories = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
                width: 2.0,
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
                        child: CategoryCard(
                          category: category,
                          onCategorySelected: (selectedCategoryId) {
                            setState(() {
                              // Mise à jour de selectedCategoryId
                              this.selectedCategoryId = selectedCategoryId;
                            });
                          },
                        ),
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



  Widget ResultsSection(BuildContext context, String selectedRegionId, String selectedCategoryId) {
    return StreamBuilder<QuerySnapshot>(

      stream: FirebaseFirestore.instance
          .collection('places')
          .where('id-reg', isEqualTo: selectedRegionId)
          .where('id-cat', isEqualTo: selectedCategoryId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            child: Text(
              'No results found for the selected region and category.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          // Mappez les documents Firestore en objets Place
          List<Place> places = snapshot.data!.docs
              .map((doc) => Place(
            idPlace: doc.id,
            namePlace: doc['nom-place'] as String? ?? '',
            imageUrlPlace: doc['photo-place'] as String? ?? '',
            detailsPlace: doc['details'] as String? ?? '',
           selectedCategoryId: doc['id-cat'] as String? ?? '',
            selectedRegionId: doc['id-reg'] as String? ?? '',
          ))
              .toList();

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
                width: 2.0,
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                // Titre de la section
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'RESULTS',
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
                    children: places.map((place) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlaceCard(place: place),
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





  Widget _BottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.airplanemode_active),
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
