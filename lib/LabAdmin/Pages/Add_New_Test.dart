import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Widgets/label.dart';
import 'package:lablink/LabAdmin/Widgets/top_widget.dart';
import 'package:lablink/LabAdmin/services/Tests_services.dart';
import 'package:lablink/Models/LabTests.dart';

// ignore: must_be_immutable
class AddNewTest extends StatefulWidget {
  String locationId;
  String labid;
  AddNewTest({super.key, required this.locationId, required this.labid});

  @override
  State<AddNewTest> createState() => _AddNewTestState();
}

class _AddNewTestState extends State<AddNewTest> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController testNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sampleTypeController = TextEditingController();
  final TextEditingController preparationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              top_screen(
                context: context,
                title: 'Add New Test',
                subtitle: 'Create a new test for your ',
              ),

              const SizedBox(height: 24),

              buildLabel('Test Name', const Icon(Icons.description_outlined)),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter test name'
                      : null,
                  controller: testNameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF00BBA7)),
                    ),
                    hintText: 'e.g., Complete Blood Count',
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              buildLabel('Category', const Icon(Icons.local_offer_outlined)),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: DropdownButtonFormField<String>(
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a category'
                        : null,
                    value: categoryController.text.isEmpty
                        ? null
                        : categoryController.text,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      border: InputBorder.none,
                      hintText: 'Select Category',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Hematology',
                        child: Text('Hematology'),
                      ),
                      DropdownMenuItem(
                        value: 'Biochemistry',
                        child: Text('Biochemistry'),
                      ),
                      DropdownMenuItem(
                        value: 'Microbiology',
                        child: Text('Microbiology'),
                      ),
                      DropdownMenuItem(
                        value: 'Immunology',
                        child: Text('Immunology'),
                      ),
                      DropdownMenuItem(
                        value: 'Urinalysis',
                        child: Text('Urinalysis'),
                      ),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      categoryController.text = value!;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildLabel(
                            'Price',
                            const Icon(Icons.attach_money_outlined),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter test price'
                                : null,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFF00BBA7),
                                ),
                              ),
                              hintText: 'e.g., 300',
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildLabel(
                            'Duration',
                            const Icon(Icons.access_time_outlined),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter duration'
                                : null,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFF00BBA7),
                                ),
                              ),
                              hintText: '30-60 minutes',
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Sample Type',
                  style: const TextStyle(
                    color: Color(0xFF364153),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: DropdownButtonFormField<String>(
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select sample type'
                        : null,
                    value: sampleTypeController.text.isEmpty
                        ? null
                        : sampleTypeController.text,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      border: InputBorder.none,
                      hintText: 'Select sample type',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Blood', child: Text('Blood')),
                      DropdownMenuItem(value: 'Urine', child: Text('Urine')),
                      DropdownMenuItem(value: 'Saliva', child: Text('Saliva')),
                      DropdownMenuItem(value: 'Swab', child: Text('Swab')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      sampleTypeController.text = value!;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Description',
                  style: const TextStyle(
                    color: Color(0xFF364153),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter test description'
                      : null,
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF00BBA7)),
                    ),
                    hintText: 'Provide a brief description of the test',
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Preparation Instructions (Optional)',
                    style: const TextStyle(
                      color: Color(0xFF364153),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: preparationController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF00BBA7)),
                    ),
                    hintText: 'e.g., Fast for 8 hours before the test',
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BBA7), Color(0xFF155DFC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  onPressed: () async {
                    print('lab ID issssssssssss: ${widget.labid}');
                    print('Location ID issssssssssss: ${widget.locationId}');
                    if (formKey.currentState!.validate()) {
                      await TestsServices().addNewTest(
                        LabTest(
                          id: '',
                          name: testNameController.text,
                          category: categoryController.text,
                          price: double.parse(priceController.text),
                          durationMinutes: durationController.text,
                          sampleType: sampleTypeController.text,
                          description: descriptionController.text,
                          preparation: preparationController.text,
                        ),
                        widget.labid,
                        widget.locationId,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Test added successfully!'),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add Test',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
