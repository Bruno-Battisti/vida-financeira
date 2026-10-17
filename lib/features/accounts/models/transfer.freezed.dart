// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Transfer {

 String get id; String get fromAccountId; String get toAccountId; double get amount; DateTime get date; String? get note;
/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferCopyWith<Transfer> get copyWith => _$TransferCopyWithImpl<Transfer>(this as Transfer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Transfer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transfer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fromAccountId, _this.fromAccountId) || other.fromAccountId == _this.fromAccountId)&&(identical(other.toAccountId, _this.toAccountId) || other.toAccountId == _this.toAccountId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as Transfer;
  return Object.hash(runtimeType,_this.id,_this.fromAccountId,_this.toAccountId,_this.amount,_this.date,_this.note);
}

@override
String toString() {
  final _this = this as Transfer;
  return 'Transfer(id: ${_this.id}, fromAccountId: ${_this.fromAccountId}, toAccountId: ${_this.toAccountId}, amount: ${_this.amount}, date: ${_this.date}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $TransferCopyWith<$Res>  {
  factory $TransferCopyWith(Transfer value, $Res Function(Transfer) _then) = _$TransferCopyWithImpl;
@useResult
$Res call({
 String id, String fromAccountId, String toAccountId, double amount, DateTime date, String? note
});




}
/// @nodoc
class _$TransferCopyWithImpl<$Res>
    implements $TransferCopyWith<$Res> {
  _$TransferCopyWithImpl(this._self, this._then);

  final Transfer _self;
  final $Res Function(Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromAccountId = null,Object? toAccountId = null,Object? amount = null,Object? date = null,Object? note = freezed,}) {
  return _then(Transfer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromAccountId: null == fromAccountId ? _self.fromAccountId : fromAccountId // ignore: cast_nullable_to_non_nullable
as String,toAccountId: null == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Transfer].
extension TransferPatterns on Transfer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transfer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transfer value)  $default,){
final _that = this;
switch (_that) {
case _Transfer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transfer value)?  $default,){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fromAccountId,  String toAccountId,  double amount,  DateTime date,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.id,_that.fromAccountId,_that.toAccountId,_that.amount,_that.date,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fromAccountId,  String toAccountId,  double amount,  DateTime date,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Transfer():
return $default(_that.id,_that.fromAccountId,_that.toAccountId,_that.amount,_that.date,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fromAccountId,  String toAccountId,  double amount,  DateTime date,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.id,_that.fromAccountId,_that.toAccountId,_that.amount,_that.date,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _Transfer implements Transfer {
  const _Transfer({required this.id, required this.fromAccountId, required this.toAccountId, required this.amount, required this.date, this.note});
  

@override final  String id;
@override final  String fromAccountId;
@override final  String toAccountId;
@override final  double amount;
@override final  DateTime date;
@override final  String? note;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferCopyWith<_Transfer> get copyWith => __$TransferCopyWithImpl<_Transfer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transfer&&(identical(other.id, id) || other.id == id)&&(identical(other.fromAccountId, fromAccountId) || other.fromAccountId == fromAccountId)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,fromAccountId,toAccountId,amount,date,note);
}

@override
String toString() {
    return 'Transfer(id: $id, fromAccountId: $fromAccountId, toAccountId: $toAccountId, amount: $amount, date: $date, note: $note)';
}


}

/// @nodoc
abstract mixin class _$TransferCopyWith<$Res> implements $TransferCopyWith<$Res> {
  factory _$TransferCopyWith(_Transfer value, $Res Function(_Transfer) _then) = __$TransferCopyWithImpl;
@override @useResult
$Res call({
 String id, String fromAccountId, String toAccountId, double amount, DateTime date, String? note
});




}
/// @nodoc
class __$TransferCopyWithImpl<$Res>
    implements _$TransferCopyWith<$Res> {
  __$TransferCopyWithImpl(this._self, this._then);

  final _Transfer _self;
  final $Res Function(_Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromAccountId = null,Object? toAccountId = null,Object? amount = null,Object? date = null,Object? note = freezed,}) {
  return _then(_Transfer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromAccountId: null == fromAccountId ? _self.fromAccountId : fromAccountId // ignore: cast_nullable_to_non_nullable
as String,toAccountId: null == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
