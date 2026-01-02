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
    extends $NotifierProvider<EinsatzNotifier, Einsatz> {
  const EinsatzNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'einsatzProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$einsatzNotifierHash();

  @$internal
  @override
  EinsatzNotifier create() => EinsatzNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Einsatz value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Einsatz>(value),
    );
  }
}

String _$einsatzNotifierHash() => r'8bf657b06e27e6ffb3db204e65c8de3c0f887924';

abstract class _$EinsatzNotifier extends $Notifier<Einsatz> {
  Einsatz build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Einsatz, Einsatz>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Einsatz, Einsatz>,
              Einsatz,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
