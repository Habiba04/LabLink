import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Patient/Widgets/profile_listTile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Color(0xFF99A1AF),
        selectedItemColor: Color(0xFF0092B8),
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
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
                        'JD',
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
                          'John Doe',
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
                              'john.doe@email.com',
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
                              '+1 (555) 123-4567',
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
                    ProfileListtile(
                      icon: Icons.person_outline,
                      bgColor: Color(0xFFCEFAFE),
                      title: 'Personal Information',
                      iconColor: Color(0xFF0092B8),
                      width: width * 0.1,
                      height: width * 0.1,
                      borderRadiusWidget: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    ProfileListtile(
                      width: width * 0.1,
                      height: width * 0.1,
                      icon: Icons.location_on_outlined,
                      bgColor: Color(0xFFDBEAFE),
                      title: 'Saved Addresses',
                      iconColor: Color(0xFF155DFC),
                    ),
                    ProfileListtile(
                      width: width * 0.1,
                      height: width * 0.1,
                      icon: Icons.notifications_none,
                      bgColor: Color(0xFFF3E8FF),
                      title: 'Notifications',
                      iconColor: Color(0xFF9810FA),
                    ),
                    ProfileListtile(
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
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _auth.signOut();
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
