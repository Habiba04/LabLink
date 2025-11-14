import 'dart:math';

import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late TextEditingController price = TextEditingController(
    text: "${widget.order['price']}",
  );
  String status = 'Pending';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isEditable = widget.order['manual'] && status == 'Pending';
    print("isEditable:  $isEditable");
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoCard(),
            _priceCard(isEditable),
            _summaryBox(),
            if (status == 'Pending') _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _infoCard() {
    var o = widget.order;
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Patient Information", style: TextStyle(fontSize: 16)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFEDD4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: Color(0xFFCA3500), fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.person_2_outlined, color: Color(0XFF99A1AF)),
              title: Text(
                "Name",
                style: TextStyle(color: Color(0xFF6A7282), fontSize: 16),
              ),
              subtitle: Text(
                "${o['name']} - ${o['age']} years",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Color(0XFF99A1AF)),
              title: Text(
                "Phone",
                style: TextStyle(color: Color(0xFF6A7282), fontSize: 16),
              ),
              subtitle: Text(
                "+2 ${o['phone']}",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.location_on_outlined,
                color: Color(0XFF99A1AF),
              ),
              title: Text(
                "Service Type",
                style: TextStyle(color: Color(0xFF6A7282), fontSize: 16),
              ),
              subtitle: Text(
                "${o['collection']} \n ${o['collection'] == 'Home Collection' ? o['address'] : ''}",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today_outlined,
                color: Color(0XFF99A1AF),
              ),
              title: Text(
                "Schedule",
                style: TextStyle(color: Color(0xFF6A7282), fontSize: 16),
              ),
              subtitle: Text(
                "${o['date']} at ${o['time']}",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceCard(bool editable) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Confirmation',
              style: TextStyle(fontSize: 16, color: Color(0xFF101828)),
            ),
            SizedBox(height: 10),
            Text(
              'Total Amount (E£)',
              style: TextStyle(fontSize: 14, color: Color(0xFF0A0A0A)),
            ),
            TextField(
              controller: price,
              enabled: editable,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: editable ? Colors.white : Color(0xFFF3F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00BBA7), Color(0xFF00B8DB)],
        ),

        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '${price.text} E£',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => setState(() => status = 'Cancelled'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: Text(
              'Reject',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BBA7), Color(0xFF00B8DB)],
              ),
              borderRadius: BorderRadius.circular(45),
            ),
            child: ElevatedButton(
              onPressed: () => setState(() => status = 'Confirmed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Accept',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
