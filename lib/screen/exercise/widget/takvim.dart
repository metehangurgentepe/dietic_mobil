import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
class Takvim extends StatefulWidget {
  static String routeName = '/takvim';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => Takvim(),
        settings:  RouteSettings(name: routeName));
  }
  const Takvim({Key? key}) : super(key: key);

  @override
  State<Takvim> createState() => _TakvimState();
}

class _TakvimState extends State<Takvim> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime(2019),
      lastDay:  DateTime(2026),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        // Use `selectedDayPredicate` to determine which day is currently selected.
        // If this returns true, then `day` will be marked as selected.

        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _focusedDay = focusedDay;
      },
    );
  }
}
