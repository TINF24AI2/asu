import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asu/firebase/firestore_service.dart';
import 'package:asu/firebase/firestore_provider.dart';
import 'package:asu/firebase/firebase_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asu/ui/model/settings/status.dart';

// Repository class for managing Status data in Firestore.
class StatusRepository {
  final FirestoreService _service;
  final String userId;

  String get collectionPath => 'users/$userId/statuses';

  // Optional ID generator function for creating new document IDs.
  final String Function()? _idGenerator;

  StatusRepository(
    this._service, {
    required this.userId,
    String Function()? idGenerator,
  }) : _idGenerator = idGenerator;

  // Stream all Status documents as a list of Status models.
  Stream<List<StatusModel>> streamAll() {
    return _service.collectionStreamTyped<StatusModel>(
      collectionPath: collectionPath,
      fromFirestore: (snap, _) => StatusModel.fromFirestoreDoc(snap),
      toFirestore: (model, _) => model.toFirestore(),
      orderBy: 'name',
    );
  }

  // Add a new Status document with the given name.
  Future<void> add(String name) async {
    final cleaned = name.trim();
    final id = _idGenerator?.call() ?? _service.generateId();
    final model = StatusModel(id: id, name: cleaned, createdAt: null);
    final data = model.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _service.setData(
      collectionPath: collectionPath,
      docId: id,
      data: data,
    );
  }

  // Update an existing Status document with the given data.
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

  // Delete a Status document.
  Future<void> delete(String id) async {
    await _service.deleteData(collectionPath: collectionPath, docId: id);
  }
}

// Provider for StatusRepository to be used with Riverpod.
final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  final service = ref.read(firestoreServiceProvider);
  final authService = ref.read(firebaseAuthServiceProvider);
  final userId = authService.currentUser?.uid ?? '';
  return StatusRepository(service, userId: userId);
});
