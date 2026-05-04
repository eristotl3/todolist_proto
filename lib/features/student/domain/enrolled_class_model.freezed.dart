// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrolled_class_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnrolledClassModel {

 String get id; String get name; String get code; String get teacherId; DateTime get createdAt;
/// Create a copy of EnrolledClassModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrolledClassModelCopyWith<EnrolledClassModel> get copyWith => _$EnrolledClassModelCopyWithImpl<EnrolledClassModel>(this as EnrolledClassModel, _$identity);

  /// Serializes this EnrolledClassModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrolledClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,teacherId,createdAt);

@override
String toString() {
  return 'EnrolledClassModel(id: $id, name: $name, code: $code, teacherId: $teacherId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EnrolledClassModelCopyWith<$Res>  {
  factory $EnrolledClassModelCopyWith(EnrolledClassModel value, $Res Function(EnrolledClassModel) _then) = _$EnrolledClassModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String code, String teacherId, DateTime createdAt
});




}
/// @nodoc
class _$EnrolledClassModelCopyWithImpl<$Res>
    implements $EnrolledClassModelCopyWith<$Res> {
  _$EnrolledClassModelCopyWithImpl(this._self, this._then);

  final EnrolledClassModel _self;
  final $Res Function(EnrolledClassModel) _then;

/// Create a copy of EnrolledClassModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? code = null,Object? teacherId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EnrolledClassModel].
extension EnrolledClassModelPatterns on EnrolledClassModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnrolledClassModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnrolledClassModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnrolledClassModel value)  $default,){
final _that = this;
switch (_that) {
case _EnrolledClassModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnrolledClassModel value)?  $default,){
final _that = this;
switch (_that) {
case _EnrolledClassModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String code,  String teacherId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnrolledClassModel() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.teacherId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String code,  String teacherId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _EnrolledClassModel():
return $default(_that.id,_that.name,_that.code,_that.teacherId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String code,  String teacherId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EnrolledClassModel() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.teacherId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnrolledClassModel implements EnrolledClassModel {
  const _EnrolledClassModel({required this.id, required this.name, required this.code, required this.teacherId, required this.createdAt});
  factory _EnrolledClassModel.fromJson(Map<String, dynamic> json) => _$EnrolledClassModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String code;
@override final  String teacherId;
@override final  DateTime createdAt;

/// Create a copy of EnrolledClassModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnrolledClassModelCopyWith<_EnrolledClassModel> get copyWith => __$EnrolledClassModelCopyWithImpl<_EnrolledClassModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnrolledClassModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrolledClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,teacherId,createdAt);

@override
String toString() {
  return 'EnrolledClassModel(id: $id, name: $name, code: $code, teacherId: $teacherId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EnrolledClassModelCopyWith<$Res> implements $EnrolledClassModelCopyWith<$Res> {
  factory _$EnrolledClassModelCopyWith(_EnrolledClassModel value, $Res Function(_EnrolledClassModel) _then) = __$EnrolledClassModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String code, String teacherId, DateTime createdAt
});




}
/// @nodoc
class __$EnrolledClassModelCopyWithImpl<$Res>
    implements _$EnrolledClassModelCopyWith<$Res> {
  __$EnrolledClassModelCopyWithImpl(this._self, this._then);

  final _EnrolledClassModel _self;
  final $Res Function(_EnrolledClassModel) _then;

/// Create a copy of EnrolledClassModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? code = null,Object? teacherId = null,Object? createdAt = null,}) {
  return _then(_EnrolledClassModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
