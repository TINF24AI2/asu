import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase/firestore_service.dart';
import '../firebase/firestore_provider.dart';
import '../firebase/firebase_auth_provider.dart';
import '../ui/model/settings/radio_call.dart';

// Repository class for managing Radio Call data in Firestore.
class RadioCallRepository {
  final FirestoreService _service;
  final String userId;

  String get collectionPath => 'users/$userId/radio_calls';

  // Optional ID generator function for creating new document IDs.
  final String Function()? _idGenerator;

  RadioCallRepository(
    this._service, {
    required this.userId,
    String Function()? idGenerator,
  }) : _idGenerator = idGenerator;

  // Stream all Radio Call documents as a list of RadioCall models.
  Stream<List<RadioCallModel>> streamAll() {
    return _service.collectionStreamTyped<RadioCallModel>(
      collectionPath: collectionPath,
      fromFirestore: (snap, _) => RadioCallModel.fromFirestoreDoc(snap),
      toFirestore: (model, _) => model.toFirestore(),
      orderBy: 'name',
    );
  }

  // Add a new Radio Call document with the given name.
  Future<void> add(String name) async {
    final cleaned = name.trim();
    final id = _idGenerator?.call() ?? _service.generateId();
    final model = RadioCallModel(id: id, name: cleaned, createdAt: null);
    final data = model.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _service.setData(
      collectionPath: collectionPath,
      docId: id,
      data: data,
    );
  }

  // Update an existing Radio Call document with the given data.
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

  // Delete a Radio Call document.
  Future<void> delete(String id) async {
    await _service.deleteData(collectionPath: collectionPath, docId: id);
  }
}

// Provider for RadioCallRepository to be used with Riverpod.
// Watches auth state to ensure repository updates when user changes.
// Returns null when user is not authenticated.
final radioCallRepositoryProvider = Provider.autoDispose<RadioCallRepository?>((
  ref,
) {
  final service = ref.watch(firestoreServiceProvider);
  final authState = ref.watch(authStateChangesProvider);
  final userId = authState.maybeWhen(
    data: (user) => user?.uid,
    orElse: () => ref.watch(firebaseAuthServiceProvider).currentUser?.uid,
  );
  if (userId == null) {
    return null;
  }
  return RadioCallRepository(service, userId: userId);
});

// Stream provider for all radio calls.
// Returns empty list when user is not authenticated.
final radioCallsStreamProvider = StreamProvider<List<RadioCallModel>>((ref) {
  final repository = ref.watch(radioCallRepositoryProvider);
  if (repository == null) {
    return Stream.value([]);
  }
  return repository.streamAll();
});
