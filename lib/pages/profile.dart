import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawas_biya_algeria_guide/models/user.dart';
import 'package:hawas_biya_algeria_guide/services/authentication.dart';
import 'package:hawas_biya_algeria_guide/services/database.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});


  @override

  State<ProfilePage> createState() => _ProfilePageState();
}

// TODO should i add a route init attribute in this file? fixTHIS
class _ProfilePageState extends State<ProfilePage> {
  final FirebaseStorage storage =
      FirebaseStorage.instance;
  final AuthenticationService _auth = AuthenticationService();

  PlatformFile? pickedFile;

  Future selectImageFromGallery() async{
    final image= await FilePicker.platform.pickFiles();
    if(image==null) return;
    setState(() {
      pickedFile = image.files.first;
    });
  }

  Future uploadImageToDB() async{
    final file = File(pickedFile!.path!);
    final user =   FirebaseAuth.instance.currentUser!;
    final fileName= file.path.split(Platform.pathSeparator).last;
    final userName = user.displayName;
    final path= '/ProfilePics/$userName/$fileName';
    print("here is your path: $path");//for "debug"
    final ref= FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }



  Future<String> DownloadUrl(String imgName)async{
    String downURL= await storage.ref(imgName).getDownloadURL();
    return downURL;
  }



  @override
  Widget build(BuildContext context)  {
    String? name='';
    String? email= '';
    String? uid='';
    String? photoUrl=null;
    User user = FirebaseAuth.instance.currentUser!;
    if (user != null) {
      print("user is loged in");
      name = user.displayName;
      email = user.email;
      photoUrl = user.photoURL;
      uid = user.uid;
    } else {
      print("user is  NOT loged in");
    }

    final String? msg= "Hello $email";

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
            )),
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          //TODO change icons
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 15, top: 15)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(  //TODO try background color
                    height: 115,
                    width: 130,
                    child: pickedFile == null ?/* new FutureBuilder(
                        future: storage.ref().child(pickedFile!.path!).listAll(),
                        builder:(BuildContext context,
                            AsyncSnapshot<FirebaseStorage.

                        )
                    ),*/
                    //here we'll put futurebuilder to recup image from friestore
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://static.vecteezy.com/system/resources/previews/013/042/571/original/default-avatar-profile-icon-social-media-user-photo-in-flat-style-vector.jpg"),
                      radius: 64,)
                        :CircleAvatar(
                      radius: 64,
                      child: ClipOval(
                        child: Image.file(
                          File(pickedFile!.path!),
                          fit: BoxFit.cover,
                          width: 128,
                          height: 128,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text("Hello", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),),
                      Text(email!, style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w500)),
                      Text(" welcome back !", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500))
                    ], //TODO FIX this add style
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async{
                    await _auth.logOut();
                    //end of session
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.green,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Log out",
                      style: TextStyle(color: Color(0xFF000000), fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(style: BorderStyle.none),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    PopUpNameChanger();  //pop up name changer
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Edit name",
                      style: TextStyle(color: Color(0xFF000000), fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(style: BorderStyle.none),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {//image change
                    print("the button is pressed");
                    selectImageFromGallery();
                  },
                  icon: Icon(
                    Icons.photo,
                    color: Colors.green,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Change Pic",
                      style: TextStyle(color: Color(0xFF000000), fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(style: BorderStyle.none),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),Divider(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async{//image change
                    print("the image should be uploaded");
                    uploadImageToDB();
                  },
                  icon: Icon(
                    Icons.save,
                    color: Colors.green,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Save changes",
                      style: TextStyle(color: Color(0xFF000000), fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(style: BorderStyle.none),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async{

                    deletePopup();
                  //  _auth.logOut();  //TODO FIX THIS from bd auth log  out au lieu de deletion function

                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.green,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Delete account",
                      style: TextStyle(color: Color(0xFF000000), fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(style: BorderStyle.none),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),
              Divider(),
              /* SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    //go to page of comments
                  },
                  icon: Icon(
                    Icons.comment,
                    color: Colors.green,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "See my comments and reviews",
                      style: TextStyle(color: Color(0xFF000000), fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(style: BorderStyle.none),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),
              Divider(),*/
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    //go to page of comments
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.green,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About the app",
                      style: TextStyle(color: Color(0xFF000000), fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(style: BorderStyle.none),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    //go to page of comments
                  },
                  icon: Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.green,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(color: Color(0xFF000000), fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(style: BorderStyle.none),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void deletePopup()async {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Text("Delete your account?", style: TextStyle(fontSize: 25)),
        content: Text('are you sure?',  style: TextStyle(fontSize: 25)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No", style: TextStyle(fontSize: 25, color: Colors.black)),
          ),
          TextButton(
              onPressed: (){
                //TODO find a way to delete  account
                DatabaseService database = DatabaseService(FirebaseAuth.instance.currentUser!.uid);
                database.deleteUser();
                //we call here the delete function
                //after function yes:
                _auth.logOut();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text( " Deletion made successfully" )));
              }, child: Text('Yes',  style: TextStyle(fontSize: 25, color: Colors.black)))
        ],
      );

    });

  }

  Future PopUpNameChanger() async{
    final user = FirebaseAuth.instance.currentUser!;
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Change your name'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your new name',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: ()async{

            print('your old name is $user.displayName');
            DatabaseService database = DatabaseService(FirebaseAuth.instance.currentUser!.uid);
            database.updateName("test"); //TODO find a way to store from the textfield
            //await user!.updateDisplayName("nouha"); //CHange to the input
            print('your new name is $user.displayName');
            Navigator.of(context).pop();
          }, child: Text("Save changes", style:TextStyle(color: Colors.black),),)
        ],
      );
  });
  }

  /*Widget PicChange(){
    DatabaseService database = DatabaseService(FirebaseAuth.instance.currentUser!.uid);
    return StreamBuilder<List<User>>(
    stream: database._usersListFromSnapshot(),
    builder: (context, snapshot){
      if(snapshot.hasError){
        return Text('There is an error');
      } else if( snapshot.hasData){
        final users= snapshot.data!;

        return ListView(
          children: users.map(upda).toList(),
        )
      }
    }

    );
  }

}
