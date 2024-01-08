import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});
//TODO add cache ilage to opt
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          //link to image to be changed to read from bdS
          image: AssetImage("assets/images/85 (1).jpg"),
          fit: BoxFit.cover,
          opacity: 0.8,
          //colorFilter: ColorFilter.srgbToLinearGamma()
        )),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[ Row(
              mainAxisAlignment: MainAxisAlignment.start,
            children: [
          //Padding(padding: EdgeInsets.all(2)),
          /*Image.asset("assets/images/hawas-biya-logo.jpeg",
            width: MediaQuery.of(context).size.width * 0.4, // 80% of screen width
            height: MediaQuery.of(context).size.height * 0.4, ),*/
          Padding(padding: EdgeInsets.all(0)),
          BorderedText(
            strokeColor: Colors.black26,
            strokeWidth: 2.5,
            child: Text(
              "Hawas Biya",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 55,
                  fontWeight: FontWeight.w600,
                  wordSpacing: 1,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
            ]),
          Row(
            children: [
              BorderedText(
                strokeColor: Colors.black26,
                strokeWidth: 2.5,
                child: Text(
                  "Algerian Guide",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      wordSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 0, right: 5)),
                Expanded(
                  child: Text("Welcome to the best Algeria guide, your gateway to the vibrant tapestry of Algeria's hidden treasure!\nOur app is your personalized guide to discover the beauty,authenticity and warmth of this beautiful country.",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: MediaQuery.of(context).size.width * 0.05,),
                  textAlign: TextAlign.start,

                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 0, right: 5,)),
                Expanded(child: Text("So start your trip with us now !",
                style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w500),)),

              ],
            )
        ]));
  }
}
