import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toDisplayDate() => DateFormat('MMM d, y').format(this);
  String toDisplayDateTime() => DateFormat('MMM d, y • h:mm a').format(this);
  bool get isOverdue => isBefore(DateTime.now());
}

extension NullableDateTimeExtensions on DateTime? {
  String toDisplayDate() =>
      this == null ? 'No due date' : this!.toDisplayDate();
}
