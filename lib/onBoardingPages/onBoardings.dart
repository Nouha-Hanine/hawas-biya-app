import 'package:flutter/material.dart';
import 'package:hawas_biya_algeria_guide/onBoardingPages/page1.dart';
import 'package:hawas_biya_algeria_guide/onBoardingPages/login_page.dart';
import 'package:provider/provider.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _pagecontroller = PageController();
  bool lastind = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: _pagecontroller,
            onPageChanged: (index) {
              setState(() {
                lastind = (index == 1);
              });
            },
            children: [
              Page1(),
              LoginPage(),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //next button
              children: [
               !lastind ?
              Align(
              alignment: Alignment(0, 0.75),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        child: ElevatedButton(child: Text('Start exploring now !',
          style: TextStyle(color: Colors.white),),
          //TODO this try to make the 'signin' word only him the link!
          onPressed: () {
            _pagecontroller.nextPage(
                duration: Duration(milliseconds: 400),
                curve: Curves.fastEaseInToSlowEaseOut);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD4BE4D),
          ),
        ),

      ),
    ):
                   Row(),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
