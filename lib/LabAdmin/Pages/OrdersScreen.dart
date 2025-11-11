import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Pages/OrderDetailsScreen.dart';
import 'package:lablink/LabAdmin/Widgets/FilterBar.dart';
import 'package:lablink/LabAdmin/Widgets/OrderCard.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String filter = "Manual Booking"; // Manual Booking / Prescriptions
  String searchQuery = "";

  Stream<List<Map<String, dynamic>>> _getPendingOrders() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    final appointmentsRef = FirebaseFirestore.instance
        .collection('lab')
        .doc(uid)
        .collection('appointments');

    return appointmentsRef.snapshots().asyncMap((snapshot) async {
      List<Map<String, dynamic>> results = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // Only Pending appointments
        if ((data['status'] ?? '').toLowerCase() != 'pending') continue;

        // Patient info
        Map<String, dynamic>? patientData;
        final patientId = data['patientId'];
        if (patientId != null && patientId.toString().isNotEmpty) {
          final patientSnap = await FirebaseFirestore.instance
              .collection('patient')
              .doc(patientId)
              .get();
          if (patientSnap.exists) patientData = patientSnap.data();
        }

        // Map appointment/order for UI
        final order = {
          'id': doc.id,
          'name': patientData?['name'] ?? 'Unknown Patient',
          'age': patientData?['age'] ?? '',
          'date': data['date'] ?? '',
          'time': data['time'] ?? '',
          'collection': data['serviceType'] == 'Home Collection'
              ? 'Home Collection'
              : 'Visit Lab',
          'status': data['status'] ?? 'Pending',
          'type': data['serviceType'] == 'Manual Booking'
              ? 'Manual Booking'
              : 'Prescriptions',
          'manual': data['serviceType'] == 'Manual Booking',
          'tests': (data['tests'] != null && data['tests'].isNotEmpty)
              ? List<Map<String, dynamic>>.from(
                  data['tests'].map(
                    (t) => {
                      'name': t['name'],
                      'prescription': t['prescriptionUrl'] ?? null,
                    },
                  ),
                )
              : [],
        };

        results.add(order);
      }

      return results;
    });
  }

  // Accept function
  Future<void> acceptOrder(Map<String, dynamic> order) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('lab')
        .doc(uid)
        .collection('appointments')
        .doc(order['id'])
        .update({'status': 'Upcoming'});
  }

  // Reject function
  Future<void> rejectOrder(Map<String, dynamic> order) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('lab')
        .doc(uid)
        .collection('appointments')
        .doc(order['id'])
        .update({'status': 'Cancelled'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 50,
                      left: 20,
                      right: 20,
                      bottom: 30,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              "Orders",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Search bar
                        TextField(
                          onChanged: (value) => setState(() {
                            searchQuery = value;
                          }),
                          decoration: InputDecoration(
                            hintText: "Search by patient name...",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filter bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FilterBar(
                      items: const ["Prescriptions", "Manual Booking"],
                      selected: filter,
                      onSelected: (v) => setState(() => filter = v),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },

        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _getPendingOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No ${filter.toLowerCase()} orders found.",
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              );
            }

            var filtered = snapshot.data!
                .where((x) => x['type'] == filter)
                .where(
                  (x) => x['name'].toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
                )
                .toList();

            if (filtered.isEmpty) {
              return Center(
                child: Text(
                  "No ${filter.toLowerCase()} orders found.",
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (_, i) => OrderCard(
                order: filtered[i],
                onAccept: filtered[i]['manual']
                    ? null
                    : () => acceptOrder(filtered[i]),
                onReject: filtered[i]['manual']
                    ? null
                    : () => rejectOrder(filtered[i]),
                onViewDetails: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(order: filtered[i]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
