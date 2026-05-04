import 'package:freezed_annotation/freezed_annotation.dart';
import 'todo_item_model.dart';

part 'completion_matrix_state.freezed.dart';

class StudentSummary {
  final String id;
  final String fullName;
  const StudentSummary({required this.id, required this.fullName});
}

@freezed
abstract class CompletionMatrixState with _$CompletionMatrixState {
  const factory CompletionMatrixState({
    required List<StudentSummary> students,
    required List<TodoItemModel> items,
    // Set of "itemId:studentId" pairs
    required Set<String> completedPairs,
  }) = _CompletionMatrixState;

  const CompletionMatrixState._();

  bool isCompleted(String itemId, String studentId) =>
      completedPairs.contains('$itemId:$studentId');

  int studentCompletionCount(String studentId) =>
      items.where((i) => isCompleted(i.id, studentId)).length;

  int itemCompletionCount(String itemId) =>
      students.where((s) => isCompleted(itemId, s.id)).length;
}
