import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Widgets/FilterBar.dart';
import 'package:lablink/LabAdmin/Widgets/appointmentCard.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String filter = "Upcoming";

  final appointments = [
    {
      'name': 'Sarah Johnson',
      'phone': '+1 (555) 123-4567',
      'test': 'Complete Blood Count',
      'date': 'Tomorrow',
      'time': '09:00 AM',
      'branch': 'Main Branch',
      'collectionType': 'Home Collection',
      'status': 'Upcoming',
    },
    {
      'name': 'Michael Chen',
      'phone': '+1 (555) 234-5678',
      'test': 'Lipid Profile',
      'date': 'Tomorrow',
      'time': '10:30 AM',
      'branch': 'North Branch',
      'collectionType': 'Walk-in',
      'status': 'Upcoming',
    },
    {
      'name': 'Lisa Anderson',
      'phone': '+1 (555) 678-1111',
      'test': 'Liver Function Test',
      'date': 'Oct 20, 2025',
      'time': '03:30 PM',
      'branch': 'Main Branch',
      'collectionType': 'Walk-in',
      'status': 'Completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var filtered = filter == "All"
        ? appointments
        : appointments.where((x) => x['status'] == filter).toList();

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
                        // ✅ Back button + Titles
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 🔙 Back Button
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
                              Text(
                                "Appointments",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // ✅ Title & Subtitle
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
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
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (ctx, i) => AppointmentCard(appointment: filtered[i]),
        ),
      ),
    );
  }
}
