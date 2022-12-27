import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPage> {
  dynamic _selectedDay = DateTime.now();
  dynamic _focusedDay = DateTime.now();
  late Map<DateTime, List<dynamic>> _events;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drink-TableCalendar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  print(focusedDay
                      .toString()); // update `_focusedDay` here as well
                });
              },
              // eventLoader: (day) {
              //   return _selectedDay(day);
              // },
//               List<Event> _getEventsForDay(DateTime day) {
//   return _selectedDay[day] ?? [];
// }
            )
          ],
        ),
      ),
    );
  }
}
