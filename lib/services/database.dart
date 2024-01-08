import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hawas_biya_algeria_guide/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");


  Future<void> saveUser() async{ //add the other properties
    User user = FirebaseAuth.instance.currentUser!;
    return await userCollection.doc(uid).set({
      'name' : user.displayName,
      'photo':  user.photoURL,//and other properties of user
    });
  }
  Future<void> updateName(String? newName) async{
    User user = FirebaseAuth.instance.currentUser!;
    await user!.updateDisplayName(newName);
    userCollection.add({
      'displayName': newName,
    });
  }

  Future<void> userSetup(String displayName) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = FirebaseAuth.instance.currentUser!;
    userCollection.add({
      'displayName': displayName,
      'uid': uid.toString(), //add other properties
      'email': user.email,
      'photo':  user.photoURL,
      //'comments': ,
    } );
    return;
  }
  Future deleteUser() {
    print("let's  delete this account !");
    return userCollection.doc(uid).delete();
  }

  //pour afficher les att de chaque user
  AppUserData _userFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) throw Exception("user not found");
    return AppUserData(
      uid: snapshot.id,
      name: snapshot['name'],
      // Add other fields as needed
    );
  }

  //pour afficher la liste des usres
  List<AppUserData> _usersListFromSnapshot(QuerySnapshot snapshot) {
   return snapshot.docs.map((doc){
     return _userFromSnapshot(doc);
   }).toList();
  }

  Stream<AppUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }
  Stream<List<AppUserData>> get users {
    return userCollection.snapshots().map(_usersListFromSnapshot);
  }
}