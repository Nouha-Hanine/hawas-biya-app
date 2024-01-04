import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projetiam/firebase_options.dart';
//import 'package:file_picker/file_picker.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HAWAS-BIYA algeriaguide',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: login(),
    );
  }
}
