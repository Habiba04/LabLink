import 'package:flutter/material.dart';
import 'package:lablink/Database/firebase_DB.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/SuperAdmin/Pages/add_lab.dart';
import 'package:lablink/SuperAdmin/Pages/Details_lab.dart';
import 'package:lablink/SuperAdmin/Pages/super-admin-home.dart';

class ManageLabs extends StatefulWidget {
  const ManageLabs({super.key});

  @override
  State<ManageLabs> createState() => _ManageLabsState();
}

class _ManageLabsState extends State<ManageLabs> {
  List<Lab> labs = [];
  bool _isLoading = true;
  String searchQuery = "";

  List<Lab> get _filteredLabs {
    if (searchQuery.isEmpty) {
      return labs;
    }

    final lowerCaseQuery = searchQuery.toLowerCase();

    return labs.where((lab) {
      return lab.name.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  Future<void> fetchLabs() async {
    try {
      setState(() => _isLoading = true);
      final data = await FirebaseDatabase().getAllLabs();
      print("Fetched data: $data");
      if (!mounted) return;
      setState(() {
        labs = data;
      });
      setState(() => _isLoading = false);
    } catch (e) {
      print("Error fetching labs : $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLabs();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final displayLabs = _filteredLabs;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F8),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 18),
            width: double.infinity,
            height: height * 0.13 + 20,

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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SuperAdminHomeScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Manage Laboratories",
                          style: TextStyle(
                            fontSize: width * 0.06,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Oversee all registered labs",
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
          SizedBox(height: width * 0.04),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() {
                searchQuery = value;
              }),
              decoration: InputDecoration(
                hintText: "Search labs by name...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
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
          ),
          SizedBox(height: width * 0.04),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLab()),
              );
            },
            child: Container(
              width: width * 0.93,
              height: height * 0.051,

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
                    " Add New Laboratory",
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: width * 0.04),
          Expanded(
            child: displayLabs.isEmpty && searchQuery.isNotEmpty
                ? Center(child: Text("No labs found matching '${searchQuery}'"))
                : ListView.builder(
                    itemCount: displayLabs.length,
                    itemBuilder: (context, index) {
                      final labItem = displayLabs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  labItem.name,
                                  style: TextStyle(
                                    color: Color(0xFF101828),
                                    fontSize: width * 0.05,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  labItem.email,
                                  style: TextStyle(
                                    color: Color(0xFF4A5565),
                                    fontSize: width * 0.04,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  labItem.phone,
                                  style: TextStyle(
                                    color: Color(0xFF4A5565),
                                    fontSize: width * 0.04,
                                  ),
                                ),
                                SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "${labItem.locations.length}",
                                            style: TextStyle(
                                              color: Color(0xFF9810FA),
                                              fontSize: width * 0.037,
                                            ),
                                          ),
                                          Text(
                                            "Locations",
                                            style: TextStyle(
                                              color: Color(0xFF6A7282),
                                              fontSize: width * 0.032,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "${labItem.testsCount}",
                                            style: TextStyle(
                                              color: Color(0xFF155DFC),
                                              fontSize: width * 0.037,
                                            ),
                                          ),
                                          Text(
                                            "Tests",
                                            style: TextStyle(
                                              color: Color(0xFF6A7282),
                                              fontSize: width * 0.032,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "${labItem.usersCount}",
                                            style: TextStyle(
                                              color: Color(0xFF009689),
                                              fontSize: width * 0.037,
                                            ),
                                          ),
                                          Text(
                                            "Users",
                                            style: TextStyle(
                                              color: Color(0xFF6A7282),
                                              fontSize: width * 0.032,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "★ ${labItem.rating}",
                                            style: TextStyle(
                                              color: Color(0xFFD08700),
                                              fontSize: width * 0.037,
                                            ),
                                          ),
                                          Text(
                                            "Rating",
                                            style: TextStyle(
                                              color: Color(0xFF6A7282),
                                              fontSize: width * 0.032,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    "Monthly Revenue",
                                    style: TextStyle(
                                      color: Color(0xFF6A7282),
                                      fontSize: width * 0.037,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${labItem.lastMonthRevenue}',
                                    style: TextStyle(
                                      color: Color(0xFF00A63E),
                                      fontSize: width * 0.04,
                                    ),
                                  ),
                                  trailing: IntrinsicWidth(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xFF9810FA),
                                              width: 1.0,
                                            ),

                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsScreen(
                                                        labId: labItem.id,
                                                        tests:
                                                            labItem.testsCount,
                                                        activeusers:
                                                            labItem.usersCount,
                                                        Monthlyrevenue: labItem
                                                            .lastMonthRevenue,
                                                        review: labItem.rating,
                                                      ),
                                                ),
                                              );
                                            },

                                            icon: Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Color(0xFF9810FA),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 1.0,
                                            ),

                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Confirm Delete",
                                                    ),
                                                    content: const Text(
                                                      "Are you sure you want to delete this item?",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await FirebaseDatabase()
                                                              .deleteLab(
                                                                labs[index].id,
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              content: Text(
                                                                "Laboratory deleted successfully",
                                                              ),
                                                            ),
                                                          );
                                                          fetchLabs();
                                                        },
                                                        child: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete_outlined,
                                              color: Color(0xFFE7000B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
