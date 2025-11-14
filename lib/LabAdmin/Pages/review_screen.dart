import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/Models/Review.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final labId = FirebaseAuth.instance.currentUser!.uid;
  Lab? labData;
  List<Review> reviews = [];
  bool _isLoading = true;
  final double _rating = 0.0;
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final lab_data = await FirebaseDatabase().getLabDetails(labId);
    final reviews_ = await FirebaseDatabase().getLabReviews(labId);
    setState(() {
      labData = lab_data;
      reviews = reviews_;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text('Reviews & Ratings'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: width * 0.86,
                  height: height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Color(0xFF00BBA7), Color(0xFF00B8DB)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        labData!.rating.toString(),
                        style: TextStyle(
                          fontSize: width * 0.12,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < labData!.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Color(0xFFFDC700),
                            size: width * 0.07,
                          ),
                        ),
                      ),
                      Text(
                        "Based on ${reviews.length} Reviews",
                        style: TextStyle(
                          fontSize: width * 0.043,
                          color: Color(0xFFCBFBF1),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: reviews.isEmpty
                      ? const Center(child: Text('No reviews yet.'))
                      : ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            review.userName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.048,
                                              color: Color(0xFF101828),
                                            ),
                                          ),

                                          Text(
                                            review.createdAt.toString(),
                                            style: TextStyle(
                                              color: Color(0xFF6A7282),
                                              fontSize: width * 0.04,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (i) => Icon(
                                            i < review.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Color(0xFFFDC700),
                                            size: width * 0.05,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: width * 0.02),
                                      Text(
                                        review.comment,
                                        style: TextStyle(
                                          fontSize: width * 0.043,
                                          color: Color(0xFF364153),
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
