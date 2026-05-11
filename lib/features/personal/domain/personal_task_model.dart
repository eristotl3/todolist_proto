import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_task_model.freezed.dart';
part 'personal_task_model.g.dart';

@freezed
abstract class PersonalTaskModel with _$PersonalTaskModel {
  const factory PersonalTaskModel({
    required String id,
    required String userId,
    required String title,
    required bool isCompleted,
    required int position,
    required DateTime createdAt,
    DateTime? startDate,
    DateTime? endDate,
    String? groupName,
  }) = _PersonalTaskModel;

  factory PersonalTaskModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalTaskModelFromJson(json);
}
