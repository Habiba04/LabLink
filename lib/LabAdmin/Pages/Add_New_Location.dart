import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Widgets/top_widget.dart';
import 'package:lablink/LabAdmin/services/location_services.dart'
    show LocationServices;
import 'package:lablink/Models/LabLocation.dart';

class AddNewLocation extends StatefulWidget {
  const AddNewLocation({super.key});

  @override
  State<AddNewLocation> createState() => _AddNewLocationState();
}

class _AddNewLocationState extends State<AddNewLocation> {
  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController workingDaysController = TextEditingController();
  final TextEditingController openAtController = TextEditingController();
  final TextEditingController closeAtController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    locationNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    workingDaysController.dispose();
    openAtController.dispose();
    closeAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? labid = 'sJAWUw2DnhZDibT5EeUqf2D5qXr2';

    bool _isSaving = false;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              top_screen(
                context: context,
                title: 'Add New Location',
                subtitle: 'Set up a new laboratory branch',
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(
                      Icons.location_city_outlined,
                      color: Color(0xFF364153),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Location Name',
                    style: TextStyle(
                      color: Color(0xFF364153),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: TextFormField(
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter location name'
                      : null,
                  controller: locationNameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFF00BBA7)),
                    ),
                    hintText: 'e.g., Main Branch, North Branch',
                    filled: true,
                    fillColor: const Color(0xFFD1D5DC),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF364153),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Address',
                    style: TextStyle(
                      color: Color(0xFF364153),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                  controller: addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter complete address',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFD1D5DC),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(Icons.call_outlined, color: Color(0xFF364153)),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Color(0xFF364153),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: TextFormField(
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter phone number'
                      : null,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFF00BBA7)),
                    ),
                    hintText: '+1 (555) 123-4567',
                    filled: true,
                    fillColor: const Color(0xFFD1D5DC),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(Icons.schedule, color: Color(0xFF364153)),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Working Days',
                    style: TextStyle(
                      color: Color(0xFF364153),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: TextFormField(
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter working days'
                      : null,
                  controller: workingDaysController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Sat-Thu, Mon-Fri',
                    filled: true,
                    fillColor: const Color(0xFFD1D5DC),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(Icons.access_time, color: Color(0xFF364153)),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Opening Hours',
                    style: TextStyle(
                      color: Color(0xFF364153),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter opening time'
                            : null,
                        controller: openAtController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: '08:00 AM',
                          filled: true,
                          fillColor: const Color(0xFFD1D5DC),
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 8, minute: 0),
                          );
                          if (picked != null) {
                            openAtController.text = picked.format(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter closing time'
                            : null,
                        controller: closeAtController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: '06:00 PM',
                          filled: true,
                          fillColor: const Color(0xFFD1D5DC),
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 18, minute: 0),
                          );
                          if (picked != null) {
                            closeAtController.text = picked.format(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_isSaving) return;
                      _isSaving = true;

                      if (formkey.currentState!.validate()) {
                        if (labid != null) {
                          await LocationServices().addLocation(
                            Lablocation(
                              name: locationNameController.text,
                              address: addressController.text,
                              phone: phoneController.text,
                              Workingdays: workingDaysController.text,
                              openinghours: openAtController.text,
                              closinghours: closeAtController.text,
                            ),
                            labid,
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Location Added Successfully!'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: User not logged in.'),
                            ),
                          );
                        }
                      }
                      _isSaving = false;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BBA7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Add Location',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
