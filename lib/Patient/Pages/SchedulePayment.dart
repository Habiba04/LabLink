import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/BookingService.dart';
import '../widgets/BookingDateCard.dart';
import '../widgets/BookingTimeCard.dart';
import '../widgets/BookingTotalCard.dart';
import '../widgets/BookingTestsCard.dart';
import '../widgets/BookingPaymentCard.dart';
import '../widgets/NonWorkingDayMessage.dart';
import '../widgets/ConfirmButton.dart';
import '../utils/BookingHelpers.dart';

class SchedulePaymentScreen extends StatefulWidget {
  final Map<String, dynamic> labData;
  final Map<String, dynamic> locationData;
  List<Map<String, dynamic>>? selectedTests;
  final String selectedService;
  String? prescriptionPath;

  SchedulePaymentScreen({
    super.key,
    required this.labData,
    required this.locationData,
    required this.selectedService,
    this.selectedTests,
    this.prescriptionPath,
  });

  @override
  State<SchedulePaymentScreen> createState() => _SchedulePaymentScreenState();
}

class _SchedulePaymentScreenState extends State<SchedulePaymentScreen> {
  late final BookingService _bookingService;
  StreamSubscription? _disabledSlotsSub;

  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  String? selectedTime;
  final String selectedPaymentMethod = "Cash";

  String? openAt;
  String? closeAt;
  List<String> workingDays = [];
  Set<String> disabledTimes = {};

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService(
      labData: widget.labData,
      locationData: widget.locationData,
      selectedTests: widget.selectedTests,
      selectedService: widget.selectedService,
      prescriptionPath: widget.prescriptionPath,
    );
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final data = await _bookingService.fetchLocationDetails();
    if (!mounted) return;

    setState(() {
      openAt = data['openAt'];
      closeAt = data['closeAt'];
      workingDays = List<String>.from(
        data['workingDays'] ?? [],
      ).map((d) => d.trim().substring(0, 3)).toList();
    });

    await _listenToDisabledSlots();
  }

  Future<void> _listenToDisabledSlots() {
    // Cancel old listener if exists
    _disabledSlotsSub?.cancel();

    final labId = widget.labData['id'];
    final locationId = widget.locationData['id'];
    final formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    final stream = FirebaseFirestore.instance
        .collection('lab')
        .doc(labId)
        .collection('locations')
        .doc(locationId)
        .collection('disabled_slots')
        .where('date', isEqualTo: formattedDate)
        .snapshots();

    _disabledSlotsSub = stream.listen((snapshot) {
      final times = snapshot.docs
          .map((doc) => doc.data()['time'] as String?)
          .where((t) => t != null)
          .cast<String>()
          .toSet();

      if (mounted) {
        setState(() {
          disabledTimes = times;
          selectedTime = null; // Reset chosen time if it becomes disabled
        });
      }
    });

    return stream.first;
  }

  void _handleDateSelected(DateTime newDate) {
    setState(() => selectedDate = newDate);
    _listenToDisabledSlots();
  }

  void _handleMonthChanged(int direction) {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + direction,
        1,
      );
      if (selectedDate.month != currentMonth.month) {
        selectedDate = currentMonth;
      }
    });
    _listenToDisabledSlots();
  }

  void _handleTimeSelected(String time) {
    setState(() => selectedTime = time);
  }

  bool _isWorkingDayForWidget(DateTime date) {
    return checkIsWorkingDay(date, workingDays);
  }

  List<String> _generateAvailableTimesForWidget() {
    if (openAt == null || closeAt == null) return [];
    return generateAvailableTimes(openAt!, closeAt!, selectedDate);
  }

  @override
  void dispose() {
    _disabledSlotsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _bookingService.calculateTotal();
    final bool isTimeDisabled =
        selectedTime != null && disabledTimes.contains(selectedTime!);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Schedule & Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BookingDateCard(
              selectedDate: selectedDate,
              currentMonth: currentMonth,
              workingDays: workingDays,
              onDateSelected: _handleDateSelected,
              onMonthChanged: _handleMonthChanged,
              isWorkingDay: _isWorkingDayForWidget,
              sectionTitleBuilder: buildSectionTitle,
              boxDecorationBuilder: getBoxDecoration,
            ),
            const SizedBox(height: 20),

            if (_isWorkingDayForWidget(selectedDate) && openAt != null)
              BookingTimeCard(
                availableTimes: _generateAvailableTimesForWidget(),
                disabledTimes: disabledTimes,
                selectedTime: selectedTime,
                onTimeSelected: _handleTimeSelected,
                sectionTitleBuilder: buildSectionTitle,
                boxDecorationBuilder: getBoxDecoration,
              )
            else if (openAt != null)
              const NonWorkingDayMessage(),
            const SizedBox(height: 20),

            BookingTestsCard(
              selectedTests: widget.selectedTests,
              selectedService: widget.selectedService,
              isPrescribed: widget.prescriptionPath != null,
            ),
            const SizedBox(height: 20),

            const BookingPaymentCard(),
            const SizedBox(height: 20),

            BookingTotalCard(totalAmount: totalAmount),
            const SizedBox(height: 30),

            ConfirmButton(
              bookingService: _bookingService,
              totalAmount: totalAmount,
              isTimeDisabled: isTimeDisabled,
              selectedTime: selectedTime,
              selectedDate: selectedDate,
              locationData: widget.locationData,
              labData: widget.labData,
              selectedPaymentMethod: selectedPaymentMethod,
            ),
          ],
        ),
      ),
    );
  }
}
