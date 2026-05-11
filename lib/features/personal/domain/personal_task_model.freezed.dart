// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonalTaskModel {

 String get id; String get userId; String get title; bool get isCompleted; int get position; DateTime get createdAt; DateTime? get startDate; DateTime? get endDate; String? get groupName;
/// Create a copy of PersonalTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalTaskModelCopyWith<PersonalTaskModel> get copyWith => _$PersonalTaskModelCopyWithImpl<PersonalTaskModel>(this as PersonalTaskModel, _$identity);

  /// Serializes this PersonalTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalTaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.groupName, groupName) || other.groupName == groupName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,isCompleted,position,createdAt,startDate,endDate,groupName);

@override
String toString() {
  return 'PersonalTaskModel(id: $id, userId: $userId, title: $title, isCompleted: $isCompleted, position: $position, createdAt: $createdAt, startDate: $startDate, endDate: $endDate, groupName: $groupName)';
}


}

/// @nodoc
abstract mixin class $PersonalTaskModelCopyWith<$Res>  {
  factory $PersonalTaskModelCopyWith(PersonalTaskModel value, $Res Function(PersonalTaskModel) _then) = _$PersonalTaskModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, bool isCompleted, int position, DateTime createdAt, DateTime? startDate, DateTime? endDate, String? groupName
});




}
/// @nodoc
class _$PersonalTaskModelCopyWithImpl<$Res>
    implements $PersonalTaskModelCopyWith<$Res> {
  _$PersonalTaskModelCopyWithImpl(this._self, this._then);

  final PersonalTaskModel _self;
  final $Res Function(PersonalTaskModel) _then;

/// Create a copy of PersonalTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? isCompleted = null,Object? position = null,Object? createdAt = null,Object? startDate = freezed,Object? endDate = freezed,Object? groupName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalTaskModel].
extension PersonalTaskModelPatterns on PersonalTaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalTaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _PersonalTaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalTaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  bool isCompleted,  int position,  DateTime createdAt,  DateTime? startDate,  DateTime? endDate,  String? groupName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalTaskModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.isCompleted,_that.position,_that.createdAt,_that.startDate,_that.endDate,_that.groupName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  bool isCompleted,  int position,  DateTime createdAt,  DateTime? startDate,  DateTime? endDate,  String? groupName)  $default,) {final _that = this;
switch (_that) {
case _PersonalTaskModel():
return $default(_that.id,_that.userId,_that.title,_that.isCompleted,_that.position,_that.createdAt,_that.startDate,_that.endDate,_that.groupName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  bool isCompleted,  int position,  DateTime createdAt,  DateTime? startDate,  DateTime? endDate,  String? groupName)?  $default,) {final _that = this;
switch (_that) {
case _PersonalTaskModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.isCompleted,_that.position,_that.createdAt,_that.startDate,_that.endDate,_that.groupName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonalTaskModel implements PersonalTaskModel {
  const _PersonalTaskModel({required this.id, required this.userId, required this.title, required this.isCompleted, required this.position, required this.createdAt, this.startDate, this.endDate, this.groupName});
  factory _PersonalTaskModel.fromJson(Map<String, dynamic> json) => _$PersonalTaskModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override final  bool isCompleted;
@override final  int position;
@override final  DateTime createdAt;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  String? groupName;

/// Create a copy of PersonalTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalTaskModelCopyWith<_PersonalTaskModel> get copyWith => __$PersonalTaskModelCopyWithImpl<_PersonalTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonalTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalTaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.groupName, groupName) || other.groupName == groupName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,isCompleted,position,createdAt,startDate,endDate,groupName);

@override
String toString() {
  return 'PersonalTaskModel(id: $id, userId: $userId, title: $title, isCompleted: $isCompleted, position: $position, createdAt: $createdAt, startDate: $startDate, endDate: $endDate, groupName: $groupName)';
}


}

/// @nodoc
abstract mixin class _$PersonalTaskModelCopyWith<$Res> implements $PersonalTaskModelCopyWith<$Res> {
  factory _$PersonalTaskModelCopyWith(_PersonalTaskModel value, $Res Function(_PersonalTaskModel) _then) = __$PersonalTaskModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, bool isCompleted, int position, DateTime createdAt, DateTime? startDate, DateTime? endDate, String? groupName
});




}
/// @nodoc
class __$PersonalTaskModelCopyWithImpl<$Res>
    implements _$PersonalTaskModelCopyWith<$Res> {
  __$PersonalTaskModelCopyWithImpl(this._self, this._then);

  final _PersonalTaskModel _self;
  final $Res Function(_PersonalTaskModel) _then;

/// Create a copy of PersonalTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? isCompleted = null,Object? position = null,Object? createdAt = null,Object? startDate = freezed,Object? endDate = freezed,Object? groupName = freezed,}) {
  return _then(_PersonalTaskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
