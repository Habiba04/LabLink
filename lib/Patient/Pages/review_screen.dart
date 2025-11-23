import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Database/firebaseDB.dart';
import 'package:lablink/Models/Review.dart';

class ReviewScreen extends StatefulWidget {
  final String labId;
  const ReviewScreen({super.key, required this.labId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Review> reviews = [];
  bool _isLoading = true;
  double _rating = 0.0;
  Future<void> fetchReviews() async {
    setState(() {
      _isLoading = true;
    });
    final reviewsData = await FirebaseDatabase().getLabReviews(widget.labId);
    setState(() {
      reviews = reviewsData;
      print('review data: $reviewsData');
      _isLoading = false;
    });
  }

  Future<void> addReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must be logged in to submit a review"),
        ),
      );
      return;
    }

    final userName = user.email!.split('@')[0];
    if (_controller.text.isEmpty || _rating == 0) return;

    final newReview = Review(
      userName: userName,
      comments: _controller.text,
      rating: _rating,
      createdAt: DateTime.now(),
    );

    await FirebaseDatabase().addReview(labId: widget.labId, review: newReview);
    _controller.clear();
    setState(() {
      _rating = 0;
    });
    await fetchReviews(); // refresh list
  }

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text('Lab Reviews'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
                                      Text(
                                        review.userName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.048,
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (i) => Icon(
                                            i < review.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: width * 0.05,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: width * 0.02),
                                      Text(
                                        review.comments,
                                        style: TextStyle(
                                          fontSize: width * 0.043,
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
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = (index + 1).toDouble();
                              });
                            },
                          ),
                        ),
                      ),
                      TextField(
                        controller: _controller,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          hintText: 'Write your review...',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF00B8DB),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF00B8DB),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [Color(0xFF00B8DB), Color(0xFF00BBA7)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              addReview();
                              await FirebaseDatabase().updateLabRating(
                                widget.labId,
                              );
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
