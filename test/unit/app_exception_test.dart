import 'package:flutter_test/flutter_test.dart';
import 'package:todolist_proto/core/errors/app_exception.dart';

void main() {
  group('AppException', () {
    test('toString includes the message with prefix', () {
      const e = AppException('Something failed');
      expect(e.toString(), 'AppException: Something failed');
    });

    test('stores cause', () {
      final cause = Exception('network error');
      final e = AppException('Failed', cause: cause);
      expect(e.cause, same(cause));
    });

    test('cause is optional', () {
      const e = AppException('No cause');
      expect(e.cause, isNull);
    });
  });
}
