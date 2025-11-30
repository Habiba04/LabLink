import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lablink/Models/Review.dart';

class ReviewsServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addReview({
    required String labId,
    required Review review,
  }) async {
    try {
      await _firestore
          .collection('lab')
          .doc(labId)
          .collection('reviews')
          .add(review.toMap());
    } catch (e) {
      print('Error adding review: $e');
    }
  }

  Future<void> updateLabRating(String labId) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('lab')
          .doc(labId)
          .collection('reviews')
          .get();

      if (reviewsSnapshot.docs.isEmpty) {
        await _firestore.collection('lab').doc(labId).update({
          'labRating': 0.0,
        });
        return;
      }

      double total = 0.0;
      for (var doc in reviewsSnapshot.docs) {
        final data = doc.data();
        total += (data['rating'] ?? 0).toDouble();
      }
      final avgRating = total / reviewsSnapshot.docs.length;

      await _firestore.collection('lab').doc(labId).update({
        'labRating': double.parse(avgRating.toStringAsFixed(1)),
      });
    } catch (e) {
      print('❌ Error updating lab rating: $e');
    }
  }
}
