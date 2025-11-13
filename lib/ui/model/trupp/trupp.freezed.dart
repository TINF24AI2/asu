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
mixin _$TruppViewModel {

 int get number; String get callName; String get leaderName; String get memberName; List<HistoryEntry> get history; Duration get sinceStart; Duration? get potentialEnd; Duration get theoreticalEnd; Duration get nextCheck; int get lowestPressure; int get lowestStartPressure; int get maxPressure; List<AlarmType> get alarms;
/// Create a copy of TruppViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruppViewModelCopyWith<TruppViewModel> get copyWith => _$TruppViewModelCopyWithImpl<TruppViewModel>(this as TruppViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruppViewModel&&(identical(other.number, number) || other.number == number)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.leaderName, leaderName) || other.leaderName == leaderName)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.sinceStart, sinceStart) || other.sinceStart == sinceStart)&&(identical(other.potentialEnd, potentialEnd) || other.potentialEnd == potentialEnd)&&(identical(other.theoreticalEnd, theoreticalEnd) || other.theoreticalEnd == theoreticalEnd)&&(identical(other.nextCheck, nextCheck) || other.nextCheck == nextCheck)&&(identical(other.lowestPressure, lowestPressure) || other.lowestPressure == lowestPressure)&&(identical(other.lowestStartPressure, lowestStartPressure) || other.lowestStartPressure == lowestStartPressure)&&(identical(other.maxPressure, maxPressure) || other.maxPressure == maxPressure)&&const DeepCollectionEquality().equals(other.alarms, alarms));
}


@override
int get hashCode => Object.hash(runtimeType,number,callName,leaderName,memberName,const DeepCollectionEquality().hash(history),sinceStart,potentialEnd,theoreticalEnd,nextCheck,lowestPressure,lowestStartPressure,maxPressure,const DeepCollectionEquality().hash(alarms));

@override
String toString() {
  return 'TruppViewModel(number: $number, callName: $callName, leaderName: $leaderName, memberName: $memberName, history: $history, sinceStart: $sinceStart, potentialEnd: $potentialEnd, theoreticalEnd: $theoreticalEnd, nextCheck: $nextCheck, lowestPressure: $lowestPressure, lowestStartPressure: $lowestStartPressure, maxPressure: $maxPressure, alarms: $alarms)';
}


}

/// @nodoc
abstract mixin class $TruppViewModelCopyWith<$Res>  {
  factory $TruppViewModelCopyWith(TruppViewModel value, $Res Function(TruppViewModel) _then) = _$TruppViewModelCopyWithImpl;
@useResult
$Res call({
 String callName, String leaderName, String memberName, List<HistoryEntry> history, int number, Duration sinceStart, Duration? potentialEnd, Duration theoreticalEnd, Duration nextCheck, int lowestPressure, int lowestStartPressure, int maxPressure, List<AlarmType> alarms
});




}
/// @nodoc
class _$TruppViewModelCopyWithImpl<$Res>
    implements $TruppViewModelCopyWith<$Res> {
  _$TruppViewModelCopyWithImpl(this._self, this._then);

  final TruppViewModel _self;
  final $Res Function(TruppViewModel) _then;

/// Create a copy of TruppViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callName = null,Object? leaderName = null,Object? memberName = null,Object? history = null,Object? number = null,Object? sinceStart = null,Object? potentialEnd = freezed,Object? theoreticalEnd = null,Object? nextCheck = null,Object? lowestPressure = null,Object? lowestStartPressure = null,Object? maxPressure = null,Object? alarms = null,}) {
  return _then(TruppViewModel(
callName: null == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String,leaderName: null == leaderName ? _self.leaderName : leaderName // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<HistoryEntry>,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,sinceStart: null == sinceStart ? _self.sinceStart : sinceStart // ignore: cast_nullable_to_non_nullable
as Duration,potentialEnd: freezed == potentialEnd ? _self.potentialEnd : potentialEnd // ignore: cast_nullable_to_non_nullable
as Duration?,theoreticalEnd: null == theoreticalEnd ? _self.theoreticalEnd : theoreticalEnd // ignore: cast_nullable_to_non_nullable
as Duration,nextCheck: null == nextCheck ? _self.nextCheck : nextCheck // ignore: cast_nullable_to_non_nullable
as Duration,lowestPressure: null == lowestPressure ? _self.lowestPressure : lowestPressure // ignore: cast_nullable_to_non_nullable
as int,lowestStartPressure: null == lowestStartPressure ? _self.lowestStartPressure : lowestStartPressure // ignore: cast_nullable_to_non_nullable
as int,maxPressure: null == maxPressure ? _self.maxPressure : maxPressure // ignore: cast_nullable_to_non_nullable
as int,alarms: null == alarms ? _self.alarms : alarms // ignore: cast_nullable_to_non_nullable
as List<AlarmType>,
  ));
}

}


/// Adds pattern-matching-related methods to [TruppViewModel].
extension TruppViewModelPatterns on TruppViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
