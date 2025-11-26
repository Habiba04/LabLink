import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lablink/Patient/Pages/PatientSignIn.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECFEFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                /// Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 30),

                /// App name
                const Text(
                  'Lab Link',
                  style: TextStyle(fontSize: 20, color: Color(0xFF00BBA7)),
                ),
                const SizedBox(height: 8),

                /// Subtitle
                const Text(
                  'Your health, our priority',
                  style: TextStyle(color: Color(0xff6A7282), fontSize: 15),
                ),
                const SizedBox(height: 40),

                /// Feature 1
                featureTile(
                  icon: FontAwesomeIcons.vial,
                  title: 'Book Lab Tests',
                  subtitle: 'Connect with trusted labs near you',
                  circleColor: const Color(0xFFE6F3FF),
                  iconColor: const Color(0xFF1E88E5),
                  color: const Color(0xFF1E88E5).withOpacity(0.1), // bluish
                ),
                const SizedBox(height: 50),

                /// Feature 2 — File
                featureTile(
                  icon: Icons.description_outlined,
                  title: 'Upload Prescriptions',
                  subtitle: 'Easy prescription-based booking',
                  circleColor: const Color(0xFFEAFBF6),
                  iconColor: const Color(0xFF00BBA7),
                  color: const Color(0xFF00BBA7).withOpacity(0.1), // teal-green
                ),
                const SizedBox(height: 50),

                featureTile(
                  icon: Icons.file_download_outlined,
                  title: 'Instant Digital Results',
                  subtitle: 'Get results delivered digitally',
                  circleColor: const Color(0xFFF4E9FF),
                  iconColor: const Color(0xFF8E24AA),
                  color: const Color(0xFF8E24AA).withOpacity(0.1), // purpleish
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PatientSignin(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00B4DB), Color(0xFF00BBA7)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// Footer
                const Text.rich(
                  TextSpan(
                    text: 'Contact us at ',
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                    children: [
                      TextSpan(
                        text: 'info@lablink.com',
                        style: TextStyle(
                          color: Color(0xFF00BBA7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable feature tile
  Widget featureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required Color circleColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xff6A7282), fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
