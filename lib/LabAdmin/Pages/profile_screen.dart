import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Database/firebase_DB.dart';
import 'package:lablink/LabAdmin/Pages/edit_profile_screen.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/Patient/Pages/Patient_SignIn.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final labId = FirebaseAuth.instance.currentUser!.uid;
  Lab? labData;
  bool _isLoading = true;

  Future<void> _fetchLabData() async {
    setState(() => _isLoading = true);
    print('lab id: ${labId}');
    final _labData = await FirebaseDatabase().getLabDetails(labId);

    if (!mounted) return;

    setState(() {
      labData = _labData;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchLabData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Lab Profile', style: TextStyle(fontSize: width * 0.04)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: width * 0.06),
                    child: Container(
                      width: width * 0.86,
                      height: height * 0.19,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Color(0xFF00BBA7), Color(0xFF00B8DB)],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  width: width * 0.17,
                                  height: width * 0.17,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      width * 0.04,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.location_city_rounded,
                                    color: Color(0xFF009689),
                                    size: width * 0.09,
                                  ),
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    labData!.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width * 0.05,
                                    ),
                                  ),
                                  SizedBox(height: width * 0.01),
                                  Text(
                                    'Laboratory Dashboard',
                                    style: TextStyle(
                                      color: Color(0xFFCBFBF1),
                                      fontSize: width * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                ),
                              ).then((_) {
                                _fetchLabData();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: width * 0.7,
                                height: height * 0.04,
                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit_square,
                                        color: Color(0xFF009689),
                                        size: width * 0.04,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                          color: Color(0xFF009689),
                                          fontSize: width * 0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(width * 0.06),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Contact Information',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Color(0xFF6A7282),
                              ),
                            ),
                            subtitle: Text(
                              labData!.email,
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Color(0xFF101828),
                              ),
                            ),
                            leading: Icon(
                              Icons.email_outlined,
                              color: Color(0xFF6A7282),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Phone',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Color(0xFF6A7282),
                              ),
                            ),
                            subtitle: Text(
                              labData!.phone,
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Color(0xFF101828),
                              ),
                            ),
                            leading: Icon(
                              Icons.phone,
                              color: Color(0xFF6A7282),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Address of the main branch',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Color(0xFF6A7282),
                              ),
                            ),
                            subtitle: Text(
                              labData?.locations.isNotEmpty == true
                                  ? labData!.locations.first.address ?? ''
                                  : '',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Color(0xFF101828),
                              ),
                            ),
                            leading: Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF6A7282),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Closing Hours',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Color(0xFF6A7282),
                              ),
                            ),
                            subtitle: Text(
                              labData!.closingTime,
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Color(0xFF101828),
                              ),
                            ),
                            leading: Icon(
                              Icons.watch_later_outlined,
                              color: Color(0xFF6A7282),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(width * 0.06),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(width * 0.06),
                            child: Text(
                              'Available Branches',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width * 0.04,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: labData!.locations.length,
                            itemBuilder: (context, index) {
                              final location = labData!.locations[index];
                              return ListTile(
                                title: Text(
                                  location.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: width * 0.04,
                                  ),
                                ),
                                subtitle: Text(
                                  location.address,
                                  style: TextStyle(
                                    color: Color(0xFF6A7282),
                                    fontSize: width * 0.04,
                                  ),
                                ),
                                trailing: Text(
                                  "From ${location.openAt}\nTo ${location.closeAt}",
                                  style: TextStyle(
                                    color: Color(0xFF009689),
                                    fontSize: width * 0.04,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        _auth.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientSignin(),
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
                ],
              ),
            ),
    );
  }
}
