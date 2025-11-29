
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/LabAdmin/Utils/date_utils.dart'; 

void main() {
  group('Time Ago Utility Unit Tests', () {
    test('timeAgo returns "Just now" for current time', () {
      final now = DateTime.now();
      expect(timeAgo(now), 'just now');
    });

    test('timeAgo returns minutes correctly', () {
      final fewMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
      expect(timeAgo(fewMinutesAgo), '5 mins ago');
    });

    test('timeAgo returns hours correctly', () {
      final fewHoursAgo = DateTime.now().subtract(const Duration(hours: 3));
      expect(timeAgo(fewHoursAgo), '3 hours ago');
    });

    test('timeAgo returns days correctly', () {
      final fewDaysAgo = DateTime.now().subtract(const Duration(days: 4));
      expect(timeAgo(fewDaysAgo), 'Nov 25, 2025');
    });

    test('timeAgo returns weeks for differences greater than 7 days', () {
      final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14));
      expect(timeAgo(twoWeeksAgo), 'Nov 15, 2025');
      
      final oneWeekAgo = DateTime.now().subtract(const Duration(days: 8));
      expect(timeAgo(oneWeekAgo), 'Nov 21, 2025');
    });
    
    test('timeAgo returns N/A for null input', () {
      expect(timeAgo(null), 'Unknown');
    });
  });
}