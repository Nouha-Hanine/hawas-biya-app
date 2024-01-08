import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hawas_biya_algeria_guide/models/user.dart';
import 'package:hawas_biya_algeria_guide/onBoardingPages/splashscreen_wrapper.dart';
import 'package:hawas_biya_algeria_guide/services/authentication.dart';
import 'package:provider/provider.dart';
import 'services/firebase_options.dart';


void main() async{

  //in case du mal à se connect on doit init
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); //IMPORTANT DONT DELETE APP CHECK ERROR
 /* await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );*/
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((value)=> runApp(MyApp()));
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Onboarding screens for the app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreenWrapper(),
      ),
    );
    //TODO should i add aroute generator??
  }
}

