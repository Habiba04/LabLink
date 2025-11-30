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

  AppointmentNotifier() {
    _subscribeToAppointments();
  }

  void _subscribeToAppointments() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      _appointmentSubscription?.cancel();

      Stream<List<Appointment>> streamPatientAppointments() {
        final userId = uid;

        return FirebaseFirestore.instance
            .collection('patient')
            .doc(userId)
            .collection('appointments')
            .orderBy('createdAt', descending: true)
            .snapshots()
            .map((snapshot) {
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

          _error = e.toString().contains('user-not-signed-in')
              ? 'user-not-signed-in'
              : 'Error fetching appointments: $e';
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoading = false;
      _error = e.toString().contains('user-not-signed-in')
          ? 'user-not-signed-in'
          : e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshAppointments() async {
    _subscribeToAppointments();
  }

  @override
  void dispose() {
    _appointmentSubscription?.cancel();
    super.dispose();
  }
}
