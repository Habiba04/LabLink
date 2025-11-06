import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map order;
  const OrderDetailsScreen({required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late TextEditingController price;
  String status = 'Pending';

  @override
  void initState() {
    super.initState();
    price = TextEditingController(text: "1250");
  }

  @override
  Widget build(BuildContext context) {
    bool isEditable = widget.order['manual'] && status == 'Pending';

    return Scaffold(
      appBar: AppBar(title: Text('Order Details'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Patient Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(.1), borderRadius: BorderRadius.circular(12)),
                child: Text(status),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text("${o['name']} - ${o['age']} years"),
          Text("📞 +1 (555) 123-4567"),
          Text("📍 ${o['collection']}"),
          Text("📅 ${o['date']} at ${o['time']}"),
        ]),
      ),
    );
  }

  Widget _priceCard(bool editable) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Price Confirmation', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Total Amount (₹)'),
          TextField(
            controller: price,
            enabled: editable,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: editable ? Colors.white : Colors.grey[200],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _summaryBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(10)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Order Summary\nTotal Amount', style: TextStyle(color: Colors.white)),
        Text('₹ ${price.text}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
      ]),
    );
  }

  Widget _actionButtons() {
    return Row(children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => setState(() => status = 'Cancelled'),
          style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
          child: Text('Reject', style: TextStyle(color: Colors.red)),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: ElevatedButton(
          onPressed: () => setState(() => status = 'Confirmed'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          child: Text('Accept'),
        ),
      )
    ]);
  }
}
