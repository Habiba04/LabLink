import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/Patient/Services/patient_services.dart';
import 'package:lablink/shared_files/common_widgets/edit_profile_text_field.dart';

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
  final TextEditingController _ssnController = TextEditingController();
  String? _selectedGender;
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    final patient = await PatientServices().getCurrentUserData();

    setState(() {
      _nameController.text = patient!.name;
      _phoneController.text = patient.phone;
      _addressController.text = patient.address;
      _ageController.text = patient.age;
      _emailController.text = patient.email;
      _ssnController.text = patient.ssn;
      _selectedGender = patient.gender;
    });
  }

  Future<void> _updateUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGender == null || _selectedGender!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a gender.')));
      return;
    }

    setState(() => _isLoading = true);

    await PatientServices().updateUserData(
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      email: _emailController.text,
      age: _ageController.text,
      ssn: _ssnController.text,
      gender: _selectedGender,
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
                    const SizedBox(height: 20),
                    EditProfileTextField(
                      controller: _nameController,
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      hintText: 'Enter your name',
                      labelText: 'Name',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _emailController,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter your email',
                      labelText: 'Email',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _ageController,
                      prefixIcon: Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter your age',
                      labelText: 'Age',
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedGender == ''
                          ? null
                          : _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: const Icon(Icons.wc, color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      hint: const Text('Select your gender'),
                      items: _genderOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select your gender'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _phoneController,
                      prefixIcon: Icon(Icons.phone, color: Colors.grey),
                      hintText: 'Enter your phone',
                      labelText: 'Phone',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _addressController,
                      prefixIcon: Icon(Icons.home, color: Colors.grey),
                      hintText: 'Enter your address',
                      labelText: 'Address',
                    ),
                    const SizedBox(height: 12),
                    EditProfileTextField(
                      controller: _ssnController,
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                      hintText: 'Enter your Social Security Number',
                      labelText: 'SSN',
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
