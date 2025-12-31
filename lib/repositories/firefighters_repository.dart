import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase/firestore_service.dart';
import '../firebase/firestore_provider.dart';
import '../firebase/firebase_auth_provider.dart';
import '../ui/model/settings/firefighter.dart';

// Repository class for managing Firefighter data in Firestore.
class FirefightersRepository {
  final FirestoreService _service;
  final String userId;

  String get collectionPath => 'users/$userId/firefighters';

  // Optional ID generator function for creating new document IDs.
  final String Function()? _idGenerator;

  FirefightersRepository(
    this._service, {
    required this.userId,
    String Function()? idGenerator,
  }) : _idGenerator = idGenerator;

  // Stream all Firefighter documents as a list of Firefighter models.
  Stream<List<FirefighterModel>> streamAll() {
    return _service.collectionStreamTyped<FirefighterModel>(
      collectionPath: collectionPath,
      fromFirestore: (snap, _) => FirefighterModel.fromFirestoreDoc(snap),
      toFirestore: (model, _) => model.toFirestore(),
      orderBy: 'name',
    );
  }

  // Add a new Firefighter document with the given name.
  Future<void> add(String name) async {
    final cleaned = name.trim();
    final id = _idGenerator?.call() ?? _service.generateId();
    final model = FirefighterModel(id: id, name: cleaned, createdAt: null);
    final data = model.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _service.setData(
      collectionPath: collectionPath,
      docId: id,
      data: data,
    );
  }

  // Update an existing Firefighter document with the given data.
  Future<void> update(String id, Map<String, dynamic> data) async {
    final existing =
        await _service.getData(collectionPath: collectionPath, docId: id) ??
        <String, dynamic>{};
    final merged = {...existing, ...data};
    merged['updatedAt'] = FieldValue.serverTimestamp();
    await _service.setData(
      collectionPath: collectionPath,
      docId: id,
      data: merged,
    );
  }

  // Delete a Firefighter document.
  Future<void> delete(String id) async {
    await _service.deleteData(collectionPath: collectionPath, docId: id);
  }
}

// Provider for FirefightersRepository to be used with Riverpod.
// Watches auth state to ensure repository updates when user changes.
// Returns null when user is not authenticated.
final firefightersRepositoryProvider =
    Provider.autoDispose<FirefightersRepository?>((ref) {
      final service = ref.watch(firestoreServiceProvider);
      final authState = ref.watch(authStateChangesProvider);
      final userId = authState.maybeWhen(
        data: (user) => user?.uid,
        orElse: () => ref.watch(firebaseAuthServiceProvider).currentUser?.uid,
      );
      if (userId == null) {
        return null;
      }
      return FirefightersRepository(service, userId: userId);
    });

// Stream provider for all firefighters.
// Returns empty list when user is not authenticated.
final firefightersStreamProvider = StreamProvider<List<FirefighterModel>>((
  ref,
) {
  final repository = ref.watch(firefightersRepositoryProvider);
  if (repository == null) {
    return Stream.value([]);
  }
  return repository.streamAll();
});
