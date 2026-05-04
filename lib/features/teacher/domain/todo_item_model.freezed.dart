// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoItemModel {

 String get id; String get listId; String get title; String? get description; DateTime? get dueDate; int get position; DateTime get createdAt; int get completionCount;
/// Create a copy of TodoItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoItemModelCopyWith<TodoItemModel> get copyWith => _$TodoItemModelCopyWithImpl<TodoItemModel>(this as TodoItemModel, _$identity);

  /// Serializes this TodoItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completionCount, completionCount) || other.completionCount == completionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,listId,title,description,dueDate,position,createdAt,completionCount);

@override
String toString() {
  return 'TodoItemModel(id: $id, listId: $listId, title: $title, description: $description, dueDate: $dueDate, position: $position, createdAt: $createdAt, completionCount: $completionCount)';
}


}

/// @nodoc
abstract mixin class $TodoItemModelCopyWith<$Res>  {
  factory $TodoItemModelCopyWith(TodoItemModel value, $Res Function(TodoItemModel) _then) = _$TodoItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String listId, String title, String? description, DateTime? dueDate, int position, DateTime createdAt, int completionCount
});




}
/// @nodoc
class _$TodoItemModelCopyWithImpl<$Res>
    implements $TodoItemModelCopyWith<$Res> {
  _$TodoItemModelCopyWithImpl(this._self, this._then);

  final TodoItemModel _self;
  final $Res Function(TodoItemModel) _then;

/// Create a copy of TodoItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? listId = null,Object? title = null,Object? description = freezed,Object? dueDate = freezed,Object? position = null,Object? createdAt = null,Object? completionCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listId: null == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completionCount: null == completionCount ? _self.completionCount : completionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TodoItemModel].
extension TodoItemModelPatterns on TodoItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodoItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodoItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodoItemModel value)  $default,){
final _that = this;
switch (_that) {
case _TodoItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodoItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _TodoItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String listId,  String title,  String? description,  DateTime? dueDate,  int position,  DateTime createdAt,  int completionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodoItemModel() when $default != null:
return $default(_that.id,_that.listId,_that.title,_that.description,_that.dueDate,_that.position,_that.createdAt,_that.completionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String listId,  String title,  String? description,  DateTime? dueDate,  int position,  DateTime createdAt,  int completionCount)  $default,) {final _that = this;
switch (_that) {
case _TodoItemModel():
return $default(_that.id,_that.listId,_that.title,_that.description,_that.dueDate,_that.position,_that.createdAt,_that.completionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String listId,  String title,  String? description,  DateTime? dueDate,  int position,  DateTime createdAt,  int completionCount)?  $default,) {final _that = this;
switch (_that) {
case _TodoItemModel() when $default != null:
return $default(_that.id,_that.listId,_that.title,_that.description,_that.dueDate,_that.position,_that.createdAt,_that.completionCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodoItemModel implements TodoItemModel {
  const _TodoItemModel({required this.id, required this.listId, required this.title, this.description, this.dueDate, required this.position, required this.createdAt, this.completionCount = 0});
  factory _TodoItemModel.fromJson(Map<String, dynamic> json) => _$TodoItemModelFromJson(json);

@override final  String id;
@override final  String listId;
@override final  String title;
@override final  String? description;
@override final  DateTime? dueDate;
@override final  int position;
@override final  DateTime createdAt;
@override@JsonKey() final  int completionCount;

/// Create a copy of TodoItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoItemModelCopyWith<_TodoItemModel> get copyWith => __$TodoItemModelCopyWithImpl<_TodoItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodoItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completionCount, completionCount) || other.completionCount == completionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,listId,title,description,dueDate,position,createdAt,completionCount);

@override
String toString() {
  return 'TodoItemModel(id: $id, listId: $listId, title: $title, description: $description, dueDate: $dueDate, position: $position, createdAt: $createdAt, completionCount: $completionCount)';
}


}

/// @nodoc
abstract mixin class _$TodoItemModelCopyWith<$Res> implements $TodoItemModelCopyWith<$Res> {
  factory _$TodoItemModelCopyWith(_TodoItemModel value, $Res Function(_TodoItemModel) _then) = __$TodoItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String listId, String title, String? description, DateTime? dueDate, int position, DateTime createdAt, int completionCount
});




}
/// @nodoc
class __$TodoItemModelCopyWithImpl<$Res>
    implements _$TodoItemModelCopyWith<$Res> {
  __$TodoItemModelCopyWithImpl(this._self, this._then);

  final _TodoItemModel _self;
  final $Res Function(_TodoItemModel) _then;

/// Create a copy of TodoItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? listId = null,Object? title = null,Object? description = freezed,Object? dueDate = freezed,Object? position = null,Object? createdAt = null,Object? completionCount = null,}) {
  return _then(_TodoItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listId: null == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completionCount: null == completionCount ? _self.completionCount : completionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
