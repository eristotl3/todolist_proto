// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completion_matrix_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompletionMatrixState {

 List<StudentSummary> get students; List<TodoItemModel> get items;// Set of "itemId:studentId" pairs
 Set<String> get completedPairs;
/// Create a copy of CompletionMatrixState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompletionMatrixStateCopyWith<CompletionMatrixState> get copyWith => _$CompletionMatrixStateCopyWithImpl<CompletionMatrixState>(this as CompletionMatrixState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompletionMatrixState&&const DeepCollectionEquality().equals(other.students, students)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.completedPairs, completedPairs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(students),const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(completedPairs));

@override
String toString() {
  return 'CompletionMatrixState(students: $students, items: $items, completedPairs: $completedPairs)';
}


}

/// @nodoc
abstract mixin class $CompletionMatrixStateCopyWith<$Res>  {
  factory $CompletionMatrixStateCopyWith(CompletionMatrixState value, $Res Function(CompletionMatrixState) _then) = _$CompletionMatrixStateCopyWithImpl;
@useResult
$Res call({
 List<StudentSummary> students, List<TodoItemModel> items, Set<String> completedPairs
});




}
/// @nodoc
class _$CompletionMatrixStateCopyWithImpl<$Res>
    implements $CompletionMatrixStateCopyWith<$Res> {
  _$CompletionMatrixStateCopyWithImpl(this._self, this._then);

  final CompletionMatrixState _self;
  final $Res Function(CompletionMatrixState) _then;

/// Create a copy of CompletionMatrixState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? students = null,Object? items = null,Object? completedPairs = null,}) {
  return _then(_self.copyWith(
students: null == students ? _self.students : students // ignore: cast_nullable_to_non_nullable
as List<StudentSummary>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TodoItemModel>,completedPairs: null == completedPairs ? _self.completedPairs : completedPairs // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CompletionMatrixState].
extension CompletionMatrixStatePatterns on CompletionMatrixState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompletionMatrixState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompletionMatrixState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompletionMatrixState value)  $default,){
final _that = this;
switch (_that) {
case _CompletionMatrixState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompletionMatrixState value)?  $default,){
final _that = this;
switch (_that) {
case _CompletionMatrixState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StudentSummary> students,  List<TodoItemModel> items,  Set<String> completedPairs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompletionMatrixState() when $default != null:
return $default(_that.students,_that.items,_that.completedPairs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StudentSummary> students,  List<TodoItemModel> items,  Set<String> completedPairs)  $default,) {final _that = this;
switch (_that) {
case _CompletionMatrixState():
return $default(_that.students,_that.items,_that.completedPairs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StudentSummary> students,  List<TodoItemModel> items,  Set<String> completedPairs)?  $default,) {final _that = this;
switch (_that) {
case _CompletionMatrixState() when $default != null:
return $default(_that.students,_that.items,_that.completedPairs);case _:
  return null;

}
}

}

/// @nodoc


class _CompletionMatrixState extends CompletionMatrixState {
  const _CompletionMatrixState({required final  List<StudentSummary> students, required final  List<TodoItemModel> items, required final  Set<String> completedPairs}): _students = students,_items = items,_completedPairs = completedPairs,super._();
  

 final  List<StudentSummary> _students;
@override List<StudentSummary> get students {
  if (_students is EqualUnmodifiableListView) return _students;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_students);
}

 final  List<TodoItemModel> _items;
@override List<TodoItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

// Set of "itemId:studentId" pairs
 final  Set<String> _completedPairs;
// Set of "itemId:studentId" pairs
@override Set<String> get completedPairs {
  if (_completedPairs is EqualUnmodifiableSetView) return _completedPairs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_completedPairs);
}


/// Create a copy of CompletionMatrixState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletionMatrixStateCopyWith<_CompletionMatrixState> get copyWith => __$CompletionMatrixStateCopyWithImpl<_CompletionMatrixState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompletionMatrixState&&const DeepCollectionEquality().equals(other._students, _students)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._completedPairs, _completedPairs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_students),const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_completedPairs));

@override
String toString() {
  return 'CompletionMatrixState(students: $students, items: $items, completedPairs: $completedPairs)';
}


}

/// @nodoc
abstract mixin class _$CompletionMatrixStateCopyWith<$Res> implements $CompletionMatrixStateCopyWith<$Res> {
  factory _$CompletionMatrixStateCopyWith(_CompletionMatrixState value, $Res Function(_CompletionMatrixState) _then) = __$CompletionMatrixStateCopyWithImpl;
@override @useResult
$Res call({
 List<StudentSummary> students, List<TodoItemModel> items, Set<String> completedPairs
});




}
/// @nodoc
class __$CompletionMatrixStateCopyWithImpl<$Res>
    implements _$CompletionMatrixStateCopyWith<$Res> {
  __$CompletionMatrixStateCopyWithImpl(this._self, this._then);

  final _CompletionMatrixState _self;
  final $Res Function(_CompletionMatrixState) _then;

/// Create a copy of CompletionMatrixState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? students = null,Object? items = null,Object? completedPairs = null,}) {
  return _then(_CompletionMatrixState(
students: null == students ? _self._students : students // ignore: cast_nullable_to_non_nullable
as List<StudentSummary>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TodoItemModel>,completedPairs: null == completedPairs ? _self._completedPairs : completedPairs // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
