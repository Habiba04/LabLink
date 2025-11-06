import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/Patient/Widgets/edit_profile_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    final patient = await FirebaseDatabase().getCurrentUserData();

    setState(() {
      _nameController.text = patient!.name;
      _phoneController.text = patient.phone;
      _addressController.text = patient.address;
      _ageController.text = patient.age;
      _emailController.text = patient.email;
    });
  }

  Future<void> _updateUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await FirebaseDatabase().updateUserData(
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      email: _emailController.text,
      age: _ageController.text,
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
                      hintText: 'Enter your name',
                      labelText: 'Name',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _emailController,
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'Enter your email',
                      labelText: 'Email',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _ageController,
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                      hintText: 'Enter your age',
                      labelText: 'Age',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _phoneController,
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Enter your phone',
                      labelText: 'Phone',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _addressController,
                      prefixIcon: Icon(Icons.home),
                      hintText: 'Enter your address',
                      labelText: 'Address',
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
                          _updateUserProfile();
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
