import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Pages/order_details_screen.dart';
import 'package:lablink/LabAdmin/Widgets/Filter_Bar.dart';
import 'package:lablink/LabAdmin/Widgets/Order_Card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String filter = "Pending";
  String searchQuery = "";

  Stream<List<Map<String, dynamic>>> _getOrders() {
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
        final status = (data['status'] ?? '').toString().toLowerCase();

        if (status != 'pending' && status != 'awaiting results') continue;

        Map<String, dynamic>? patientData;
        final patientId = data['patientId'];
        if (patientId != null && patientId.toString().isNotEmpty) {
          final patientSnap = await FirebaseFirestore.instance
              .collection('patient')
              .doc(patientId)
              .get();
          if (patientSnap.exists) patientData = patientSnap.data();
        }

        final order = {
          'id': doc.id,
          'patientId': patientId ?? '',
          'name': patientData?['name'] ?? 'Unknown Patient',
          'age': patientData?['age'] ?? '',
          'address': patientData?['address'] ?? '',
          'phone': patientData?['phone'] ?? '',
          'date': data['date'] ?? '',
          'time': data['time'] ?? '',
          'prescription': data['prescription'],
          'totalAmount': data['totalAmount'],
          'collection': data['serviceType'] == 'Home Collection'
              ? 'Home Collection'
              : 'Visit Lab',
          'status': data['status'] ?? 'Pending',
          'prescription': data['prescription'] ?? "",
          'tests': (data['tests'] != null && data['tests'].isNotEmpty)
              ? List<Map<String, dynamic>>.from(
                  data['tests'].map((t) => {'name': t['name'] ?? ''}),
                )
              : [],
        };

        results.add(order);
      }

      return results;
    });
  }

  Future<void> acceptOrder(Map<String, dynamic> order) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('lab')
        .doc(uid)
        .collection('appointments')
        .doc(order['id'])
        .update({'status': 'Upcoming'});

    await FirebaseFirestore.instance
        .collection('patient')
        .doc(order['patientId'])
        .collection('appointments')
        .doc(order['id'])
        .update({'status': 'Upcoming'});
  }

  Future<void> rejectOrder(Map<String, dynamic> order) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('lab')
        .doc(uid)
        .collection('appointments')
        .doc(order['id'])
        .update({'status': 'Cancelled'});

    await FirebaseFirestore.instance
        .collection('patient')
        .doc(order['patientId'])
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FilterBar(
                      items: const ["Pending", "Awaiting Results"],
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
          stream: _getOrders(),
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
                .where(
                  (x) =>
                      (x['status'] ?? '').toString().toLowerCase() ==
                      filter.toLowerCase(),
                )
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
              itemBuilder: (_, i) {
                final order = filtered[i];
                final isAwaiting =
                    order['status'].toString().toLowerCase() ==
                    'awaiting results';
                return OrderCard(
                  order: order,
                  onViewDetails: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                  onAccept: isAwaiting ? null : () => acceptOrder(order),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
