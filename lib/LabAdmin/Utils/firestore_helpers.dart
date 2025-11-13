import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lablink/Models/DashboardData.dart';
import 'package:lablink/Models/SimpleOrder.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreHelpers {
  static Stream<DashboardData> dashboardStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value(DashboardData.empty());

    final appointmentsRef = FirebaseFirestore.instance.collection('lab').doc(uid).collection('appointments');
    final reviewsRef = FirebaseFirestore.instance.collection('lab').doc(uid).collection('reviews');
    final patientsRef = FirebaseFirestore.instance.collection('patient');

    return Rx.combineLatest3(
      appointmentsRef.snapshots(),
      reviewsRef.snapshots(),
      patientsRef.snapshots(),
      (QuerySnapshot appointmentsSnap, QuerySnapshot reviewsSnap, QuerySnapshot patientsSnap) {
        return _mapToDashboardData(appointmentsSnap, reviewsSnap, patientsSnap);
      },
    );
  }

  static DashboardData _mapToDashboardData(
      QuerySnapshot appointmentsSnap, QuerySnapshot reviewsSnap, QuerySnapshot patientsSnap) {
    final now = DateTime.now();
    int pending = 0, completed = 0, todaysBookings = 0;
    double earningsThisMonth = 0;
    List<SimpleOrder> recent = [];

    final patientNames = {for (var p in patientsSnap.docs) p.id: (p.data() as Map<String, dynamic>?)?['name'] ?? 'Unknown'};

    for (var doc in appointmentsSnap.docs) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final status = (data['status'] ?? '').toString();
      final patientId = (data['patientId'] ?? '').toString();
      final patientName = patientNames[patientId] ?? 'Unknown';

      DateTime? created;
      if (data['createdAt'] is Timestamp) created = (data['createdAt'] as Timestamp).toDate();
      if (data['createdAt'] is DateTime) created = data['createdAt'] as DateTime;

      if (status.toLowerCase() == 'pending') pending++;
      if (status.toLowerCase() == 'completed') completed++;

      if (created != null && created.year == now.year && created.month == now.month && created.day == now.day)
        todaysBookings++;

      if (created != null && created.year == now.year && created.month == now.month)
        earningsThisMonth += _toDoubleSafe(data['totalAmount']);

      final testsList = <String>[];
      if (data['tests'] is List) {
        for (var t in (data['tests'] as List)) {
          if (t is Map && t['name'] != null) testsList.add(t['name'].toString());
          if (t is String) testsList.add(t);
        }
      }

      recent.add(SimpleOrder(id: doc.id, patientName: patientName, createdAt: created, status: status, testsList: testsList));
    }

    recent.sort((a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));

    final lastThree = recent.take(3).toList();

    double avgRating = 0;
    if (reviewsSnap.docs.isNotEmpty) {
      double sum = 0;
      int count = 0;
      for (var r in reviewsSnap.docs) {
        final rd = r.data() as Map<String, dynamic>? ?? {};
        final val = _toDoubleSafe(rd['rating']);
        if (val > 0) {
          sum += val;
          count++;
        }
      }
      avgRating = count > 0 ? sum / count : 0;
    }

    return DashboardData(
      pendingRequests: pending,
      completedTests: completed,
      avgRating: avgRating,
      earningsThisMonth: earningsThisMonth,
      todaysBookings: todaysBookings,
      activePatients: patientsSnap.size,
      recentOrders: lastThree,
    );
  }

  static double _toDoubleSafe(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }
}

class LabInfo {
  final String name;
  final String initials;
  LabInfo(this.name, this.initials);
}

Future<LabInfo> fetchLabInfo() async {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return LabInfo('Lab Name', 'LD');

    final doc = await FirebaseFirestore.instance.collection('lab').doc(uid).get();
    final name = (doc.data()?['name'] ?? 'Lab Name').toString();
    final initials = name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase();
    return LabInfo(name, initials);
  } catch (e) {
    return LabInfo('Lab Name', 'LD');
  }
}

