import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_model.freezed.dart';
part 'class_model.g.dart';

@freezed
abstract class ClassModel with _$ClassModel {
  const factory ClassModel({
    required String id,
    required String name,
    required String code,
    required String teacherId,
    required DateTime createdAt,
    @Default(0) int studentCount,
    @Default(0) int listCount,
  }) = _ClassModel;

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);
}
