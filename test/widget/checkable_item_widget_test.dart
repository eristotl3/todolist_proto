import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist_proto/features/student/domain/student_item_state.dart';
import 'package:todolist_proto/features/student/presentation/widgets/checkable_item_widget.dart';
import 'package:todolist_proto/features/teacher/domain/todo_item_model.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: child));

TodoItemModel _item({String title = 'Task A', DateTime? dueDate}) =>
    TodoItemModel(
      id: 'i1',
      listId: 'l1',
      title: title,
      dueDate: dueDate,
      position: 0,
      createdAt: DateTime(2024),
    );

void main() {
  group('CheckableItemWidget', () {
    testWidgets('shows item title', (tester) async {
      final state =
          StudentItemState(item: _item(title: 'Read chapter 3'));

      await tester.pumpWidget(_wrap(
        CheckableItemWidget(itemState: state, onToggle: () {}),
      ));

      expect(find.text('Read chapter 3'), findsOneWidget);
    });

    testWidgets('calls onToggle when tapped', (tester) async {
      bool toggled = false;
      final state = StudentItemState(item: _item());

      await tester.pumpWidget(_wrap(
        CheckableItemWidget(
          itemState: state,
          onToggle: () => toggled = true,
        ),
      ));

      await tester.tap(find.byType(CheckableItemWidget));
      expect(toggled, isTrue);
    });

    testWidgets('shows due date when present', (tester) async {
      final state = StudentItemState(
        item: _item(dueDate: DateTime(2025, 6, 15)),
      );

      await tester.pumpWidget(_wrap(
        CheckableItemWidget(itemState: state, onToggle: () {}),
      ));

      expect(find.textContaining('Jun 15, 2025'), findsOneWidget);
    });

    testWidgets('does not show due date when absent', (tester) async {
      final state = StudentItemState(item: _item());

      await tester.pumpWidget(_wrap(
        CheckableItemWidget(itemState: state, onToggle: () {}),
      ));

      expect(find.textContaining('Due'), findsNothing);
    });
  });
}
