import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Pages/OrderDetailsScreen.dart';
import 'package:lablink/LabAdmin/Widgets/FilterBar.dart';
import 'package:lablink/LabAdmin/Widgets/OrderCard.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String filter = "Prescriptions";
  String searchQuery = "";

  final orders = [
    {
      'id': '101',
      'name': 'Sarah Johnson',
      'age': 28,
      'date': 'Oct 16, 2025',
      'time': '10:00 AM',
      'collection': 'Home Collection',
      'status': 'New',
      'type': 'Prescriptions',
      'manual': false,
      'tests': ['CBC'],
    },
    {
      'id': '102',
      'name': 'David Brown',
      'age': 55,
      'date': 'Oct 17, 2025',
      'time': '09:00 AM',
      'collection': 'Visit Lab',
      'status': 'New',
      'type': 'Manual Booking',
      'manual': true,
      'tests': ['Thyroid', 'Glucose'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ Apply filter + search
    var filtered = orders.where((x) {
      bool matchesFilter = x['type'] == filter;
      bool matchesSearch = x['name'].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // ✅ WHITE HEADER (like appointments, but white)
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
                        // ✅ Back button + title row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                "Orders",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ✅ Search bar inside header
                        TextField(
                          onChanged: (value) {
                            setState(() => searchQuery = value);
                          },
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

                  // ✅ Filter bar below header
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

        // ✅ ORDER LIST
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (_, i) => OrderCard(
            order: filtered[i],

            onAccept: () {
              setState(() {
                filtered[i]['status'] = 'Confirmed';
              });
            },

            onReject: () {
              setState(() {
                filtered[i]['status'] = 'Cancelled';
              });
            },

            onViewDetails: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(order: filtered[i]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
