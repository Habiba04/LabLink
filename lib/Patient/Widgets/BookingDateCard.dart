import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDateCard extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final List<String> workingDays;
  final void Function(DateTime newDate) onDateSelected;
  final VoidCallback onMonthChanged;
  final bool Function(DateTime date) isWorkingDay;
  final Widget Function(IconData icon, String title) sectionTitleBuilder;
  final BoxDecoration Function() boxDecorationBuilder;

  const BookingDateCard({
    super.key,
    required this.selectedDate,
    required this.currentMonth,
    required this.workingDays,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.isWorkingDay,
    required this.sectionTitleBuilder,
    required this.boxDecorationBuilder,
  });

  int _leadingEmptyDaysCount() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    return firstDayOfMonth.weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat('MMMM yyyy');
    final daysInMonth = List.generate(
      DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month),
      (index) => DateTime(currentMonth.year, currentMonth.month, index + 1),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationBuilder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitleBuilder(Icons.calendar_today, "Select Date"),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => onMonthChanged(),
              ),
              Text(
                monthFormat.format(currentMonth),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => onMonthChanged(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                .map(
                  (e) => Expanded(
                    child: Center(
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: daysInMonth.length + _leadingEmptyDaysCount(),
            itemBuilder: (context, index) {
              if (index < _leadingEmptyDaysCount()) {
                return const SizedBox.shrink();
              }

              final day = daysInMonth[index - _leadingEmptyDaysCount()];
              final isSelected = day.day == selectedDate.day &&
                  day.month == selectedDate.month &&
                  day.year == selectedDate.year;

              final isPast = day.isBefore(
                DateTime.now().subtract(const Duration(days: 1)),
              );
              final isWork = isWorkingDay(day);

              return GestureDetector(
                onTap: (!isWork || isPast)
                    ? null
                    : () => onDateSelected(day),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0ABAB5)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${day.day}",
                    style: TextStyle(
                      color: (isPast || !isWork)
                          ? Colors.grey.shade400
                          : isSelected
                              ? Colors.white
                              : Colors.grey.shade800,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}