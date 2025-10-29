import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
 import 'package:lablink/Patient/Pages/patient_signin.dart';

// ignore: must_be_immutable
class My_App extends StatelessWidget {
    My_App({super.key});
  User?user=FirebaseAuth.instance.currentUser;
     
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home:// user != null ? PatientHome() : 
    Splach(),);
  }
}

class Splach extends StatefulWidget {
  const Splach({super.key});

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  @override
  void initState() {
    super.initState();
    // _checkUser();
  }

  // Future<void> _checkUser() async {
  //   await Future.delayed(const Duration(seconds: 3));

  //   User? user = FirebaseAuth.instance.currentUser;

  //   if (mounted) {
  //     if (user != null) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const PatientHome()),
  //       );
  //     } else {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const PatientSignin()),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECFEFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 300),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                SizedBox(height: 120, width: 120),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      height: 82,
                      width: 82,
                    ),
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Lab link',
                  style: TextStyle(fontFamily: GoogleFonts.arimo().fontFamily),
                ),
                SizedBox(height: 4),
                Text(
                  'Your health, our priority ',
                  style: TextStyle(
                    color: Color(0xff6A7282),
                    fontFamily: GoogleFonts.arimo().fontFamily,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 15),
                ListTile(
                  leading: Image(
                    image: AssetImage('assets/images/lab_icon.png'),
                  ),
                  title: Text(
                    'Book Lab Tests',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: GoogleFonts.arimo().fontFamily,
                    ),
                  ),
                  subtitle: Text(
                    'Connect with trusted labs near you',
                    style: TextStyle(
                      color: Color(0xff6A7282),
                      fontFamily: GoogleFonts.arimo().fontFamily,
                      //  fontFamily: GoogleFonts.arimo().fontFamily,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                ListTile(
                  leading: Image(
                    image: AssetImage('assets/images/file_icon.png'),
                  ),
                  title: Text(
                    'Upload Prescriptions',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    'Easy prescription-based booking',
                    style: TextStyle(
                      color: Color(0xff6A7282),
                      fontFamily: GoogleFonts.arimo().fontFamily,
                      //  fontFamily: GoogleFonts.arimo().fontFamily,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                ListTile(
                  leading: Image(
                    image: AssetImage('assets/images/down_icon.png'),
                  ),
                  title: Text(
                    'Instant Digital Results',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: GoogleFonts.arimo().fontFamily,
                    ),
                  ),
                  subtitle: Text(
                    'Get results delivered digitally',
                    style: TextStyle(
                      color: Color(0xff6A7282),
                      fontFamily: GoogleFonts.arimo().fontFamily,
                      //  fontFamily: GoogleFonts.arimo().fontFamily,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(height: 40),

                ///
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>   PatientSignin()),
                    );
                  },

                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Color(0xff00B8DB), Colors.teal],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.3),
                          offset: const Offset(0, 3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),

                /////
              ],
            ),
          ),
        ),
      ),
    );
  }
}
