import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/shared_files/common_widgets/edit_profile_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final labId = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCurrentLabData();
  }

  Future<void> loadCurrentLabData() async {
    final labData = await FirebaseDatabase().getLabDetails(labId);

    setState(() {
      _nameController.text = labData!.name;
      _phoneController.text = labData.phone;
      _closingTimeController.text = labData.closingTime;
      _emailController.text = labData.email;
    });
  }

  Future<void> updateLabProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await FirebaseDatabase().updateLabData(
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      closingTime: _closingTimeController.text,
    );

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Profile updated successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    EditProfileTextField(
                      controller: _nameController,
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Enter lab name',
                      labelText: 'Name',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _emailController,
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'Enter lab email',
                      labelText: 'Email',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _phoneController,
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Enter lab phone',
                      labelText: 'Phone',
                    ),
                    const SizedBox(height: 12),

                    EditProfileTextField(
                      controller: _closingTimeController,
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                      hintText: 'Enter closing time like this "5:00 PM"',
                      labelText: 'Age',
                    ),

                    const SizedBox(height: 24),
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [Color(0xFF00B8DB), Color(0xFF00BBA7)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          updateLabProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
