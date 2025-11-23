// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trupp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Trupp {

 int get number; String? get callName; String? get leaderName; String? get memberName;
/// Create a copy of Trupp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruppCopyWith<Trupp> get copyWith => _$TruppCopyWithImpl<Trupp>(this as Trupp, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trupp&&(identical(other.number, number) || other.number == number)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.leaderName, leaderName) || other.leaderName == leaderName)&&(identical(other.memberName, memberName) || other.memberName == memberName));
}


@override
int get hashCode => Object.hash(runtimeType,number,callName,leaderName,memberName);

@override
String toString() {
  return 'Trupp(number: $number, callName: $callName, leaderName: $leaderName, memberName: $memberName)';
}


}

/// @nodoc
abstract mixin class $TruppCopyWith<$Res>  {
  factory $TruppCopyWith(Trupp value, $Res Function(Trupp) _then) = _$TruppCopyWithImpl;
@useResult
$Res call({
 int number, String callName, String leaderName, String memberName
});




}
/// @nodoc
class _$TruppCopyWithImpl<$Res>
    implements $TruppCopyWith<$Res> {
  _$TruppCopyWithImpl(this._self, this._then);

  final Trupp _self;
  final $Res Function(Trupp) _then;

/// Create a copy of Trupp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? callName = null,Object? leaderName = null,Object? memberName = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,callName: null == callName ? _self.callName! : callName // ignore: cast_nullable_to_non_nullable
as String,leaderName: null == leaderName ? _self.leaderName! : leaderName // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName! : memberName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Trupp].
extension TruppPatterns on Trupp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TruppAction value)?  action,TResult Function( TruppForm value)?  form,TResult Function( TruppEnd value)?  end,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TruppAction() when action != null:
return action(_that);case TruppForm() when form != null:
return form(_that);case TruppEnd() when end != null:
return end(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TruppAction value)  action,required TResult Function( TruppForm value)  form,required TResult Function( TruppEnd value)  end,}){
final _that = this;
switch (_that) {
case TruppAction():
return action(_that);case TruppForm():
return form(_that);case TruppEnd():
return end(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TruppAction value)?  action,TResult? Function( TruppForm value)?  form,TResult? Function( TruppEnd value)?  end,}){
final _that = this;
switch (_that) {
case TruppAction() when action != null:
return action(_that);case TruppForm() when form != null:
return form(_that);case TruppEnd() when end != null:
return end(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int number,  String callName,  String leaderName,  String memberName,  List<HistoryEntry> history,  Duration sinceStart,  Duration? potentialEnd,  Duration theoreticalEnd,  Duration nextCheck,  int lowestPressure,  int lowestStartPressure,  int maxPressure)?  action,TResult Function( int number,  String? callName,  String? leaderName,  String? memberName,  int? leaderPressure,  int? memberPressure,  Duration? theoreticalDuration,  int? maxPressure)?  form,TResult Function( int number,  String callName,  String leaderName,  String memberName,  List<HistoryEntry> history,  Duration inAction)?  end,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TruppAction() when action != null:
return action(_that.number,_that.callName,_that.leaderName,_that.memberName,_that.history,_that.sinceStart,_that.potentialEnd,_that.theoreticalEnd,_that.nextCheck,_that.lowestPressure,_that.lowestStartPressure,_that.maxPressure);case TruppForm() when form != null:
return form(_that.number,_that.callName,_that.leaderName,_that.memberName,_that.leaderPressure,_that.memberPressure,_that.theoreticalDuration,_that.maxPressure);case TruppEnd() when end != null:
return end(_that.number,_that.callName,_that.leaderName,_that.memberName,_that.history,_that.inAction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int number,  String callName,  String leaderName,  String memberName,  List<HistoryEntry> history,  Duration sinceStart,  Duration? potentialEnd,  Duration theoreticalEnd,  Duration nextCheck,  int lowestPressure,  int lowestStartPressure,  int maxPressure)  action,required TResult Function( int number,  String? callName,  String? leaderName,  String? memberName,  int? leaderPressure,  int? memberPressure,  Duration? theoreticalDuration,  int? maxPressure)  form,required TResult Function( int number,  String callName,  String leaderName,  String memberName,  List<HistoryEntry> history,  Duration inAction)  end,}) {final _that = this;
switch (_that) {
case TruppAction():
return action(_that.number,_that.callName,_that.leaderName,_that.memberName,_that.history,_that.sinceStart,_that.potentialEnd,_that.theoreticalEnd,_that.nextCheck,_that.lowestPressure,_that.lowestStartPressure,_that.maxPressure);case TruppForm():
return form(_that.number,_that.callName,_that.leaderName,_that.memberName,_that.leaderPressure,_that.memberPressure,_that.theoreticalDuration,_that.maxPressure);case TruppEnd():
return end(_that.number,_that.callName,_that.leaderName,_that.memberName,_that.history,_that.inAction);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int number,  String callName,  String leaderName,  String memberName,  List<HistoryEntry> history,  Duration sinceStart,  Duration? potentialEnd,  Duration theoreticalEnd,  Duration nextCheck,  int lowestPressure,  int lowestStartPressure,  int maxPressure)?  action,TResult? Function( int number,  String? callName,  String? leaderName,  String? memberName,  int? leaderPressure,  int? memberPressure,  Duration? theoreticalDuration,  int? maxPressure)?  form,TResult? Function( int number,  String callName,  String leaderName,  String memberName,  List<HistoryEntry> history,  Duration inAction)?  end,}) {final _that = this;
switch (_that) {
case TruppAction() when action != null:
return action(_that.number,_that.callName,_that.leaderName,_that.memberName,_that.history,_that.sinceStart,_that.potentialEnd,_that.theoreticalEnd,_that.nextCheck,_that.lowestPressure,_that.lowestStartPressure,_that.maxPressure);case TruppForm() when form != null:
return form(_that.number,_that.callName,_that.leaderName,_that.memberName,_that.leaderPressure,_that.memberPressure,_that.theoreticalDuration,_that.maxPressure);case TruppEnd() when end != null:
return end(_that.number,_that.callName,_that.leaderName,_that.memberName,_that.history,_that.inAction);case _:
  return null;

}
}

}

