import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Widgets/appointmentCard.dart';
import 'package:lablink/LabAdmin/Widgets/FilterBar.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String filter = "Upcoming";

  Stream<List<Map<String, dynamic>>> _getAppointments() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    final labRef = FirebaseFirestore.instance
        .collection('lab')
        .doc(uid)
        .collection('appointments');

    return labRef.snapshots().asyncMap((snapshot) async {
      List<Map<String, dynamic>> results = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // ✅ Get patient info
        final patientId = data['patientId'];
        Map<String, dynamic>? patientData;

        if (patientId != null && patientId.toString().isNotEmpty) {
          final patientSnap = await FirebaseFirestore.instance
              .collection('patient')
              .doc(patientId)
              .get();
          if (patientSnap.exists) {
            patientData = patientSnap.data();
          }
        }

        // ✅ Get branch address
        final branchId = data['branchId'];
        String branchAddress = 'Unknown Branch';
        String branchName = 'Unknown Branch Name';
        if (branchId != null && branchId.toString().isNotEmpty) {
          final branchSnap = await FirebaseFirestore.instance
              .collection('lab')
              .doc(uid)
              .collection('locations')
              .doc(branchId)
              .get();
          if (branchSnap.exists) {
            branchAddress = branchSnap.data()?['address'] ?? 'No address';
            branchName = branchSnap.data()?['name'] ?? 'No address';
          }
        }

        // ✅ Map appointment data for UI
        final appointment = {
          'name': patientData?['name'] ?? 'Unknown Patient',
          'phone': patientData?['phone'] ?? 'No phone',
          'tests': (data['tests'] != null && data['tests'].isNotEmpty)
              ? List<Map<String, dynamic>>.from(
                  data['tests'].map(
                    (t) => {
                      'name': t['name'] ?? 'Unnamed Test',
                      'prescription':
                          t['prescription'] ?? null, 
                    },
                  ),
                )
              : [
                  {'name': 'No tests', 'prescription': null},
                ],

          'date': data['date'] ?? '',
          'time': data['time'] ?? '',
          'branch': branchName + ', ' + branchAddress,
          'collectionType': (data['serviceType'] == 'Home Collection')
              ? 'Home'
              : 'Walk-in',
          'status': data['status'] ?? 'Pending',
        };

        results.add(appointment);
      }

      return results
          .where((a) => a['status']?.toLowerCase() != 'pending')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00B4DB), Color(0xFF00BBA7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white24,
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Text(
                                "Appointments",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "View and manage scheduled appointments",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FilterBar(
                      items: const ["Upcoming", "Completed", "All"],
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
          stream: _getAppointments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No appointments found.",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              );
            }

            final allAppointments = snapshot.data!;

            // Make filter case-insensitive
            final filtered = filter.toLowerCase() == "all"
                ? allAppointments
                : allAppointments
                      .where(
                        (x) =>
                            (x['status'] ?? '').toString().toLowerCase() ==
                            filter.toLowerCase(),
                      )
                      .toList();

            // Show a proper message if no appointments after filtering
            if (filtered.isEmpty) {
              return Center(
                child: Text(
                  filter == "All"
                      ? "No appointments found."
                      : "No $filter appointments.",
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) =>
                  AppointmentCard(appointment: filtered[i]),
            );
          },
        ),
      ),
    );
  }
}
