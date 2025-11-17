// File: Patient/providers/appointment_notifier.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Models/Appointment.dart';

class AppointmentNotifier extends ChangeNotifier {
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  String? _error;
  StreamSubscription? _appointmentSubscription;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Constructor: Requires BookingService to access the streaming method
  AppointmentNotifier() {
    _subscribeToAppointments();
  }

  void _subscribeToAppointments() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // The BookingService.getCurrentUserId() will handle the FirebaseAuth check.
    // We catch the error here if the user isn't logged in.
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      // Cancel any old subscription before starting a new one
      _appointmentSubscription?.cancel();

      Stream<List<Appointment>> streamPatientAppointments() {
        final userId = uid; // Fetches UID internally

        return FirebaseFirestore.instance
            .collection('patient')
            .doc(userId)
            .collection('appointments')
            .orderBy('createdAt', descending: true)
            .snapshots() // ⬅️ KEY CHANGE: listen for real-time updates
            .map((snapshot) {
              // Map the QuerySnapshot to a List<Appointment>
              return snapshot.docs
                  .map((doc) => Appointment.fromFirestore(doc))
                  .toList();
            })
            .handleError((e) {
              print(
                '❌ Error streaming patient appointments for UID $userId: $e',
              );
              throw e;
            });
      }

      _appointmentSubscription = streamPatientAppointments().listen(
        (newAppointments) {
          _appointments = newAppointments;
          _isLoading = false;
          _error = null;
          notifyListeners();
        },
        onError: (e) {
          _appointments = [];
          _isLoading = false;
          // Store a custom error message for UI display
          _error = e.toString().contains('user-not-signed-in')
              ? 'user-not-signed-in'
              : 'Error fetching appointments: $e';
          notifyListeners();
        },
      );
    } catch (e) {
      // Catch exceptions from getCurrentUserId (e.g., user-not-signed-in)
      _isLoading = false;
      _error = e.toString().contains('user-not-signed-in')
          ? 'user-not-signed-in'
          : e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshAppointments() async {
    _subscribeToAppointments();
    // No need to await here, as the stream listener will handle the updates.
  }

  @override
  void dispose() {
    _appointmentSubscription?.cancel();
    super.dispose();
  }
}