/// @nodoc


class TruppAction implements Trupp {
  const TruppAction({required this.number, required this.callName, required this.leaderName, required this.memberName, final  List<HistoryEntry> history = const [], required this.sinceStart, this.potentialEnd, required this.theoreticalEnd, required this.nextCheck, required this.lowestPressure, required this.lowestStartPressure, required this.maxPressure}): _history = history;
  

@override final  int number;
@override final  String callName;
@override final  String leaderName;
@override final  String memberName;
 final  List<HistoryEntry> _history;
@JsonKey() List<HistoryEntry> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

 final  Duration sinceStart;
 final  Duration? potentialEnd;
 final  Duration theoreticalEnd;
 final  Duration nextCheck;
 final  int lowestPressure;
 final  int lowestStartPressure;
 final  int maxPressure;

/// Create a copy of Trupp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruppActionCopyWith<TruppAction> get copyWith => _$TruppActionCopyWithImpl<TruppAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruppAction&&(identical(other.number, number) || other.number == number)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.leaderName, leaderName) || other.leaderName == leaderName)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.sinceStart, sinceStart) || other.sinceStart == sinceStart)&&(identical(other.potentialEnd, potentialEnd) || other.potentialEnd == potentialEnd)&&(identical(other.theoreticalEnd, theoreticalEnd) || other.theoreticalEnd == theoreticalEnd)&&(identical(other.nextCheck, nextCheck) || other.nextCheck == nextCheck)&&(identical(other.lowestPressure, lowestPressure) || other.lowestPressure == lowestPressure)&&(identical(other.lowestStartPressure, lowestStartPressure) || other.lowestStartPressure == lowestStartPressure)&&(identical(other.maxPressure, maxPressure) || other.maxPressure == maxPressure));
}


@override
int get hashCode => Object.hash(runtimeType,number,callName,leaderName,memberName,const DeepCollectionEquality().hash(_history),sinceStart,potentialEnd,theoreticalEnd,nextCheck,lowestPressure,lowestStartPressure,maxPressure);

