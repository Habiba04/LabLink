import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/Models/Patient.dart';
import 'package:lablink/Patient/Pages/PatientSignIn.dart';
import 'package:lablink/Patient/Pages/edit_profile_screen.dart';
import 'package:lablink/Patient/Pages/help_and_support.dart';
import 'package:lablink/Patient/Services/patient_services.dart';
import 'package:lablink/Patient/Widgets/profile_listTile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Patient? currentUser;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final userData = await PatientServices().getCurrentUserData();
    if (userData != null) {
      setState(() {
        currentUser = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),

      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              height: height * 0.15,
              // padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(width * 0.06),
                  bottomRight: Radius.circular(width * 0.06),
                ),
                gradient: LinearGradient(
                  colors: [Color(0xFF00B8DB), Color(0xFF00BBA7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: width * 0.1,
                      backgroundColor: Colors.white,
                      child: Text(
                        currentUser!.name.substring(
                          0,
                          currentUser!.name.length >= 2
                              ? 2
                              : currentUser!.name.length,
                        ),
                        style: TextStyle(
                          color: Color(0xFF0092B8),
                          fontSize: width * 0.06,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentUser!.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.04,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Color(0xFFCEFAFE),
                            ),
                            Text(
                              " ${currentUser!.email}",
                              style: TextStyle(
                                color: Color(0xFFCEFAFE),
                                fontSize: width * 0.04,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Color(0xFFCEFAFE)),
                            Text(
                              " ${currentUser!.phone}",
                              style: TextStyle(
                                color: Color(0xFFCEFAFE),
                                fontSize: width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: width * 0.06),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.06),
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        ).then((_) {
                          loadUserData();
                        });
                      },
                      child: ProfileListtile(
                        icon: Icons.person_outline,
                        bgColor: Color(0xFFCEFAFE),
                        title: 'Edit Personal Information',
                        iconColor: Color(0xFF0092B8),
                        width: width * 0.1,
                        height: width * 0.1,
                        borderRadiusWidget: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    ProfileListtile(
                      width: width * 0.1,
                      height: width * 0.1,
                      icon: Icons.location_on_outlined,
                      bgColor: Color(0xFFDBEAFE),
                      title: currentUser!.address == " "
                          ? 'Saved Address'
                          : currentUser!.address,

                      iconColor: Color(0xFF155DFC),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpAndSupport(),
                          ),
                        );
                      },
                      child: ProfileListtile(
                        width: width * 0.1,
                        height: width * 0.1,
                        icon: Icons.help_outline,
                        bgColor: Color(0xFFFFEDD4),
                        title: 'Help & Support',
                        iconColor: Color(0xFFF54900),
                        borderRadiusWidget: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _auth.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PatientSignin(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Container(
                          width: width * 0.9,
                          height: height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xFFFFC9C9),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Color(0xFFE7000B),
                                  size: width * 0.04,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Color(0xFFE7000B),
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
