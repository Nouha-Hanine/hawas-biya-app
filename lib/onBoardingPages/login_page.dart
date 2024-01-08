import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:hawas_biya_algeria_guide/loading.dart';
import 'package:hawas_biya_algeria_guide/services/authentication.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthenticationService _auth= AuthenticationService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
 // bool loading = false;
  bool showLogIn =
  true;

  final _formkey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //pour degager la memoire
    @override
    void dispose() {
      super.dispose();
      nameController.dispose();
      emailController.dispose();
      passwordController.dispose();
    }
    void toggleView() {
      setState(() {
        _formkey.currentState?.reset();
        error = '';
        nameController.text = '';
        emailController.text = '';
        nameController.text = '';
        passwordController.text = '';
        showLogIn = !showLogIn;
      });

    }//TODO son toggle view n'est pas nécessaire? 4:12
   // loading ? Loading() :
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(showLogIn ? 'Login' : 'Sign up', style:  GoogleFonts.poppins( fontWeight: FontWeight.w500, fontSize: 30,),),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Container(//TODO recheck the image background
          padding: EdgeInsets.only(top: 10), // TODO to FIX for responsivness
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/hawas-biya-logo-stitre.jpeg"),
            fit: BoxFit.scaleDown,
            opacity: 0.2,
          )),
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      !showLogIn ? Container(
                  // name
                  padding: EdgeInsets.symmetric(horizontal: width * 0.005, vertical: height * 0.005),
                  child: TextFormField(
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Name',
                      hintText: 'First name',
                      labelStyle: GoogleFonts.poppins(color: Colors.black),
                      hintStyle: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "You must fill all the fields";
                      }
                      return null;
                    },
                    controller: nameController,
                  ),
                )
                     : Container(),
                      //TODO should i add this: showSignIn ? SizedBox(height: 10.0) : Container(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.005, vertical: height * 0.005),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                              labelStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              hintText: 'email',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder()),
                          validator: (value) => value == null || value.isEmpty
                             ? "you must fill your email" : null,
                          controller: emailController,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: TextFormField(
                          decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              prefixIcon: Icon(Icons.password),
                              labelText: 'Password',
                              labelStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              hintText: 'password',
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              border: OutlineInputBorder()),
                          obscureText: true,
                          validator: (value) => value != null && value.length < 6
                              ? "your password must be at least 6 characters" : null,
                          controller: passwordController,
                          ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async{
                            if (_formkey.currentState?.validate()== true) {
                              setState(() {
                               // loading=true;
                              });
                              final nameval = nameController.text;
                              final emailval = emailController.value.text;
                              final passwordval = passwordController.value.text;
        
                              dynamic result= showLogIn ? await _auth.logInWithEmailAndPassword(emailval, passwordval)
                                  :  await _auth.signUpWithEmailAndPassword(nameval, emailval, passwordval);
                              if(result==null){
                                setState(() {
                                 // loading=false;
                                  error='Please put on a valid email';//TODO msg error par rapport à chaque error
                                });
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                        content: Text(showLogIn ? "Connexion en cours...": "You successfuly created your account! " )));
                                print('ajout de la session $emailval $passwordval ');
                              }
                              //FocusScope.of(context).requestFocus(FocusNode());
        
                            }
                          },
                          child: Text(
                            "SEND",
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color(0xFFFFD786)), //TODO FIX THIS the color
                        ),
                      ),
                      Text(
                      error,
                        style: TextStyle(color: Colors.red, fontSize: 15.0),
                      )
                    ],
                  )),
            SizedBox(height: 45,),
            Container(
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment(0, 0.75),
                      child: GestureDetector(
                          child:Text(showLogIn ? "Don't have an account yet ? \nSign up" : "Log in instead", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500),textAlign: TextAlign.center,), //link
                          onTap: () {
                            toggleView();

                          }),
                    ),
        
                  ],
        
                ),
            )],
          ),
        ),
      ),
    );
  }
}
