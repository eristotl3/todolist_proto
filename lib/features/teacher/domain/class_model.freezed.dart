// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'class_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClassModel {

 String get id; String get name; String get code; String get teacherId; DateTime get createdAt; int get studentCount; int get listCount;
/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassModelCopyWith<ClassModel> get copyWith => _$ClassModelCopyWithImpl<ClassModel>(this as ClassModel, _$identity);

  /// Serializes this ClassModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.studentCount, studentCount) || other.studentCount == studentCount)&&(identical(other.listCount, listCount) || other.listCount == listCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,teacherId,createdAt,studentCount,listCount);

@override
String toString() {
  return 'ClassModel(id: $id, name: $name, code: $code, teacherId: $teacherId, createdAt: $createdAt, studentCount: $studentCount, listCount: $listCount)';
}


}

/// @nodoc
abstract mixin class $ClassModelCopyWith<$Res>  {
  factory $ClassModelCopyWith(ClassModel value, $Res Function(ClassModel) _then) = _$ClassModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String code, String teacherId, DateTime createdAt, int studentCount, int listCount
});




}
/// @nodoc
class _$ClassModelCopyWithImpl<$Res>
    implements $ClassModelCopyWith<$Res> {
  _$ClassModelCopyWithImpl(this._self, this._then);

  final ClassModel _self;
  final $Res Function(ClassModel) _then;

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? code = null,Object? teacherId = null,Object? createdAt = null,Object? studentCount = null,Object? listCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,studentCount: null == studentCount ? _self.studentCount : studentCount // ignore: cast_nullable_to_non_nullable
as int,listCount: null == listCount ? _self.listCount : listCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassModel].
extension ClassModelPatterns on ClassModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassModel value)  $default,){
final _that = this;
switch (_that) {
case _ClassModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassModel value)?  $default,){
final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String code,  String teacherId,  DateTime createdAt,  int studentCount,  int listCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.teacherId,_that.createdAt,_that.studentCount,_that.listCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String code,  String teacherId,  DateTime createdAt,  int studentCount,  int listCount)  $default,) {final _that = this;
switch (_that) {
case _ClassModel():
return $default(_that.id,_that.name,_that.code,_that.teacherId,_that.createdAt,_that.studentCount,_that.listCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String code,  String teacherId,  DateTime createdAt,  int studentCount,  int listCount)?  $default,) {final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.teacherId,_that.createdAt,_that.studentCount,_that.listCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassModel implements ClassModel {
  const _ClassModel({required this.id, required this.name, required this.code, required this.teacherId, required this.createdAt, this.studentCount = 0, this.listCount = 0});
  factory _ClassModel.fromJson(Map<String, dynamic> json) => _$ClassModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String code;
@override final  String teacherId;
@override final  DateTime createdAt;
@override@JsonKey() final  int studentCount;
@override@JsonKey() final  int listCount;

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassModelCopyWith<_ClassModel> get copyWith => __$ClassModelCopyWithImpl<_ClassModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.studentCount, studentCount) || other.studentCount == studentCount)&&(identical(other.listCount, listCount) || other.listCount == listCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,teacherId,createdAt,studentCount,listCount);

@override
String toString() {
  return 'ClassModel(id: $id, name: $name, code: $code, teacherId: $teacherId, createdAt: $createdAt, studentCount: $studentCount, listCount: $listCount)';
}


}

/// @nodoc
abstract mixin class _$ClassModelCopyWith<$Res> implements $ClassModelCopyWith<$Res> {
  factory _$ClassModelCopyWith(_ClassModel value, $Res Function(_ClassModel) _then) = __$ClassModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String code, String teacherId, DateTime createdAt, int studentCount, int listCount
});




}
/// @nodoc
class __$ClassModelCopyWithImpl<$Res>
    implements _$ClassModelCopyWith<$Res> {
  __$ClassModelCopyWithImpl(this._self, this._then);

  final _ClassModel _self;
  final $Res Function(_ClassModel) _then;

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? code = null,Object? teacherId = null,Object? createdAt = null,Object? studentCount = null,Object? listCount = null,}) {
  return _then(_ClassModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,studentCount: null == studentCount ? _self.studentCount : studentCount // ignore: cast_nullable_to_non_nullable
as int,listCount: null == listCount ? _self.listCount : listCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
