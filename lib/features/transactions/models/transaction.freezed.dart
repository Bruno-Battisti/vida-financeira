// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Transaction {

 String get id; String get description; double get amount; TransactionType get type; int get categoryId; DateTime get date; String? get note;/// Data de vencimento de uma conta a pagar/receber ainda pendente.
 DateTime? get dueDate;/// `false` representa uma conta a pagar/receber que ainda não foi
/// liquidada — só entra nos totais e saldos quando marcada como paga.
 bool get isPaid;/// Preenchido quando a transação foi gerada automaticamente a partir de
/// uma regra de recorrência.
 String? get recurringRuleId;/// Id compartilhado por todas as parcelas de uma mesma compra parcelada.
 String? get installmentGroupId;/// Posição desta parcela (1-based) dentro do grupo de parcelamento.
 int? get installmentIndex;/// Número total de parcelas do grupo de parcelamento.
 int? get installmentTotal;/// Conta/carteira dona da transação. `null` em transações antigas,
/// criadas antes de contas existirem — contam para a conta padrão.
 String? get accountId;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Transaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.isPaid, _this.isPaid) || other.isPaid == _this.isPaid)&&(identical(other.recurringRuleId, _this.recurringRuleId) || other.recurringRuleId == _this.recurringRuleId)&&(identical(other.installmentGroupId, _this.installmentGroupId) || other.installmentGroupId == _this.installmentGroupId)&&(identical(other.installmentIndex, _this.installmentIndex) || other.installmentIndex == _this.installmentIndex)&&(identical(other.installmentTotal, _this.installmentTotal) || other.installmentTotal == _this.installmentTotal)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId));
}


@override
int get hashCode {
  final _this = this as Transaction;
  return Object.hash(runtimeType,_this.id,_this.description,_this.amount,_this.type,_this.categoryId,_this.date,_this.note,_this.dueDate,_this.isPaid,_this.recurringRuleId,_this.installmentGroupId,_this.installmentIndex,_this.installmentTotal,_this.accountId);
}

@override
String toString() {
  final _this = this as Transaction;
  return 'Transaction(id: ${_this.id}, description: ${_this.description}, amount: ${_this.amount}, type: ${_this.type}, categoryId: ${_this.categoryId}, date: ${_this.date}, note: ${_this.note}, dueDate: ${_this.dueDate}, isPaid: ${_this.isPaid}, recurringRuleId: ${_this.recurringRuleId}, installmentGroupId: ${_this.installmentGroupId}, installmentIndex: ${_this.installmentIndex}, installmentTotal: ${_this.installmentTotal}, accountId: ${_this.accountId})';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 String id, String description, double amount, TransactionType type, int categoryId, DateTime date, String? note, DateTime? dueDate, bool isPaid, String? recurringRuleId, String? installmentGroupId, int? installmentIndex, int? installmentTotal, String? accountId
});




}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? amount = null,Object? type = null,Object? categoryId = null,Object? date = null,Object? note = freezed,Object? dueDate = freezed,Object? isPaid = null,Object? recurringRuleId = freezed,Object? installmentGroupId = freezed,Object? installmentIndex = freezed,Object? installmentTotal = freezed,Object? accountId = freezed,}) {
  return _then(Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,recurringRuleId: freezed == recurringRuleId ? _self.recurringRuleId : recurringRuleId // ignore: cast_nullable_to_non_nullable
as String?,installmentGroupId: freezed == installmentGroupId ? _self.installmentGroupId : installmentGroupId // ignore: cast_nullable_to_non_nullable
as String?,installmentIndex: freezed == installmentIndex ? _self.installmentIndex : installmentIndex // ignore: cast_nullable_to_non_nullable
as int?,installmentTotal: freezed == installmentTotal ? _self.installmentTotal : installmentTotal // ignore: cast_nullable_to_non_nullable
as int?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String description,  double amount,  TransactionType type,  int categoryId,  DateTime date,  String? note,  DateTime? dueDate,  bool isPaid,  String? recurringRuleId,  String? installmentGroupId,  int? installmentIndex,  int? installmentTotal,  String? accountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.description,_that.amount,_that.type,_that.categoryId,_that.date,_that.note,_that.dueDate,_that.isPaid,_that.recurringRuleId,_that.installmentGroupId,_that.installmentIndex,_that.installmentTotal,_that.accountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String description,  double amount,  TransactionType type,  int categoryId,  DateTime date,  String? note,  DateTime? dueDate,  bool isPaid,  String? recurringRuleId,  String? installmentGroupId,  int? installmentIndex,  int? installmentTotal,  String? accountId)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.id,_that.description,_that.amount,_that.type,_that.categoryId,_that.date,_that.note,_that.dueDate,_that.isPaid,_that.recurringRuleId,_that.installmentGroupId,_that.installmentIndex,_that.installmentTotal,_that.accountId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String description,  double amount,  TransactionType type,  int categoryId,  DateTime date,  String? note,  DateTime? dueDate,  bool isPaid,  String? recurringRuleId,  String? installmentGroupId,  int? installmentIndex,  int? installmentTotal,  String? accountId)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.description,_that.amount,_that.type,_that.categoryId,_that.date,_that.note,_that.dueDate,_that.isPaid,_that.recurringRuleId,_that.installmentGroupId,_that.installmentIndex,_that.installmentTotal,_that.accountId);case _:
  return null;

}
}

}

