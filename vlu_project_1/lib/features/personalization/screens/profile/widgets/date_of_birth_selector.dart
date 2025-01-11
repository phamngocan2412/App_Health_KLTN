import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/widgets/profile_menu.dart';

class DateOfBirthSelector extends StatefulWidget {
  const DateOfBirthSelector({super.key});

  @override
  DateOfBirthSelectorState createState() => DateOfBirthSelectorState();
}

class DateOfBirthSelectorState extends State<DateOfBirthSelector> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadDateOfBirth(); 
  }

  Future<void> loadDateOfBirth() async {
    final prefs = await SharedPreferences.getInstance();
    String? dateString = prefs.getString('date_of_birth');
    if (dateString != null) {
      selectedDate = DateTime.parse(dateString); 
      setState(() {}); 
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      errorFormatText: 'Nhập đúng định dạng ngày',
      errorInvalidText: 'Ngày không hợp lệ, vui lòng chọn trong khoảng thời gian hợp lệ',
      helpText: 'Chọn ngày',
      cancelText: "Thoát",
      confirmText: "Ok"
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate; 
      });
      saveDateOfBirth(pickedDate); 
    }
  }

  Future<void> saveDateOfBirth(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('date_of_birth', date.toIso8601String()); 
  }

  @override
  Widget build(BuildContext context) {
    return ProfileMenu(
      title: 'Ngày sinh',
      value: DateFormat('dd/MM/yyyy').format(selectedDate),
      onPressed: () {
        _selectDate(context);
      },
    );
  }
}