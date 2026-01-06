// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'einsatz.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Einsatz {

 Map<int, Trupp> get trupps; Map<int, List<Alarm>> get alarms;
/// Create a copy of Einsatz
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EinsatzCopyWith<Einsatz> get copyWith => _$EinsatzCopyWithImpl<Einsatz>(this as Einsatz, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Einsatz&&const DeepCollectionEquality().equals(other.trupps, trupps)&&const DeepCollectionEquality().equals(other.alarms, alarms));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(trupps),const DeepCollectionEquality().hash(alarms));

@override
String toString() {
  return 'Einsatz(trupps: $trupps, alarms: $alarms)';
}


}

/// @nodoc
abstract mixin class $EinsatzCopyWith<$Res>  {
  factory $EinsatzCopyWith(Einsatz value, $Res Function(Einsatz) _then) = _$EinsatzCopyWithImpl;
@useResult
$Res call({
 Map<int, Trupp> trupps, Map<int, List<Alarm>> alarms
});




}
/// @nodoc
class _$EinsatzCopyWithImpl<$Res>
    implements $EinsatzCopyWith<$Res> {
  _$EinsatzCopyWithImpl(this._self, this._then);

  final Einsatz _self;
  final $Res Function(Einsatz) _then;

/// Create a copy of Einsatz
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trupps = null,Object? alarms = null,}) {
  return _then(_self.copyWith(
trupps: null == trupps ? _self.trupps : trupps // ignore: cast_nullable_to_non_nullable
as Map<int, Trupp>,alarms: null == alarms ? _self.alarms : alarms // ignore: cast_nullable_to_non_nullable
as Map<int, List<Alarm>>,
  ));
}

}


/// Adds pattern-matching-related methods to [Einsatz].
extension EinsatzPatterns on Einsatz {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Einsatz value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Einsatz() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Einsatz value)  $default,){
final _that = this;
switch (_that) {
case _Einsatz():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Einsatz value)?  $default,){
final _that = this;
switch (_that) {
case _Einsatz() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<int, Trupp> trupps,  Map<int, List<Alarm>> alarms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Einsatz() when $default != null:
return $default(_that.trupps,_that.alarms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<int, Trupp> trupps,  Map<int, List<Alarm>> alarms)  $default,) {final _that = this;
switch (_that) {
case _Einsatz():
return $default(_that.trupps,_that.alarms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<int, Trupp> trupps,  Map<int, List<Alarm>> alarms)?  $default,) {final _that = this;
switch (_that) {
case _Einsatz() when $default != null:
return $default(_that.trupps,_that.alarms);case _:
  return null;

}
}

}

/// @nodoc


class _Einsatz implements Einsatz {
  const _Einsatz({final  Map<int, Trupp> trupps = const {}, final  Map<int, List<Alarm>> alarms = const {}}): _trupps = trupps,_alarms = alarms;
  

 final  Map<int, Trupp> _trupps;
@override@JsonKey() Map<int, Trupp> get trupps {
  if (_trupps is EqualUnmodifiableMapView) return _trupps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_trupps);
}

 final  Map<int, List<Alarm>> _alarms;
@override@JsonKey() Map<int, List<Alarm>> get alarms {
  if (_alarms is EqualUnmodifiableMapView) return _alarms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_alarms);
}


/// Create a copy of Einsatz
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EinsatzCopyWith<_Einsatz> get copyWith => __$EinsatzCopyWithImpl<_Einsatz>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Einsatz&&const DeepCollectionEquality().equals(other._trupps, _trupps)&&const DeepCollectionEquality().equals(other._alarms, _alarms));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_trupps),const DeepCollectionEquality().hash(_alarms));

@override
String toString() {
  return 'Einsatz(trupps: $trupps, alarms: $alarms)';
}


}

/// @nodoc
abstract mixin class _$EinsatzCopyWith<$Res> implements $EinsatzCopyWith<$Res> {
  factory _$EinsatzCopyWith(_Einsatz value, $Res Function(_Einsatz) _then) = __$EinsatzCopyWithImpl;
@override @useResult
$Res call({
 Map<int, Trupp> trupps, Map<int, List<Alarm>> alarms
});




}
/// @nodoc
class __$EinsatzCopyWithImpl<$Res>
    implements _$EinsatzCopyWith<$Res> {
  __$EinsatzCopyWithImpl(this._self, this._then);

  final _Einsatz _self;
  final $Res Function(_Einsatz) _then;

/// Create a copy of Einsatz
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trupps = null,Object? alarms = null,}) {
  return _then(_Einsatz(
trupps: null == trupps ? _self._trupps : trupps // ignore: cast_nullable_to_non_nullable
as Map<int, Trupp>,alarms: null == alarms ? _self._alarms : alarms // ignore: cast_nullable_to_non_nullable
as Map<int, List<Alarm>>,
  ));
}


}

// dart format on
