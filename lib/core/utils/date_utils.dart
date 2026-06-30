import 'package:intl/intl.dart';

class DateUtilsHelper {
  DateUtilsHelper._();

  static String formatShort(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }
}
