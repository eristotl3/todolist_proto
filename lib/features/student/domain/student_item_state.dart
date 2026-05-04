import 'package:freezed_annotation/freezed_annotation.dart';
import '../../teacher/domain/todo_item_model.dart';

part 'student_item_state.freezed.dart';

@freezed
abstract class StudentItemState with _$StudentItemState {
  const factory StudentItemState({
    required TodoItemModel item,
    @Default(false) bool isCompleted,
  }) = _StudentItemState;
}
