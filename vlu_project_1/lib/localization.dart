import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static List<String> supportedLanguages = ['en', 'vi'];

  static List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('vi'),
  ];

  static Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  // Calendar and Days
  String get calendar => locale.languageCode == 'vi' ? 'Lịch' : 'Calendar';
  String get month => locale.languageCode == 'vi' ? 'Tháng' : 'Month';

  String get monday => locale.languageCode == 'vi' ? 'Thứ 2' : 'Monday';
  String get tuesday => locale.languageCode == 'vi' ? 'Thứ 3' : 'Tuesday';
  String get wednesday => locale.languageCode == 'vi' ? 'Thứ 4' : 'Wednesday';
  String get thursday => locale.languageCode == 'vi' ? 'Thứ 5' : 'Thursday';
  String get friday => locale.languageCode == 'vi' ? 'Thứ 6' : 'Friday';
  String get saturday => locale.languageCode == 'vi' ? 'Thứ 7' : 'Saturday';
  String get sunday => locale.languageCode == 'vi' ? 'Chủ nhật' : 'Sunday';

  // Months
  String get january => locale.languageCode == 'vi' ? 'Tháng 1' : 'January';
  String get february => locale.languageCode == 'vi' ? 'Tháng 2' : 'February';
  String get march => locale.languageCode == 'vi' ? 'Tháng 3' : 'March';
  String get april => locale.languageCode == 'vi' ? 'Tháng 4' : 'April';
  String get may => locale.languageCode == 'vi' ? 'Tháng 5' : 'May';
  String get june => locale.languageCode == 'vi' ? 'Tháng 6' : 'June';
  String get july => locale.languageCode == 'vi' ? 'Tháng 7' : 'July';
  String get august => locale.languageCode == 'vi' ? 'Tháng 8' : 'August';
  String get september => locale.languageCode == 'vi' ? 'Tháng 9' : 'September';
  String get october => locale.languageCode == 'vi' ? 'Tháng 10' : 'October';
  String get november => locale.languageCode == 'vi' ? 'Tháng 11' : 'November';
  String get december => locale.languageCode == 'vi' ? 'Tháng 12' : 'December';

  // Buttons and Labels
  String get addButtonLabel => locale.languageCode == 'vi' ? '+ Thêm' : '+ Add';
  String get today => locale.languageCode == 'vi' ? 'Hôm nay' : 'Today';
  String get save => locale.languageCode == 'vi' ? 'Lưu' : 'Save';
  String get cancel => locale.languageCode == 'vi' ? 'Hủy' : 'Cancel';
  String get delete => locale.languageCode == 'vi' ? 'Xóa' : 'Delete';
  String get edit => locale.languageCode == 'vi' ? 'Chỉnh sửa' : 'Edit';

  // Errors and Notifications
  String get error => locale.languageCode == 'vi' ? 'Lỗi' : 'Error';
  String get success => locale.languageCode == 'vi' ? 'Thành công' : 'Success';
  String get noData => locale.languageCode == 'vi' ? 'Không có dữ liệu' : 'No data available';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
