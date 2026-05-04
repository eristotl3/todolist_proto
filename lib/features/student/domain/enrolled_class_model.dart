import 'package:freezed_annotation/freezed_annotation.dart';

part 'enrolled_class_model.freezed.dart';
part 'enrolled_class_model.g.dart';

@freezed
abstract class EnrolledClassModel with _$EnrolledClassModel {
  const factory EnrolledClassModel({
    required String id,
    required String name,
    required String code,
    required String teacherId,
    required DateTime createdAt,
  }) = _EnrolledClassModel;

  factory EnrolledClassModel.fromJson(Map<String, dynamic> json) =>
      _$EnrolledClassModelFromJson(json);
}
