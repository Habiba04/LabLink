import 'package:flutter/material.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/SuperAdmin/Pages/add_lab.dart';

class ManageLabs extends StatefulWidget {
  const ManageLabs({super.key});

  @override
  State<ManageLabs> createState() => _ManageLabsState();
}

class _ManageLabsState extends State<ManageLabs> {
  List<Lab> labs = [];
  bool _isLoading = true;
  String searchQuery = "";
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
    return Scaffold(
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
                width: width * 0.8,
                height: height * 0.05,
                // padding: const EdgeInsets.all(20),
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
                        fontSize: width * 0.03,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: width * 0.04),
            Expanded(
              child: ListView.builder(
                itemCount: labs.length,
                itemBuilder: (context, index) {
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
                              labs[index].name,
                              style: TextStyle(
                                color: Color(0xFF101828),
                                fontSize: width * 0.04,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              labs[index].email,
                              style: TextStyle(
                                color: Color(0xFF4A5565),
                                fontSize: width * 0.03,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              labs[index].phone,
                              style: TextStyle(
                                color: Color(0xFF4A5565),
                                fontSize: width * 0.03,
                              ),
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "${labs[index].locations.length}",
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
                                      "${labs[index].testsCount}",
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
                                      "${labs[index].usersCount}",
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
                                      "★ ${labs[index].rating}",
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
                            Divider(),
                            ListTile(
                              title: Text(
                                "Monthly Revenue",
                                style: TextStyle(
                                  color: Color(0xFF6A7282),
                                  fontSize: width * 0.037,
                                ),
                              ),
                              subtitle: Text(
                                '${labs[index].lastMonthRevenue}',
                                style: TextStyle(
                                  color: Color(0xFF00A63E),
                                  fontSize: width * 0.04,
                                ),
                              ),
                              trailing: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        /*
                                         Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OverView(),
                                          ),
                                        );
                                        */
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Color(0xFF9810FA),
                                      ),
                                    ),
                                    IconButton(
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
                                                    ); // cancel
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await FirebaseDatabase()
                                                        .deleteLab(
                                                          labs[index].id,
                                                        );
                                                    Navigator.pop(
                                                      context,
                                                    ); // close dialog
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
                                                    fetchLabs(); // لتحديث الليست بعد الحذف
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
      ),
    );
  }
}
