import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Pages/Add_New_Test.dart';
import 'package:lablink/LabAdmin/Widgets/top_widget.dart';
import 'package:lablink/LabAdmin/services/Tests_services.dart';
import 'package:lablink/Models/LabTests.dart';

class ManageTests extends StatefulWidget {
  final String labid;
  final String locationid;
  const ManageTests({super.key, required this.labid, required this.locationid});

  @override
  State<ManageTests> createState() => _ManageTestsState();
}

class _ManageTestsState extends State<ManageTests> {
  double? minRatingFilter;
  String? searchQuery = '';
  final Testservice = TestsServices();
  TextEditingController searchController = TextEditingController();

  void showEditDialog(LabTest test) {
    TextEditingController nameCtrl = TextEditingController(text: test.name);
    TextEditingController descCtrl = TextEditingController(
      text: test.description,
    );
    TextEditingController priceCtrl = TextEditingController(
      text: test.price.toString(),
    );
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Test data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: 'Test Name'),
            ),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceCtrl,
              decoration: InputDecoration(labelText: 'price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'),
          ),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () {
              test.name = nameCtrl.text;
              test.description = descCtrl.text;
              test.price = double.tryParse(priceCtrl.text) ?? test.price;
              Testservice.updatetest(
                test,
                widget.labid,
                widget.locationid,
                test.id,
              );
              Navigator.pop(context);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  void _openFilterDialog() {
    double tempRating = minRatingFilter ?? 0.0;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Filter "),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Show labs depend on text"),
            const SizedBox(height: 10),
            StatefulBuilder(
              builder: (context, setInnerState) {
                return Column(
                  children: [
                    Slider(
                      value: tempRating,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      label: tempRating.toStringAsFixed(1),
                      activeColor: const Color(0xFF00BBA7),
                      onChanged: (value) {
                        setInnerState(() => tempRating = value);
                      },
                    ),
                    Text(
                      "${tempRating.toStringAsFixed(1)} ★",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => minRatingFilter = null);
            },
            child: const Text("Clear"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => minRatingFilter = tempRating);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BBA7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(LabTest test) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Test  '),
        content: Text('Are you sure you want to delete this test?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            child: Text('Delete'),
            onPressed: () {
              Testservice.delettest(widget.labid, widget.locationid, test.id);
              Navigator.pop(context);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            top_screen(
              context: context,
              title: 'Manage Tests',
              subtitle: 'Add and manage tests',
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 60,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search Tests",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        color: Color(0xFF00BBA7),
                      ),
                      onPressed: _openFilterDialog,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.black45, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.only(top: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contex) {
                      return AddNewTest(
                        locationId: widget.locationid,
                        labid: widget.labid,
                      );
                    },
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF009689),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    Text('Add New Test', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 5),

            StreamBuilder(
              stream: Testservice.getTests(widget.labid, widget.locationid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final tests = snapshot.data ?? [];

                final filteredTests = tests
                    .where(
                      (t) => t.name.toLowerCase().contains(
                        searchQuery!.toLowerCase(),
                      ),
                    )
                    .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: filteredTests.length,
                  itemBuilder: (context, index) {
                    final test = filteredTests[index];
                    return Card(
                      elevation: 3,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              test.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                test.category,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              test.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$ ${test.price}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.access_time, size: 18),
                                    const SizedBox(width: 4),
                                    Text('${test.durationMinutes} min'),
                                    IconButton(
                                      onPressed: () {
                                        showEditDialog(test);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDeleteDialog(test);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
