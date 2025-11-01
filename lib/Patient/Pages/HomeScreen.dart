import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Patient/Pages/lab_details.dart';

// --- Lab Model ---
class Lab {
  final String name;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final String closingTime;
  final String imageUrl;

  Lab({
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.closingTime,
    required this.imageUrl,
  });
}

// --- Sample Data ---
final List<Lab> mockLabs = [
  Lab(
    name: "Central Diagnostics",
    rating: 4.8,
    reviewCount: 156,
    distanceKm: 0.8,
    closingTime: "8 PM",
    imageUrl: "images/labs.jpeg",
  ),
  Lab(
    name: "HealthFirst Labs",
    rating: 3.5,
    reviewCount: 203,
    distanceKm: 1.2,
    closingTime: "10 PM",
    imageUrl: "images/labs.jpeg",
  ),
  Lab(
    name: "MediLab Pro",
    rating: 4.7,
    reviewCount: 98,
    distanceKm: 2.1,
    closingTime: "7 PM",
    imageUrl: "images/labs.jpeg",
  ),
  Lab(
    name: "BioLab Center",
    rating: 2.5,
    reviewCount: 150,
    distanceKm: 3.4,
    closingTime: "9 PM",
    imageUrl: "images/labs.jpeg",
  ),
  Lab(
    name: "Care Diagnostics",
    rating: 4.6,
    reviewCount: 130,
    distanceKm: 2.8,
    closingTime: "8:30 PM",
    imageUrl: "images/labs.jpeg",
  ),
  Lab(
    name: "Smart Lab",
    rating: 4.9,
    reviewCount: 210,
    distanceKm: 1.5,
    closingTime: "10 PM",
    imageUrl: "images/labs.jpeg",
  ),
  Lab(
    name: "UltraLab Plus",
    rating: 4.8,
    reviewCount: 175,
    distanceKm: 2.0,
    closingTime: "9:30 PM",
    imageUrl: "images/labs.jpeg",
  ),
];

// --- Home Screen ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showAllLabs = false;
  String searchQuery = "";
  double? minRatingFilter; // <-- New rating filter
  final patientName = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController searchController = TextEditingController();

  List<Lab> get displayedLabs {
    List<Lab> filtered = mockLabs
        .where(
          (lab) =>
              (lab.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  lab.rating.toString().contains(searchQuery)) &&
              (minRatingFilter == null || lab.rating >= minRatingFilter!),
        )
        .toList();

    return showAllLabs ? filtered : filtered.take(6).toList();
  }

  void _openFilterDialog() {
    double tempRating = minRatingFilter ?? 0.0;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Filter by Rating"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Show labs with rating at least:"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildListHeader(),
                    const SizedBox(height: 10),
                    ...displayedLabs.map((lab) => LabCard(lab: lab)).toList(),
                    if (displayedLabs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            "No labs found.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
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
    );
  }

  // --- Header with search ---
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final patientName = FirebaseAuth.instance.currentUser!.uid;

    String initials() {
      final parts = patientName.trim().split(' ');
      if (parts.isEmpty) return "";
      if (parts.length == 1) return parts[0][0].toUpperCase();
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 30,
        left: 35,
        right: 35,
        bottom: 35,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00BBA7), Color(0xFF00B4DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Good Morning",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      patientName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Text(
                  initials(),
                  style: const TextStyle(
                    color: Color(0xFF00BBA7),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: "Search labs or tests",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list, color: Color(0xFF00BBA7)),
                  onPressed: _openFilterDialog,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- "Available Labs" Header ---
  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Available Labs",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => showAllLabs = !showAllLabs);
            },
            child: Text(
              showAllLabs ? "Show Less" : "See All",
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF00BBA7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Lab Card ---
class LabCard extends StatelessWidget {
  final Lab lab;
  const LabCard({super.key, required this.lab});

  void _navigateToLabDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LabDetails(labId: "lab1")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              lab.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lab.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      "${lab.rating} (${lab.reviewCount})",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.location_on,
                      color: Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${lab.distanceKm} km",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.schedule, color: Colors.black54, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      lab.closingTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _navigateToLabDetails(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00B4DB), Color(0xFF00BBA7)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: const Text(
                          "Book now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
