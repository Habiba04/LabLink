import 'package:flutter/material.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/Models/Lab.dart';

class AddLab extends StatefulWidget {
  const AddLab({super.key});

  @override
  State<AddLab> createState() => _AddLabState();
}

class _AddLabState extends State<AddLab> {
  final TextEditingController labNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController licenseNumController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController closeAtController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: height * 0.13,
              // padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(width * 0.06),
                  bottomRight: Radius.circular(width * 0.06),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFAD46FF),
                    Color(0xFF4F39F6),
                    Color(0xFF155DFC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Add New Laboratory",
                            style: TextStyle(
                              fontSize: width * 0.06,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Register a new lab in the system",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Color(0xFFFFFFE5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Icon(Icons.business, color: Color(0xFF9810FA)),
                          SizedBox(width: 10),
                          Text(
                            "Laboratory Information",
                            style: TextStyle(
                              fontSize: width * 0.04,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Laboratory Name',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Color(0xFF364153),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: labNameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),
                          //focusColor: Color(0xFFF3F3F5),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Closing Time',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Color(0xFF364153),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: closeAtController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Color(0xFF364153),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Color(0xFF364153),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Phone',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Color(0xFF364153),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFD1D5DC)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Lab newLab = Lab(
                  id: "",
                  name: labNameController.text.trim(),
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim(),
                  rating: 0,
                  reviewCount: 0,
                  distanceKm: 0,
                  closingTime: closeAtController.text.trim(),
                  testsCount: 0,
                  usersCount: 0,
                  lastMonthRevenue: 0,
                );
                String password = passwordController.text.trim();
                await FirebaseDatabase().addNewLab(newLab, password);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Laboratory added successfully"),
                  ),
                );
              },
              child: Container(
                width: width * 0.93,
                height: height * 0.055,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.04),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFAD46FF),
                      Color(0xFF4F39F6),
                      Color(0xFF155DFC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    Text(
                      " Add Laboratory",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.white,
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
