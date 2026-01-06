// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryEntry {

 DateTime get date;
/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryEntryCopyWith<HistoryEntry> get copyWith => _$HistoryEntryCopyWithImpl<HistoryEntry>(this as HistoryEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryEntry&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,date);

@override
String toString() {
  return 'HistoryEntry(date: $date)';
}


}

/// @nodoc
abstract mixin class $HistoryEntryCopyWith<$Res>  {
  factory $HistoryEntryCopyWith(HistoryEntry value, $Res Function(HistoryEntry) _then) = _$HistoryEntryCopyWithImpl;
@useResult
$Res call({
 DateTime date
});




}
/// @nodoc
class _$HistoryEntryCopyWithImpl<$Res>
    implements $HistoryEntryCopyWith<$Res> {
  _$HistoryEntryCopyWithImpl(this._self, this._then);

  final HistoryEntry _self;
  final $Res Function(HistoryEntry) _then;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryEntry].
extension HistoryEntryPatterns on HistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PressureHistoryEntry value)?  pressure,TResult Function( StatusHistoryEntry value)?  status,TResult Function( LocationHistoryEntry value)?  location,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PressureHistoryEntry() when pressure != null:
return pressure(_that);case StatusHistoryEntry() when status != null:
return status(_that);case LocationHistoryEntry() when location != null:
return location(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PressureHistoryEntry value)  pressure,required TResult Function( StatusHistoryEntry value)  status,required TResult Function( LocationHistoryEntry value)  location,}){
final _that = this;
switch (_that) {
case PressureHistoryEntry():
return pressure(_that);case StatusHistoryEntry():
return status(_that);case LocationHistoryEntry():
return location(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PressureHistoryEntry value)?  pressure,TResult? Function( StatusHistoryEntry value)?  status,TResult? Function( LocationHistoryEntry value)?  location,}){
final _that = this;
switch (_that) {
case PressureHistoryEntry() when pressure != null:
return pressure(_that);case StatusHistoryEntry() when status != null:
return status(_that);case LocationHistoryEntry() when location != null:
return location(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DateTime date,  int leaderPressure,  int memberPressure)?  pressure,TResult Function( DateTime date,  String status)?  status,TResult Function( DateTime date,  String location)?  location,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PressureHistoryEntry() when pressure != null:
return pressure(_that.date,_that.leaderPressure,_that.memberPressure);case StatusHistoryEntry() when status != null:
return status(_that.date,_that.status);case LocationHistoryEntry() when location != null:
return location(_that.date,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DateTime date,  int leaderPressure,  int memberPressure)  pressure,required TResult Function( DateTime date,  String status)  status,required TResult Function( DateTime date,  String location)  location,}) {final _that = this;
switch (_that) {
case PressureHistoryEntry():
return pressure(_that.date,_that.leaderPressure,_that.memberPressure);case StatusHistoryEntry():
return status(_that.date,_that.status);case LocationHistoryEntry():
return location(_that.date,_that.location);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DateTime date,  int leaderPressure,  int memberPressure)?  pressure,TResult? Function( DateTime date,  String status)?  status,TResult? Function( DateTime date,  String location)?  location,}) {final _that = this;
switch (_that) {
case PressureHistoryEntry() when pressure != null:
return pressure(_that.date,_that.leaderPressure,_that.memberPressure);case StatusHistoryEntry() when status != null:
return status(_that.date,_that.status);case LocationHistoryEntry() when location != null:
return location(_that.date,_that.location);case _:
  return null;

}
}

}

/// @nodoc


class PressureHistoryEntry implements HistoryEntry {
  const PressureHistoryEntry({required this.date, required this.leaderPressure, required this.memberPressure});
  

@override final  DateTime date;
 final  int leaderPressure;
 final  int memberPressure;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PressureHistoryEntryCopyWith<PressureHistoryEntry> get copyWith => _$PressureHistoryEntryCopyWithImpl<PressureHistoryEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PressureHistoryEntry&&(identical(other.date, date) || other.date == date)&&(identical(other.leaderPressure, leaderPressure) || other.leaderPressure == leaderPressure)&&(identical(other.memberPressure, memberPressure) || other.memberPressure == memberPressure));
}


