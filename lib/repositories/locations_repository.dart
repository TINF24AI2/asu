import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase/firestore_service.dart';
import '../firebase/firestore_provider.dart';
import '../firebase/firebase_auth_provider.dart';
import '../ui/model/settings/location.dart';

// Repository class for managing Location data in Firestore.
class LocationsRepository {
  final FirestoreService _service;
  final String userId;

  String get collectionPath => 'users/$userId/locations';

  // Optional ID generator function for creating new document IDs.
  final String Function()? _idGenerator;

  LocationsRepository(
    this._service, {
    required this.userId,
    String Function()? idGenerator,
  }) : _idGenerator = idGenerator;

  // Stream all Location documents as a list of Location models.
  Stream<List<LocationModel>> streamAll() {
    return _service.collectionStreamTyped<LocationModel>(
      collectionPath: collectionPath,
      fromFirestore: (snap, _) => LocationModel.fromFirestoreDoc(snap),
      toFirestore: (model, _) => model.toFirestore(),
      orderBy: 'name',
    );
  }

  // Add a new Location document with the given name.
  Future<void> add(String name) async {
    final cleaned = name.trim();
    final id = _idGenerator?.call() ?? _service.generateId();
    final model = LocationModel(id: id, name: cleaned, createdAt: null);
    final data = model.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _service.setData(
      collectionPath: collectionPath,
      docId: id,
      data: data,
    );
  }

  // Update an existing Location document with the given data.
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

  // Delete a Location document.
  Future<void> delete(String id) async {
    await _service.deleteData(collectionPath: collectionPath, docId: id);
  }
}

// Provider for LocationsRepository to be used with Riverpod.
// Watches auth state to ensure repository updates when user changes
final locationsRepositoryProvider = Provider.autoDispose<LocationsRepository>((
  ref,
) {
  final service = ref.watch(firestoreServiceProvider);
  final authState = ref.watch(authStateChangesProvider);
  final userId = authState.value!.uid;
  return LocationsRepository(service, userId: userId);
});

// Stream provider for all locations.
final locationsStreamProvider = StreamProvider<List<LocationModel>>((ref) {
  final repository = ref.watch(locationsRepositoryProvider);
  return repository.streamAll();
});
