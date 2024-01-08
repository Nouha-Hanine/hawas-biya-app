import 'package:flutter/material.dart';
import 'package:hawas_biya_algeria_guide/appPages/home_page.dart';
import 'package:hawas_biya_algeria_guide/appPages/profile_page.dart';
import 'package:hawas_biya_algeria_guide/models/user.dart';
import 'package:hawas_biya_algeria_guide/onBoardingPages/login_page.dart';
import 'package:hawas_biya_algeria_guide/onBoardingPages/onBoardings.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SplashScreenWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
        print("stayed in the login");
        return OnBoarding();
    }
    else {
      print('yolo im in the place of the profile');
      return HomePage();
    }
  }
}
