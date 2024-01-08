import 'package:flutter/material.dart';
import 'discover.dart';
import 'favorites.dart';
import 'profile.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}
class _MapState extends  State<Map> {
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('Map Page Content'),
            // Barre de navigation

          ],
        ),
      ),
    );
  }



