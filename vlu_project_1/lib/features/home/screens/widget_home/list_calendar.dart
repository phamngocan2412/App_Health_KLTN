import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ListCalendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateChange;

  const ListCalendar({
    super.key,
    required this.onDateChange,
  });

  @override
  State<ListCalendar> createState() => _ListCalendarState();
}

class _ListCalendarState extends State<ListCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week; // Default format is week

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with icons to switch calendar view format
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    _focusedDay = _focusedDay.subtract(Duration(days: _calendarFormat == CalendarFormat.month ? 30 : 7));
                  });
                  widget.onDateChange(_focusedDay);
                },
              ),
              const Text(
                'Calendar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  _calendarFormat == CalendarFormat.week
                      ? Icons.expand_more
                      : Icons.expand_less,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    _calendarFormat = _calendarFormat == CalendarFormat.week
                        ? CalendarFormat.month
                        : CalendarFormat.week;
                  });
                },
              ),
            ],
          ),
          // TableCalendar widget
          TableCalendar(
            firstDay: DateTime(2010),
            lastDay: DateTime(2200),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDateChange(selectedDay);
            },
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.blueAccent),
              weekendStyle: TextStyle(color: Colors.red),
            ),
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue),
            ),
            calendarFormat: _calendarFormat, // Use the selected format (week/month)
          ),
        ],
      ),
    );
  }
}
