import 'package:intl/intl.dart';

String formatDateAndTime(String date) =>
    DateFormat.yMMMEd('en_US').add_jm().format(DateTime.parse(date));

String formatDate(String date) =>
    DateFormat.yMMMEd('en_US').format(DateTime.parse(date));
