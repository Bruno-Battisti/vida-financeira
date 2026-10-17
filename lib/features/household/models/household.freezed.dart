// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Household {

 String get ownerUid; List<String> get memberUids;
/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdCopyWith<Household> get copyWith => _$HouseholdCopyWithImpl<Household>(this as Household, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Household;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Household&&(identical(other.ownerUid, _this.ownerUid) || other.ownerUid == _this.ownerUid)&&const DeepCollectionEquality().equals(other.memberUids, _this.memberUids));
}


@override
int get hashCode {
  final _this = this as Household;
  return Object.hash(runtimeType,_this.ownerUid,const DeepCollectionEquality().hash(_this.memberUids));
}

@override
String toString() {
  final _this = this as Household;
  return 'Household(ownerUid: ${_this.ownerUid}, memberUids: ${_this.memberUids})';
}


}

/// @nodoc
abstract mixin class $HouseholdCopyWith<$Res>  {
  factory $HouseholdCopyWith(Household value, $Res Function(Household) _then) = _$HouseholdCopyWithImpl;
@useResult
$Res call({
 String ownerUid, List<String> memberUids
});




}
/// @nodoc
class _$HouseholdCopyWithImpl<$Res>
    implements $HouseholdCopyWith<$Res> {
  _$HouseholdCopyWithImpl(this._self, this._then);

  final Household _self;
  final $Res Function(Household) _then;

/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ownerUid = null,Object? memberUids = null,}) {
  return _then(Household(
ownerUid: null == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as String,memberUids: null == memberUids ? _self.memberUids : memberUids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Household].
extension HouseholdPatterns on Household {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Household value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Household() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Household value)  $default,){
final _that = this;
switch (_that) {
case _Household():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Household value)?  $default,){
final _that = this;
switch (_that) {
case _Household() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ownerUid,  List<String> memberUids)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Household() when $default != null:
return $default(_that.ownerUid,_that.memberUids);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ownerUid,  List<String> memberUids)  $default,) {final _that = this;
switch (_that) {
case _Household():
return $default(_that.ownerUid,_that.memberUids);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ownerUid,  List<String> memberUids)?  $default,) {final _that = this;
switch (_that) {
case _Household() when $default != null:
return $default(_that.ownerUid,_that.memberUids);case _:
  return null;

}
}

}

/// @nodoc


class _Household implements Household {
  const _Household({required this.ownerUid, required  List<String> memberUids}): _memberUids = memberUids;
  

@override final  String ownerUid;
 final  List<String> _memberUids;
@override List<String> get memberUids {
  if (_memberUids is EqualUnmodifiableListView) return _memberUids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberUids);
}


/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseholdCopyWith<_Household> get copyWith => __$HouseholdCopyWithImpl<_Household>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Household&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&const DeepCollectionEquality().equals(other.memberUids, _memberUids));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ownerUid,const DeepCollectionEquality().hash(_memberUids));
}

@override
String toString() {
    return 'Household(ownerUid: $ownerUid, memberUids: $memberUids)';
}


}

/// @nodoc
abstract mixin class _$HouseholdCopyWith<$Res> implements $HouseholdCopyWith<$Res> {
  factory _$HouseholdCopyWith(_Household value, $Res Function(_Household) _then) = __$HouseholdCopyWithImpl;
@override @useResult
$Res call({
 String ownerUid, List<String> memberUids
});




}
/// @nodoc
class __$HouseholdCopyWithImpl<$Res>
    implements _$HouseholdCopyWith<$Res> {
  __$HouseholdCopyWithImpl(this._self, this._then);

  final _Household _self;
  final $Res Function(_Household) _then;

/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ownerUid = null,Object? memberUids = null,}) {
  return _then(_Household(
ownerUid: null == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as String,memberUids: null == memberUids ? _self._memberUids : memberUids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
