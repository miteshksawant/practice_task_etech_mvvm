import 'package:intl/intl.dart';

class AppComman {

  static String getFormattedDate({required DateTime dateTime}) {
    final DateFormat _formatter = DateFormat.yMMMMd();
    return _formatter.format(dateTime);
  }
}