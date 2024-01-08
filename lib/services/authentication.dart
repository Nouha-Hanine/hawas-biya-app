import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hawas_biya_algeria_guide/models/user.dart';
import 'package:hawas_biya_algeria_guide/services/database.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebaseUser(User? user) {
    //TODO add an init
    return user != null ? AppUser(user.uid) : null;
  }

  Stream<AppUser?> get user{
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //login uses the signin meth from firebase
  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

 Future deleteAccount(String? email, String? password)async{

    try{
      User? user =  _auth.currentUser;
      AuthCredential credentials =
      EmailAuthProvider.credential(email: email!, password: password!);
      print(user);
      UserCredential result = await user!.reauthenticateWithCredential(credentials);
      await DatabaseService(result.user!.uid).deleteUser(); // called from database class
      await result.user!.delete();
      return true;
    } catch(exception){
        print(exception.toString());
        return null;
    }
  }


//signup uses the create user from firebase
  Future signUpWithEmailAndPassword(String name, String email, String password) async {
    try {      //TODO add name and confirm password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if(user == null){
        throw Exception("No user found with these credentials");
      } else{
        await user.updateProfile(displayName: name);
        await DatabaseService(user.uid).userSetup(name);
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//logout uses signout
  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
