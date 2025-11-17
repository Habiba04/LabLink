import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/LabAdmin/Pages/PrescriptionViewer.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/Models/LabLocation.dart';
import 'package:lablink/Patient/Pages/ServiceType.dart';
import 'package:lablink/Patient/Pages/review_screen.dart';
import 'package:uuid/uuid.dart';

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
  bool isUploading = false;
  bool get canBookTest {
    return selectedBranch != null && (uploadedImagePath != null || selectedTests.isNotEmpty);
  }

  Uint8List? localFileBytes;
  String? localFileName;
  

  @override
  void initState() {
    super.initState();
    fetchLabDetails();
  }

  Future<void> fetchLabDetails() async {
    try {
      final data = await FirebaseDatabase().getLabDetails(widget.labId);
      print("Fetched data: $data");
      setState(() {
        labData = data;
      });
    } catch (e) {
      print("Error fetching lab details: $e");
    }
  }

  // inside _LabDetailsState
  Future<void> uploadPrescription() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated. Please log in.')),
        );
      }
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
      withData: true, // Crucial for getting the bytes
    );

    if (result == null || result.files.first.bytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File selection cancelled.')),
        );
      }
      return;
    }

    final picked = result.files.first;

    setState(() {
      // 1. Store the local file details
      localFileBytes = picked.bytes;
      localFileName = picked.name;

      // 2. Clear any previously uploaded URL (if the user is replacing a file)
      uploadedImagePath = null;
      isUploading = true;

      // 3. Reset selected tests if user chooses prescription instead
      // (Optional logic based on your UI flow, but good practice to consider)
      // selectedTests = [];
    });

    // Display a confirmation message
    try {
      // Create a unique file name to avoid collisions
      const uuid = Uuid();
      final extension = localFileName?.split('.').last ?? 'jpg';
      final uniqueFileName = '${uuid.v4()}.$extension';
      
      // The storage path must match the security rules: /results/{allPaths=**}
      final storagePath = 'results/$uid/${widget.labId}/prescriptions/$uniqueFileName';

      // 2. Create Storage Reference and Upload
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      
      final uploadTask = storageRef.putData(
        localFileBytes!,  // Pass MIME type for correct handling
      );

      final snapshot = await uploadTask.whenComplete(() {});
      
      // 3. Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // 4. Update state with the URL
      if (mounted) {
        setState(() {
          uploadedImagePath = downloadUrl;
          isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${picked.name} uploaded successfully!")),
        );
      }

    } on FirebaseException catch (e) {
      print("Firebase upload failed: ${e.message}");
      if (mounted) {
        setState(() => isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${e.message}")),
        );
      }
    } catch (e) {
      print("Upload failed: $e");
      if (mounted) {
        setState(() => isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An unknown error occurred during upload.")),
        );
      }
    }
  }

  void showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Upload Prescription"),
        content: const Text("Choose a file to upload your prescription:"),
        actions: [
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await uploadPrescription();
            },
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text("Choose File"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (labData == null || isUploading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.blue
                ),
                if(isUploading) const Padding(padding: EdgeInsets.all(16.0), child: Text("Uploading..."),)
            ],
          )),
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
                              fontSize: width * 0.06,
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
                              RichText(
                                text: TextSpan(
                                  text: labData!.rating.toString(),
                                  style: TextStyle(
                                    fontSize: width * 0.04,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          " (${labData!.reviewCount} reviews)",
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "View Reviews",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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
                    uploadedImagePath == null
                        ? ListTile(
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
                                selectedBranch = locations[locationIndex];
                                showImageSourceDialog();
                              },
                            ),
                          )
                        : ListTile(
                          onTap: () {
                            selectedBranch = locations[locationIndex];
                            showImageSourceDialog();
                          },
                            title: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  "Prescription Uploaded",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: width * 0.04,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "Tap to view or change",
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // VIEW BUTTON
                                IconButton(
                                  icon: Icon(
                                    Icons.visibility,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PrescriptionViewer(
                                          url:
                                              uploadedImagePath!, // Must be an image URL
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // CHANGE BUTTON
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () {
                                    selectedBranch = locations[locationIndex];
                                    showImageSourceDialog(); // Pick new file
                                  },
                                ),
                              ],
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
        height: height * 0.1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: canBookTest
                  ? LinearGradient(
                      colors: [Color(0xFF00B8DB), Color(0xFF00BBA7)],
                    )
                  : null, // ❗ No gradient when disabled
              color: canBookTest ? null : Colors.grey.shade400,
            ),
            child: ElevatedButton(
              onPressed: canBookTest
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceTypeScreen(
                            labData: labData!.toMap(),
                            locationData: selectedBranch!.toMap(),
                            selectedTests: selectedTests,
                            prescroptionPath: uploadedImagePath,
                          ),
                        ),
                      );
                    }
                  : null, // ← disables the button
              style: ElevatedButton.styleFrom(
                backgroundColor: canBookTest
                    ? Colors.transparent
                    : Colors.grey.shade400,
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
