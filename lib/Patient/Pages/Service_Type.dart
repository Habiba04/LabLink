import 'package:flutter/material.dart';
import 'package:lablink/Patient/Pages/Schedule_Payment.dart';
import '../widgets/Service_Option_Card.dart';

class ServiceTypeScreen extends StatefulWidget {
  final Map<String, dynamic> labData;
  final Map<String, dynamic> locationData;
  final List<Map<String, dynamic>>? selectedTests;
  final String? prescroptionPath;

  const ServiceTypeScreen({
    super.key,
    required this.labData,
    required this.locationData,
    this.selectedTests,
    this.prescroptionPath,
  });

  @override
  State<ServiceTypeScreen> createState() => _ServiceTypeScreenState();
}

class _ServiceTypeScreenState extends State<ServiceTypeScreen> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service Type",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Where would you like to get the test done?",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            ServiceOptionCard(
              icon: Icons.apartment,
              title: "Visit Lab",
              subtitle: "Come to the lab for sample collection",
              isSelected: selectedOption == "Visit Lab",
              gradientColors: const [Color(0xFF00B4DB), Color(0xFF0083B0)],
              onTap: () => setState(() => selectedOption = "Visit Lab"),
            ),
            const SizedBox(height: 20),
            ServiceOptionCard(
              icon: Icons.home_rounded,
              title: "Home Collection",
              subtitle: "Our technician will visit your home",
              extraCharge: "50 EGP extra charge",
              isSelected: selectedOption == "Home Collection",
              gradientColors: const [Color(0xFF00BBA7), Color(0xFF00BBA7)],
              onTap: () => setState(() => selectedOption = "Home Collection"),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: selectedOption == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SchedulePaymentScreen(
                              labData: widget.labData,
                              locationData: widget.locationData,
                              selectedTests: widget.selectedTests,
                              selectedService: selectedOption!,
                              prescriptionPath: widget.prescroptionPath,
                            ),
                          ),
                        );
                      },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: selectedOption == null
                        ? const LinearGradient(
                            colors: [Colors.grey, Colors.grey],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF00B4DB), Color(0xFF00BBA7)],
                          ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white.withOpacity(
                          selectedOption == null ? 0.6 : 1.0,
                        ),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
