import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lablink/Models/Review.dart';

class ReviewServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Review>> getLabReviews(String labId) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('lab')
          .doc(labId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      return reviewsSnapshot.docs
          .map((doc) => Review.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }
}