@override
int get hashCode => Object.hash(runtimeType,date,leaderPressure,memberPressure);

@override
String toString() {
  return 'HistoryEntry.pressure(date: $date, leaderPressure: $leaderPressure, memberPressure: $memberPressure)';
}


}

/// @nodoc
abstract mixin class $PressureHistoryEntryCopyWith<$Res> implements $HistoryEntryCopyWith<$Res> {
  factory $PressureHistoryEntryCopyWith(PressureHistoryEntry value, $Res Function(PressureHistoryEntry) _then) = _$PressureHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int leaderPressure, int memberPressure
});




}
/// @nodoc
class _$PressureHistoryEntryCopyWithImpl<$Res>
    implements $PressureHistoryEntryCopyWith<$Res> {
  _$PressureHistoryEntryCopyWithImpl(this._self, this._then);

  final PressureHistoryEntry _self;
  final $Res Function(PressureHistoryEntry) _then;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? leaderPressure = null,Object? memberPressure = null,}) {
  return _then(PressureHistoryEntry(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,leaderPressure: null == leaderPressure ? _self.leaderPressure : leaderPressure // ignore: cast_nullable_to_non_nullable
as int,memberPressure: null == memberPressure ? _self.memberPressure : memberPressure // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class StatusHistoryEntry implements HistoryEntry {
  const StatusHistoryEntry({required this.date, required this.status});
  

@override final  DateTime date;
 final  String status;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusHistoryEntryCopyWith<StatusHistoryEntry> get copyWith => _$StatusHistoryEntryCopyWithImpl<StatusHistoryEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusHistoryEntry&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,date,status);

@override
String toString() {
  return 'HistoryEntry.status(date: $date, status: $status)';
}


}

/// @nodoc
abstract mixin class $StatusHistoryEntryCopyWith<$Res> implements $HistoryEntryCopyWith<$Res> {
  factory $StatusHistoryEntryCopyWith(StatusHistoryEntry value, $Res Function(StatusHistoryEntry) _then) = _$StatusHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, String status
});




}
/// @nodoc
class _$StatusHistoryEntryCopyWithImpl<$Res>
    implements $StatusHistoryEntryCopyWith<$Res> {
  _$StatusHistoryEntryCopyWithImpl(this._self, this._then);

  final StatusHistoryEntry _self;
  final $Res Function(StatusHistoryEntry) _then;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? status = null,}) {
  return _then(StatusHistoryEntry(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LocationHistoryEntry implements HistoryEntry {
  const LocationHistoryEntry({required this.date, required this.location});
  

@override final  DateTime date;
 final  String location;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationHistoryEntryCopyWith<LocationHistoryEntry> get copyWith => _$LocationHistoryEntryCopyWithImpl<LocationHistoryEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationHistoryEntry&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location));
}


@override
int get hashCode => Object.hash(runtimeType,date,location);

@override
String toString() {
  return 'HistoryEntry.location(date: $date, location: $location)';
}


}

/// @nodoc
abstract mixin class $LocationHistoryEntryCopyWith<$Res> implements $HistoryEntryCopyWith<$Res> {
  factory $LocationHistoryEntryCopyWith(LocationHistoryEntry value, $Res Function(LocationHistoryEntry) _then) = _$LocationHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, String location
});




}
/// @nodoc
class _$LocationHistoryEntryCopyWithImpl<$Res>
    implements $LocationHistoryEntryCopyWith<$Res> {
  _$LocationHistoryEntryCopyWithImpl(this._self, this._then);

  final LocationHistoryEntry _self;
  final $Res Function(LocationHistoryEntry) _then;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? location = null,}) {
  return _then(LocationHistoryEntry(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
