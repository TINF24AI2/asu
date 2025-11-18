// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trupp.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TruppNotifier)
const truppProvider = TruppNotifierFamily._();

final class TruppNotifierProvider
    extends $NotifierProvider<TruppNotifier, TruppViewModel> {
  const TruppNotifierProvider._({
    required TruppNotifierFamily super.from,
    required (int, String, String, String, DateTime, int, int, int, Duration)
    super.argument,
  }) : super(
         retry: null,
         name: r'truppProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truppNotifierHash();

  @override
  String toString() {
    return r'truppProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TruppNotifier create() => TruppNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TruppViewModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TruppViewModel>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TruppNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truppNotifierHash() => r'd18a08673f4797400724c6b9e615ac2af916cb91';

final class TruppNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          TruppNotifier,
          TruppViewModel,
          TruppViewModel,
          TruppViewModel,
          (int, String, String, String, DateTime, int, int, int, Duration)
        > {
  const TruppNotifierFamily._()
    : super(
        retry: null,
        name: r'truppProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  TruppNotifierProvider call(
    int number,
    String callName,
    String leaderName,
    String memberName,
    DateTime start,
    int leaderPressure,
    int memberPressure,
    int maxPressure,
    Duration theoreticalDuration,
  ) => TruppNotifierProvider._(
    argument: (
      number,
      callName,
      leaderName,
      memberName,
      start,
      leaderPressure,
      memberPressure,
      maxPressure,
      theoreticalDuration,
    ),
    from: this,
  );

  @override
  String toString() => r'truppProvider';
}

abstract class _$TruppNotifier extends $Notifier<TruppViewModel> {
  late final _$args =
      ref.$arg
          as (int, String, String, String, DateTime, int, int, int, Duration);
  int get number => _$args.$1;
  String get callName => _$args.$2;
  String get leaderName => _$args.$3;
  String get memberName => _$args.$4;
  DateTime get start => _$args.$5;
  int get leaderPressure => _$args.$6;
  int get memberPressure => _$args.$7;
  int get maxPressure => _$args.$8;
  Duration get theoreticalDuration => _$args.$9;

  TruppViewModel build(
    int number,
    String callName,
    String leaderName,
    String memberName,
    DateTime start,
    int leaderPressure,
    int memberPressure,
    int maxPressure,
    Duration theoreticalDuration,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      _$args.$2,
      _$args.$3,
      _$args.$4,
      _$args.$5,
      _$args.$6,
      _$args.$7,
      _$args.$8,
      _$args.$9,
    );
    final ref = this.ref as $Ref<TruppViewModel, TruppViewModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TruppViewModel, TruppViewModel>,
              TruppViewModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
