import 'package:flutter_test/flutter_test.dart';
import 'package:todolist_proto/features/teacher/domain/completion_matrix_state.dart';
import 'package:todolist_proto/features/teacher/domain/todo_item_model.dart';

void main() {
  final item1 = TodoItemModel(
    id: 'item-1',
    listId: 'list-1',
    title: 'Task A',
    position: 0,
    createdAt: DateTime(2024),
  );
  final item2 = TodoItemModel(
    id: 'item-2',
    listId: 'list-1',
    title: 'Task B',
    position: 1,
    createdAt: DateTime(2024),
  );

  const student1 = StudentSummary(id: 'stu-1', fullName: 'Alice');
  const student2 = StudentSummary(id: 'stu-2', fullName: 'Bob');

  group('CompletionMatrixState', () {
    test('isCompleted returns false when no completions', () {
      final state = CompletionMatrixState(
        students: [student1, student2],
        items: [item1, item2],
        completedPairs: {},
      );
      expect(state.isCompleted('item-1', 'stu-1'), isFalse);
    });

    test('isCompleted returns true for matching pair', () {
      final state = CompletionMatrixState(
        students: [student1],
        items: [item1],
        completedPairs: {'item-1:stu-1'},
      );
      expect(state.isCompleted('item-1', 'stu-1'), isTrue);
    });

    test('isCompleted does not cross-match different pairs', () {
      final state = CompletionMatrixState(
        students: [student1, student2],
        items: [item1, item2],
        completedPairs: {'item-1:stu-1'},
      );
      expect(state.isCompleted('item-1', 'stu-2'), isFalse);
      expect(state.isCompleted('item-2', 'stu-1'), isFalse);
    });

    test('studentCompletionCount counts only that student', () {
      final state = CompletionMatrixState(
        students: [student1, student2],
        items: [item1, item2],
        completedPairs: {'item-1:stu-1', 'item-2:stu-1', 'item-1:stu-2'},
      );
      expect(state.studentCompletionCount('stu-1'), 2);
      expect(state.studentCompletionCount('stu-2'), 1);
    });

    test('itemCompletionCount counts only that item', () {
      final state = CompletionMatrixState(
        students: [student1, student2],
        items: [item1, item2],
        completedPairs: {'item-1:stu-1', 'item-1:stu-2'},
      );
      expect(state.itemCompletionCount('item-1'), 2);
      expect(state.itemCompletionCount('item-2'), 0);
    });

    test('full completion matrix — all pairs complete', () {
      final state = CompletionMatrixState(
        students: [student1, student2],
        items: [item1, item2],
        completedPairs: {
          'item-1:stu-1',
          'item-1:stu-2',
          'item-2:stu-1',
          'item-2:stu-2',
        },
      );
      expect(state.studentCompletionCount('stu-1'), 2);
      expect(state.studentCompletionCount('stu-2'), 2);
      expect(state.itemCompletionCount('item-1'), 2);
      expect(state.itemCompletionCount('item-2'), 2);
    });
  });
}