@override
String toString() {
  return 'Trupp.action(number: $number, callName: $callName, leaderName: $leaderName, memberName: $memberName, history: $history, sinceStart: $sinceStart, potentialEnd: $potentialEnd, theoreticalEnd: $theoreticalEnd, nextCheck: $nextCheck, lowestPressure: $lowestPressure, lowestStartPressure: $lowestStartPressure, maxPressure: $maxPressure)';
}


}

/// @nodoc
abstract mixin class $TruppActionCopyWith<$Res> implements $TruppCopyWith<$Res> {
  factory $TruppActionCopyWith(TruppAction value, $Res Function(TruppAction) _then) = _$TruppActionCopyWithImpl;
@override @useResult
$Res call({
 int number, String callName, String leaderName, String memberName, List<HistoryEntry> history, Duration sinceStart, Duration? potentialEnd, Duration theoreticalEnd, Duration nextCheck, int lowestPressure, int lowestStartPressure, int maxPressure
});




}
/// @nodoc
class _$TruppActionCopyWithImpl<$Res>
    implements $TruppActionCopyWith<$Res> {
  _$TruppActionCopyWithImpl(this._self, this._then);

  final TruppAction _self;
  final $Res Function(TruppAction) _then;

/// Create a copy of Trupp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? callName = null,Object? leaderName = null,Object? memberName = null,Object? history = null,Object? sinceStart = null,Object? potentialEnd = freezed,Object? theoreticalEnd = null,Object? nextCheck = null,Object? lowestPressure = null,Object? lowestStartPressure = null,Object? maxPressure = null,}) {
  return _then(TruppAction(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,callName: null == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String,leaderName: null == leaderName ? _self.leaderName : leaderName // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<HistoryEntry>,sinceStart: null == sinceStart ? _self.sinceStart : sinceStart // ignore: cast_nullable_to_non_nullable
as Duration,potentialEnd: freezed == potentialEnd ? _self.potentialEnd : potentialEnd // ignore: cast_nullable_to_non_nullable
as Duration?,theoreticalEnd: null == theoreticalEnd ? _self.theoreticalEnd : theoreticalEnd // ignore: cast_nullable_to_non_nullable
as Duration,nextCheck: null == nextCheck ? _self.nextCheck : nextCheck // ignore: cast_nullable_to_non_nullable
as Duration,lowestPressure: null == lowestPressure ? _self.lowestPressure : lowestPressure // ignore: cast_nullable_to_non_nullable
as int,lowestStartPressure: null == lowestStartPressure ? _self.lowestStartPressure : lowestStartPressure // ignore: cast_nullable_to_non_nullable
as int,maxPressure: null == maxPressure ? _self.maxPressure : maxPressure // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TruppForm implements Trupp {
  const TruppForm({required this.number, this.callName, this.leaderName, this.memberName, this.leaderPressure, this.memberPressure, this.theoreticalDuration, this.maxPressure});
  

@override final  int number;
@override final  String? callName;
@override final  String? leaderName;
@override final  String? memberName;
 final  int? leaderPressure;
 final  int? memberPressure;
 final  Duration? theoreticalDuration;
 final  int? maxPressure;

/// Create a copy of Trupp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruppFormCopyWith<TruppForm> get copyWith => _$TruppFormCopyWithImpl<TruppForm>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruppForm&&(identical(other.number, number) || other.number == number)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.leaderName, leaderName) || other.leaderName == leaderName)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.leaderPressure, leaderPressure) || other.leaderPressure == leaderPressure)&&(identical(other.memberPressure, memberPressure) || other.memberPressure == memberPressure)&&(identical(other.theoreticalDuration, theoreticalDuration) || other.theoreticalDuration == theoreticalDuration)&&(identical(other.maxPressure, maxPressure) || other.maxPressure == maxPressure));
}


@override
int get hashCode => Object.hash(runtimeType,number,callName,leaderName,memberName,leaderPressure,memberPressure,theoreticalDuration,maxPressure);

@override
String toString() {
  return 'Trupp.form(number: $number, callName: $callName, leaderName: $leaderName, memberName: $memberName, leaderPressure: $leaderPressure, memberPressure: $memberPressure, theoreticalDuration: $theoreticalDuration, maxPressure: $maxPressure)';
}


}

/// @nodoc
abstract mixin class $TruppFormCopyWith<$Res> implements $TruppCopyWith<$Res> {
  factory $TruppFormCopyWith(TruppForm value, $Res Function(TruppForm) _then) = _$TruppFormCopyWithImpl;
@override @useResult
$Res call({
 int number, String? callName, String? leaderName, String? memberName, int? leaderPressure, int? memberPressure, Duration? theoreticalDuration, int? maxPressure
});




}
/// @nodoc
class _$TruppFormCopyWithImpl<$Res>
    implements $TruppFormCopyWith<$Res> {
  _$TruppFormCopyWithImpl(this._self, this._then);

  final TruppForm _self;
  final $Res Function(TruppForm) _then;

/// Create a copy of Trupp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? callName = freezed,Object? leaderName = freezed,Object? memberName = freezed,Object? leaderPressure = freezed,Object? memberPressure = freezed,Object? theoreticalDuration = freezed,Object? maxPressure = freezed,}) {
  return _then(TruppForm(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,callName: freezed == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String?,leaderName: freezed == leaderName ? _self.leaderName : leaderName // ignore: cast_nullable_to_non_nullable
as String?,memberName: freezed == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String?,leaderPressure: freezed == leaderPressure ? _self.leaderPressure : leaderPressure // ignore: cast_nullable_to_non_nullable
as int?,memberPressure: freezed == memberPressure ? _self.memberPressure : memberPressure // ignore: cast_nullable_to_non_nullable
as int?,theoreticalDuration: freezed == theoreticalDuration ? _self.theoreticalDuration : theoreticalDuration // ignore: cast_nullable_to_non_nullable
as Duration?,maxPressure: freezed == maxPressure ? _self.maxPressure : maxPressure // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class TruppEnd implements Trupp {
  const TruppEnd({required this.number, required this.callName, required this.leaderName, required this.memberName, required final  List<HistoryEntry> history, required this.inAction}): _history = history;
  

@override final  int number;
@override final  String callName;
@override final  String leaderName;
@override final  String memberName;
 final  List<HistoryEntry> _history;
 List<HistoryEntry> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

 final  Duration inAction;

/// Create a copy of Trupp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruppEndCopyWith<TruppEnd> get copyWith => _$TruppEndCopyWithImpl<TruppEnd>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruppEnd&&(identical(other.number, number) || other.number == number)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.leaderName, leaderName) || other.leaderName == leaderName)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.inAction, inAction) || other.inAction == inAction));
}


@override
int get hashCode => Object.hash(runtimeType,number,callName,leaderName,memberName,const DeepCollectionEquality().hash(_history),inAction);

@override
String toString() {
  return 'Trupp.end(number: $number, callName: $callName, leaderName: $leaderName, memberName: $memberName, history: $history, inAction: $inAction)';
}


}

/// @nodoc
abstract mixin class $TruppEndCopyWith<$Res> implements $TruppCopyWith<$Res> {
  factory $TruppEndCopyWith(TruppEnd value, $Res Function(TruppEnd) _then) = _$TruppEndCopyWithImpl;
@override @useResult
$Res call({
 int number, String callName, String leaderName, String memberName, List<HistoryEntry> history, Duration inAction
});




}
/// @nodoc
class _$TruppEndCopyWithImpl<$Res>
    implements $TruppEndCopyWith<$Res> {
  _$TruppEndCopyWithImpl(this._self, this._then);

  final TruppEnd _self;
  final $Res Function(TruppEnd) _then;

/// Create a copy of Trupp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? callName = null,Object? leaderName = null,Object? memberName = null,Object? history = null,Object? inAction = null,}) {
  return _then(TruppEnd(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,callName: null == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String,leaderName: null == leaderName ? _self.leaderName : leaderName // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<HistoryEntry>,inAction: null == inAction ? _self.inAction : inAction // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
