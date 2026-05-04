import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist_proto/shared/widgets/error_retry_widget.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: child));

void main() {
  group('ErrorRetryWidget', () {
    testWidgets('shows default title and error message', (tester) async {
      await tester.pumpWidget(
        _wrap(ErrorRetryWidget(error: Exception('test error'))),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('test error'), findsOneWidget);
    });

    testWidgets('shows custom label when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(ErrorRetryWidget(
          error: Exception('oops'),
          label: 'Could not load classes',
        )),
      );

      expect(find.text('Could not load classes'), findsOneWidget);
    });

    testWidgets('does not show retry button when onRetry is null',
        (tester) async {
      await tester.pumpWidget(
        _wrap(ErrorRetryWidget(error: Exception('x'))),
      );

      expect(find.text('Try again'), findsNothing);
    });

    testWidgets('shows retry button when onRetry provided', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        _wrap(ErrorRetryWidget(
          error: Exception('x'),
          onRetry: () => tapped = true,
        )),
      );

      expect(find.text('Try again'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      expect(tapped, isTrue);
    });

    testWidgets('strips AppException prefix from message', (tester) async {
      await tester.pumpWidget(
        _wrap(ErrorRetryWidget(error: 'AppException: Network timeout')),
      );

      expect(find.text('Network timeout'), findsOneWidget);
      expect(find.textContaining('AppException'), findsNothing);
    });

    testWidgets('strips Exception prefix from message', (tester) async {
      await tester.pumpWidget(
        _wrap(ErrorRetryWidget(error: 'Exception: Bad request')),
      );

      expect(find.text('Bad request'), findsOneWidget);
    });

    testWidgets('shows cloud_off icon', (tester) async {
      await tester.pumpWidget(
        _wrap(ErrorRetryWidget(error: Exception('x'))),
      );

      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
    });
  });
}
