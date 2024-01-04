import 'package:flutter/material.dart';
import 'discover.dart';
class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Naviguer vers la page suivante (par exemple, SearchPage)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiscoverPage()),
            );
          },
          child: Text('Se connecter'),
        ),
      ),
    );
  }
}
