import 'package:intl/intl.dart';

class AppDateUtils {
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime startOfWeek(DateTime date) {
    final weekday = date.weekday;
    return startOfDay(date).subtract(Duration(days: weekday - 1));
  }

  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  static bool isSameDay(DateTime left, DateTime right) =>
      left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;

  static String dayLabel(DateTime date, String locale) =>
      DateFormat.E(locale).format(date);

  static String fullDate(DateTime date, String locale) =>
      DateFormat.yMMMMEEEEd(locale).format(date);

  static String sectionDate(DateTime date, String locale) =>
      DateFormat.yMMMd(locale).format(date);
}
