import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/Models/LabLocation.dart';
import 'package:lablink/Patient/Pages/ServiceType.dart';
import 'package:lablink/Patient/Pages/review_screen.dart';

class LabDetails extends StatefulWidget {
  final String labId;
  const LabDetails({super.key, required this.labId});

  @override
  State<LabDetails> createState() => _LabDetailsState();
}

class _LabDetailsState extends State<LabDetails> {
  LabLocation? selectedBranch;
  String? uploadedImagePath;
  List<Map<String, dynamic>> selectedTests = [];
  Lab? labData;
  final picker = ImagePicker();
  //File? image;
  @override
  void initState() {
    super.initState();
    fetchLabDetails();
  }

  Future<void> fetchLabDetails() async {
    final data = await FirebaseDatabase().getLabDetails(widget.labId);
    print("Fetched data: $data");
    setState(() {
      labData = data;
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        uploadedImagePath = pickedFile.path;
      });
    }
  }

  void showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Upload Prescription"),
        content: const Text("Choose an option to upload your prescription:"),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text("Capture from Camera"),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text("Choose from Gallery"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (labData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  "assets/images/lab 1.jpg",
                  width: width,
                  height: height * 0.3,
                ),
                Positioned(
                  top: width * 0.07,
                  left: width * 0.05,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: width * 0.05,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.27,
                  left: width * 0.04,
                  right: width * 0.04,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labData!.name,
                            style: TextStyle(
                              fontSize: width * 0.04,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: height * 0.014),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: width * 0.05,
                                color: Color(0xFFFDC700),
                              ),
                              SizedBox(width: height * 0.014),
                              Text(
                                "4.8",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.014),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Color(0xFF4A5565),
                                size: width * 0.05,
                              ),
                              SizedBox(width: height * 0.014),
                              Text(
                                labData!.email,
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Color(0xFF4A5565),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: height * 0.014),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Color(0xFF4A5565),
                                size: width * 0.045,
                              ),
                              SizedBox(width: height * 0.014),
                              Text(
                                labData!.phone,
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Color(0xFF4A5565),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.014),
                          Container(
                            width: width * 0.43,
                            height: height * 0.026,
                            decoration: BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(8),
                            ),

                            child: Center(
                              child: Text(
                                "Home Collection Available",
                                style: TextStyle(
                                  fontSize: width * 0.032,
                                  color: Color(0xFF008236),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: height * 0.2),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00BBA7),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(labId: widget.labId),
                    ),
                  );
                },
                child: Text(
                  "View Reviews",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Upload Prescription",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.04,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () async {
                  showImageSourceDialog();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(thickness: 1, endIndent: 10)),

                  Text("OR"),
                  Expanded(child: Divider(thickness: 1, indent: 10)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Choose from tests",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.04,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: labData!.locations.length,
              itemBuilder: (context, locationIndex) {
                final locations = labData!.locations;

                return ExpansionTile(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                  ),
                  collapsedShape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                  ),
                  title: Text(
                    locations[locationIndex].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(locations[locationIndex].address),
                  children: [
                    ListView.builder(
                      itemCount: locations[locationIndex].tests.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, testIndex) {
                        final tests = locations[locationIndex].tests;
                        selectedBranch = locations[locationIndex];
                        bool isAdded = selectedTests.any(
                          (test) => test['id'] == tests[testIndex].id,
                        );

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tests[testIndex].name,
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        " ${tests[testIndex].price.toString()} \$",
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Color(0xFF0092B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.watch_later_outlined,
                                        color: Color(0xFF6A7282),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Results in ${tests[testIndex].durationMinutes.toString()} hours",
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Color(0xFF6A7282),
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (isAdded) {
                                              selectedTests.removeWhere(
                                                (test) =>
                                                    test['id'] ==
                                                    tests[testIndex].id,
                                              );
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete_outline_outlined,
                                          size: 25,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (!isAdded) {
                                              selectedTests.add(
                                                tests[testIndex].toMap(),
                                              );
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          isAdded
                                              ? Icons.check_rounded
                                              : Icons.add,
                                          size: 25,
                                        ),
                                        //iconSize: 25,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        width: width,
        height: height * 0.09,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [Color(0xFF00B8DB), Color(0xFF00BBA7)],
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceTypeScreen(
                      labData: labData!.toMap(),
                      locationData: selectedBranch!.toMap(),
                      selectedTests: selectedTests,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                "Book Test",
                style: TextStyle(color: Colors.white, fontSize: width * 0.04),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
