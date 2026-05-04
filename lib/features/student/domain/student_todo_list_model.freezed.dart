// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_todo_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentTodoListModel {

 String get id; String get classId; String get classNameLabel; String get title; String? get description; DateTime? get dueDate; DateTime get createdAt; int get itemCount; int get completedCount;
/// Create a copy of StudentTodoListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentTodoListModelCopyWith<StudentTodoListModel> get copyWith => _$StudentTodoListModelCopyWithImpl<StudentTodoListModel>(this as StudentTodoListModel, _$identity);

  /// Serializes this StudentTodoListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentTodoListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.classNameLabel, classNameLabel) || other.classNameLabel == classNameLabel)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,classId,classNameLabel,title,description,dueDate,createdAt,itemCount,completedCount);

@override
String toString() {
  return 'StudentTodoListModel(id: $id, classId: $classId, classNameLabel: $classNameLabel, title: $title, description: $description, dueDate: $dueDate, createdAt: $createdAt, itemCount: $itemCount, completedCount: $completedCount)';
}


}

/// @nodoc
abstract mixin class $StudentTodoListModelCopyWith<$Res>  {
  factory $StudentTodoListModelCopyWith(StudentTodoListModel value, $Res Function(StudentTodoListModel) _then) = _$StudentTodoListModelCopyWithImpl;
@useResult
$Res call({
 String id, String classId, String classNameLabel, String title, String? description, DateTime? dueDate, DateTime createdAt, int itemCount, int completedCount
});




}
/// @nodoc
class _$StudentTodoListModelCopyWithImpl<$Res>
    implements $StudentTodoListModelCopyWith<$Res> {
  _$StudentTodoListModelCopyWithImpl(this._self, this._then);

  final StudentTodoListModel _self;
  final $Res Function(StudentTodoListModel) _then;

/// Create a copy of StudentTodoListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? classId = null,Object? classNameLabel = null,Object? title = null,Object? description = freezed,Object? dueDate = freezed,Object? createdAt = null,Object? itemCount = null,Object? completedCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,classNameLabel: null == classNameLabel ? _self.classNameLabel : classNameLabel // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentTodoListModel].
extension StudentTodoListModelPatterns on StudentTodoListModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentTodoListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentTodoListModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentTodoListModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentTodoListModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentTodoListModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentTodoListModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String classId,  String classNameLabel,  String title,  String? description,  DateTime? dueDate,  DateTime createdAt,  int itemCount,  int completedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentTodoListModel() when $default != null:
return $default(_that.id,_that.classId,_that.classNameLabel,_that.title,_that.description,_that.dueDate,_that.createdAt,_that.itemCount,_that.completedCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String classId,  String classNameLabel,  String title,  String? description,  DateTime? dueDate,  DateTime createdAt,  int itemCount,  int completedCount)  $default,) {final _that = this;
switch (_that) {
case _StudentTodoListModel():
return $default(_that.id,_that.classId,_that.classNameLabel,_that.title,_that.description,_that.dueDate,_that.createdAt,_that.itemCount,_that.completedCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String classId,  String classNameLabel,  String title,  String? description,  DateTime? dueDate,  DateTime createdAt,  int itemCount,  int completedCount)?  $default,) {final _that = this;
switch (_that) {
case _StudentTodoListModel() when $default != null:
return $default(_that.id,_that.classId,_that.classNameLabel,_that.title,_that.description,_that.dueDate,_that.createdAt,_that.itemCount,_that.completedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentTodoListModel implements StudentTodoListModel {
  const _StudentTodoListModel({required this.id, required this.classId, required this.classNameLabel, required this.title, this.description, this.dueDate, required this.createdAt, this.itemCount = 0, this.completedCount = 0});
  factory _StudentTodoListModel.fromJson(Map<String, dynamic> json) => _$StudentTodoListModelFromJson(json);

@override final  String id;
@override final  String classId;
@override final  String classNameLabel;
@override final  String title;
@override final  String? description;
@override final  DateTime? dueDate;
@override final  DateTime createdAt;
@override@JsonKey() final  int itemCount;
@override@JsonKey() final  int completedCount;

/// Create a copy of StudentTodoListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentTodoListModelCopyWith<_StudentTodoListModel> get copyWith => __$StudentTodoListModelCopyWithImpl<_StudentTodoListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentTodoListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentTodoListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.classNameLabel, classNameLabel) || other.classNameLabel == classNameLabel)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,classId,classNameLabel,title,description,dueDate,createdAt,itemCount,completedCount);

@override
String toString() {
  return 'StudentTodoListModel(id: $id, classId: $classId, classNameLabel: $classNameLabel, title: $title, description: $description, dueDate: $dueDate, createdAt: $createdAt, itemCount: $itemCount, completedCount: $completedCount)';
}


}

/// @nodoc
abstract mixin class _$StudentTodoListModelCopyWith<$Res> implements $StudentTodoListModelCopyWith<$Res> {
  factory _$StudentTodoListModelCopyWith(_StudentTodoListModel value, $Res Function(_StudentTodoListModel) _then) = __$StudentTodoListModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String classId, String classNameLabel, String title, String? description, DateTime? dueDate, DateTime createdAt, int itemCount, int completedCount
});




}
/// @nodoc
class __$StudentTodoListModelCopyWithImpl<$Res>
    implements _$StudentTodoListModelCopyWith<$Res> {
  __$StudentTodoListModelCopyWithImpl(this._self, this._then);

  final _StudentTodoListModel _self;
  final $Res Function(_StudentTodoListModel) _then;

/// Create a copy of StudentTodoListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? classId = null,Object? classNameLabel = null,Object? title = null,Object? description = freezed,Object? dueDate = freezed,Object? createdAt = null,Object? itemCount = null,Object? completedCount = null,}) {
  return _then(_StudentTodoListModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,classNameLabel: null == classNameLabel ? _self.classNameLabel : classNameLabel // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
