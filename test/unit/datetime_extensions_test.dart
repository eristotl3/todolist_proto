import 'package:flutter_test/flutter_test.dart';
import 'package:todolist_proto/core/extensions/datetime_extensions.dart';

void main() {
  group('DateTimeExtensions', () {
    test('toDisplayDate formats correctly', () {
      final dt = DateTime(2025, 3, 5);
      expect(dt.toDisplayDate(), 'Mar 5, 2025');
    });

    test('isOverdue returns true for past date', () {
      final past = DateTime(2000, 1, 1);
      expect(past.isOverdue, isTrue);
    });

    test('isOverdue returns false for future date', () {
      final future = DateTime(2099, 12, 31);
      expect(future.isOverdue, isFalse);
    });
  });

  group('NullableDateTimeExtensions', () {
    test('returns formatted date when non-null', () {
      final dt = DateTime(2025, 6, 15);
      expect(dt.toDisplayDate(), 'Jun 15, 2025');
    });

    test('returns "No due date" when null', () {
      const DateTime? dt = null;
      expect(dt.toDisplayDate(), 'No due date');
    });
  });
}