/// @nodoc


class _Transaction implements Transaction {
  const _Transaction({required this.id, required this.description, required this.amount, required this.type, required this.categoryId, required this.date, this.note, this.dueDate, this.isPaid = true, this.recurringRuleId, this.installmentGroupId, this.installmentIndex, this.installmentTotal, this.accountId});
  

@override final  String id;
@override final  String description;
@override final  double amount;
@override final  TransactionType type;
@override final  int categoryId;
@override final  DateTime date;
@override final  String? note;
/// Data de vencimento de uma conta a pagar/receber ainda pendente.
@override final  DateTime? dueDate;
/// `false` representa uma conta a pagar/receber que ainda não foi
/// liquidada — só entra nos totais e saldos quando marcada como paga.
@override@JsonKey() final  bool isPaid;
/// Preenchido quando a transação foi gerada automaticamente a partir de
/// uma regra de recorrência.
@override final  String? recurringRuleId;
/// Id compartilhado por todas as parcelas de uma mesma compra parcelada.
@override final  String? installmentGroupId;
/// Posição desta parcela (1-based) dentro do grupo de parcelamento.
@override final  int? installmentIndex;
/// Número total de parcelas do grupo de parcelamento.
@override final  int? installmentTotal;
/// Conta/carteira dona da transação. `null` em transações antigas,
/// criadas antes de contas existirem — contam para a conta padrão.
@override final  String? accountId;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.recurringRuleId, recurringRuleId) || other.recurringRuleId == recurringRuleId)&&(identical(other.installmentGroupId, installmentGroupId) || other.installmentGroupId == installmentGroupId)&&(identical(other.installmentIndex, installmentIndex) || other.installmentIndex == installmentIndex)&&(identical(other.installmentTotal, installmentTotal) || other.installmentTotal == installmentTotal)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,description,amount,type,categoryId,date,note,dueDate,isPaid,recurringRuleId,installmentGroupId,installmentIndex,installmentTotal,accountId);
}

@override
String toString() {
    return 'Transaction(id: $id, description: $description, amount: $amount, type: $type, categoryId: $categoryId, date: $date, note: $note, dueDate: $dueDate, isPaid: $isPaid, recurringRuleId: $recurringRuleId, installmentGroupId: $installmentGroupId, installmentIndex: $installmentIndex, installmentTotal: $installmentTotal, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String description, double amount, TransactionType type, int categoryId, DateTime date, String? note, DateTime? dueDate, bool isPaid, String? recurringRuleId, String? installmentGroupId, int? installmentIndex, int? installmentTotal, String? accountId
});




}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? amount = null,Object? type = null,Object? categoryId = null,Object? date = null,Object? note = freezed,Object? dueDate = freezed,Object? isPaid = null,Object? recurringRuleId = freezed,Object? installmentGroupId = freezed,Object? installmentIndex = freezed,Object? installmentTotal = freezed,Object? accountId = freezed,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,recurringRuleId: freezed == recurringRuleId ? _self.recurringRuleId : recurringRuleId // ignore: cast_nullable_to_non_nullable
as String?,installmentGroupId: freezed == installmentGroupId ? _self.installmentGroupId : installmentGroupId // ignore: cast_nullable_to_non_nullable
as String?,installmentIndex: freezed == installmentIndex ? _self.installmentIndex : installmentIndex // ignore: cast_nullable_to_non_nullable
as int?,installmentTotal: freezed == installmentTotal ? _self.installmentTotal : installmentTotal // ignore: cast_nullable_to_non_nullable
as int?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
