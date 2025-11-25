import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Models/Appointment.dart';
import 'package:lablink/Models/Lab.dart';
import 'package:lablink/Models/LabLocation.dart';
import 'package:lablink/Models/LabTests.dart';
import 'package:lablink/Models/Patient.dart';
import 'package:lablink/Models/Review.dart';

class FirebaseDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Lab>> getAllLabs() async {
    try {
      final labsSnapshot = await _firestore.collection('lab').get();
      List<Lab> labs = [];

      for (var labDoc in labsSnapshot.docs) {
        final labData = labDoc.data();

        final appointmentsSnapshot = await FirebaseFirestore.instance
            .collection('lab')
            .doc(labDoc.id)
            .collection('appointments')
            .orderBy('date', descending: false)
            .get();

        double totalRevenue = 0;

        for (var appointment in appointmentsSnapshot.docs) {
          totalRevenue += (appointment['totalAmount'] ?? 0).toDouble();
        }

        final usersCount = await getUniqueUsersCount(labDoc.id);
        // Get locations
        final locationsSnapshot = await _firestore
            .collection('lab')
            .doc(labDoc.id)
            .collection('locations')
            .get();

        List<LabLocation> locations = [];
        int testsNum = 0;
        for (var locationDoc in locationsSnapshot.docs) {
          final locData = locationDoc.data();

          // Get tests for this location
          final testsSnapshot = await _firestore
              .collection('lab')
              .doc(labDoc.id)
              .collection('locations')
              .doc(locationDoc.id)
              .collection('tests')
              .get();

          final tests = testsSnapshot.docs.map((t) {
            return LabTest.fromMap(t.data());
          }).toList();
          testsNum += tests.length;

          locations.add(
            LabLocation.fromMap(locationDoc.id, locData, tests: tests),
          );
        }

        labs.add(
          Lab.fromMap(
            labData,
            id: labDoc.id,
            locations: locations,
            testsCount: testsNum,
            usersCount: usersCount ?? 0,
            lastMonthRevenue: totalRevenue,
          ),
        );
      }

      return labs;
    } catch (e) {
      print("❌ Error fetching labs: $e");
      return [];
    }
  }

  Future<void> deleteLab(String labId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final appointments = await firestore
          .collection('lab')
          .doc(labId)
          .collection('appointments')
          .get();

      for (var doc in appointments.docs) {
        await doc.reference.delete();
      }

      final reviews = await firestore
          .collection('lab')
          .doc(labId)
          .collection('reviews')
          .get();

      for (var doc in reviews.docs) {
        await doc.reference.delete();
      }

      final locations = await firestore
          .collection('lab')
          .doc(labId)
          .collection('locations')
          .get();

      for (var loc in locations.docs) {
        final tests = await loc.reference.collection('tests').get();
        for (var t in tests.docs) {
          await t.reference.delete();
        }

        await loc.reference.delete();
      }

      await firestore.collection('lab').doc(labId).delete();

      print("✅ Lab deleted successfully");
    } catch (e) {
      print("❌ Error deleting lab: $e");
    }
  }

  Future<Lab?> getLabDetails(String labId) async {
    try {
      final labDoc = await _firestore.collection('lab').doc(labId).get();
      if (!labDoc.exists) return null;

      final labData = labDoc.data()!;

      final locationsSnapshot = await _firestore
          .collection('lab')
          .doc(labId)
          .collection('locations')
          .get();

      final locations = <LabLocation>[];

      for (var locationDoc in locationsSnapshot.docs) {
        final locData = locationDoc.data();

        final testsSnapshot = await _firestore
            .collection('lab')
            .doc(labId)
            .collection('locations')
            .doc(locationDoc.id)
            .collection('tests')
            .get();

        final tests = testsSnapshot.docs.map((t) {
          return LabTest.fromMap(t.data());
        }).toList();

        locations.add(
          LabLocation.fromMap(locationDoc.id, locData, tests: tests),
        );
      }

      return Lab.fromMap(labData, id: labDoc.id, locations: locations);
    } catch (e) {
      print(' Error fetching lab details: $e');
      return null;
    }

    print("Fetching details for ID: $labId");
  }

  Future<void> updateLabData({
    required String name,
    required String phone,
    required String closingTime,
    required String email,
  }) async {
    try {
      final lab = FirebaseAuth.instance.currentUser;
      if (lab == null) {
        print("❌ No lab logged in");
        return;
      }

      await _firestore.collection('lab').doc(lab.uid).update({
        'name': name.trim(),
        'phone': phone.trim(),
        'closingTime': closingTime.trim(),
        'email': email.trim(),
      });

      print("✅ Lab data updated successfully");
    } catch (e) {
      print("❌ Error updating lab data: $e");
    }
  }

  Future<void> addNewLab(Lab lab, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: lab.email, password: password);

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("lab").doc(uid).set({
        ...lab.toMap(),
        "uid": uid,
      });

      print("Lab created + Auth account created successfully!");
    } catch (e) {
      print("Error adding lab: $e");
    }
  }

  Future<int> getUniqueUsersCount(String labId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('lab')
          .doc(labId)
          .collection('appointments')
          .get();

      // Set to store unique patient IDs
      final Set<String> uniquePatients = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final patientId = data['patientId'];
        if (patientId != null) {
          uniquePatients.add(patientId);
        }
      }

      return uniquePatients.length;
    } catch (e) {
      print("Error getting unique users: $e");
      return 0;
    }
  }

  Future<Map<String, dynamic>> getMonthlyLabAnalytics(String labId) async {
    try {
      final snapshot = await _firestore
          .collection('lab')
          .doc(labId)
          .collection('appointments')
          .where('status', isEqualTo: 'Completed')
          .get();

      Map<String, Map<String, dynamic>> monthlyData = {};
      double labVisitsRevenue = 0;
      double homeVisitsRevenue = 0;

      for (var doc in snapshot.docs) {
        final appointment = Appointment.fromFirestore(doc);
        if (appointment.serviceType == "Visit Lab") {
          labVisitsRevenue += appointment.totalAmount;
        } else if (appointment.serviceType == "Home Collection") {
          homeVisitsRevenue += appointment.totalAmount;
        }

        final monthKey = DateFormat('MMM yyyy').format(appointment.date);

        monthlyData.putIfAbsent(monthKey, () {
          print("month is not found");
          return {'patients': <String>{}, 'tests': 0, 'revenue': 0.0};
        });

        monthlyData[monthKey]!['patients'].add(appointment.patientId);
        monthlyData[monthKey]!['tests'] += appointment.tests?.length ?? 0;
        monthlyData[monthKey]!['revenue'] += appointment.totalAmount ?? 0.0;
      }

      Map<String, dynamic> monthlyResults = {};
      monthlyData.forEach((month, data) {
        monthlyResults[month] = {
          'patients': (data['patients'] as Set).length,
          'tests': data['tests'],
          'revenue': data['revenue'],
        };
      });

      return {
        'monthlyData': monthlyResults,
        'labVisitsRevenue': labVisitsRevenue,
        'homeVisitsRevenue': homeVisitsRevenue,
      };
    } catch (e) {
      print('❌ Error fetching monthly analytics: $e');
      return {};
    }
  }

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

  Future<Patient?> getCurrentUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('patient')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final patient = Patient.fromDocumentSnapshot(doc);

        return patient;
      } else {
        print("User data not found");
        return null;
      }
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  Future<void> updateUserData({
    required String name,
    required String phone,
    required String address,
    required String email,
    required String age,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ No user logged in");
        return;
      }

      await _firestore.collection('patient').doc(user.uid).update({
        'name': name.trim(),
        'phone': phone.trim(),
        'address': address.trim(),
        'email': email.trim(),
        'age': age.trim(),
      });

      print("✅ User data updated successfully");
    } catch (e) {
      print("❌ Error updating user data: $e");
    }
  }
}
