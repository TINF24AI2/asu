import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase/firestore_service.dart';
import '../firebase/firestore_provider.dart';
import '../firebase/firebase_auth_provider.dart';
import '../ui/model/settings/initial_settings.dart';

// Repository class for managing Initial Settings data in Firestore.
// Note: Initial settings are stored as a single document, not a collection.
// userId is guaranteed non-null - validation happens at provider level.
class InitialSettingsRepository {
  final FirestoreService _service;
  final String userId;

  InitialSettingsRepository(this._service, {required this.userId});

  // Stream the initial settings document.
  // Note: Uses FirebaseFirestore directly since FirestoreService only provides
  // collection streams, but initial settings is a single document.
  Stream<InitialSettingsModel?> stream() {
    return FirebaseFirestore.instance
        .collection('users/$userId/settings')
        .doc('initial')
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          return InitialSettingsModel.fromFirestoreDoc(snapshot);
        });
  }

  // Get the initial settings document once.
  Future<InitialSettingsModel?> get() async {
    final data = await _service.getData(
      collectionPath: 'users/$userId/settings',
      docId: 'initial',
    );

    if (data == null) return null;

    return InitialSettingsModel(
      defaultPressure: data['defaultPressure'] as int,
      theoreticalDurationMinutes: data['theoreticalDurationMinutes'] as int,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Set or update the initial settings.
  Future<void> save({
    required int defaultPressure,
    required int theoreticalDurationMinutes,
  }) async {
    final existing = await get();

    final model = InitialSettingsModel(
      defaultPressure: defaultPressure,
      theoreticalDurationMinutes: theoreticalDurationMinutes,
      createdAt: existing?.createdAt,
      updatedAt: null,
    );

    final data = model.toFirestore();

    if (existing == null) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _service.setData(
      collectionPath: 'users/$userId/settings',
      docId: 'initial',
      data: data,
    );
  }
}

// Provider for InitialSettingsRepository.
// Returns null when user is not authenticated (before login or after logout).
// Automatically updates when auth state changes.
final initialSettingsRepositoryProvider =
    Provider.autoDispose<InitialSettingsRepository?>((ref) {
      final service = ref.watch(firestoreServiceProvider);
      final authState = ref.watch(authStateChangesProvider);
      final authService = ref.watch(firebaseAuthServiceProvider);
      // Try to get userId from auth stream or fallback to currentUser
      final userId = authState.maybeWhen(
        data: (user) => user?.uid,
        orElse: () => authService.currentUser?.uid,
      );
      // Return null instead of throwing to avoid crashes when not authenticated
      if (userId == null) {
        return null;
      }
      return InitialSettingsRepository(service, userId: userId);
    });

// Stream provider for initial settings from Firestore.
// Emits null when:
//  - User is not authenticated
//  - Settings document doesn't exist yet
// Use this provider for reactive updates when settings change.
final initialSettingsStreamProvider = StreamProvider<InitialSettingsModel?>((
  ref,
) {
  final repository = ref.watch(initialSettingsRepositoryProvider);
  if (repository == null) {
    return Stream.value(null);
  }
  return repository.stream();
});
