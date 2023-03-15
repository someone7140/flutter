import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateService {
  static final outputFormat = DateFormat('yyyy/MM/dd');

  static String getStringFromDate(DateTime date) {
    return outputFormat.format(date);
  }

  static Future<void> selectDatePicker(
      BuildContext context, ValueNotifier<DateTime?> dateInputState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateInputState.value ?? DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime.now().add(const Duration(days: 360)));
    if (picked != null) {
      dateInputState.value = picked;
    }
  }
}
