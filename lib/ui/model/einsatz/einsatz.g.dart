// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'einsatz.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EinsatzNotifier)
const einsatzProvider = EinsatzNotifierProvider._();

final class EinsatzNotifierProvider
    extends $NotifierProvider<EinsatzNotifier, TruppList> {
  const EinsatzNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'einsatzProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$einsatzNotifierHash();

  @$internal
  @override
  EinsatzNotifier create() => EinsatzNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TruppList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TruppList>(value),
    );
  }
}

String _$einsatzNotifierHash() => r'2f21ec13a4f1661649f445043484696b75a3c590';

abstract class _$EinsatzNotifier extends $Notifier<TruppList> {
  TruppList build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TruppList, TruppList>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TruppList, TruppList>,
              TruppList,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
