import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asu/firebase/firestore_service.dart';
import 'package:asu/firebase/firestore_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asu/ui/model/settings/status.dart';

// Repository class for managing Status data in Firestore.
class StatusRepository {
  final FirestoreService _service;
  final String collectionPath = 'statuses';

  // Optional ID generator can be injected for tests to avoid accessing
  // FirebaseFirestore.instance during id creation.
  final String Function()? _idGenerator;

  StatusRepository(this._service, {String Function()? idGenerator})
    : _idGenerator = idGenerator;

  // Stream all Status documents as a list of Status models.
  Stream<List<StatusModel>> streamAll() {
    final col = FirebaseFirestore.instance
        .collection(collectionPath)
        .orderBy('name')
        .withConverter<StatusModel>(
          fromFirestore: (snap, _) => StatusModel.fromFirestoreDoc(snap),
          toFirestore: (model, _) => model.toFirestore(),
        );
    return col.snapshots().map(
      (snap) => snap.docs.map((d) => d.data()).toList(growable: false),
    );
  }

  // Add a new Status document with the given name.
  Future<void> add(String name) async {
    final cleaned = name.trim();
    final id =
        _idGenerator?.call() ??
        FirebaseFirestore.instance.collection(collectionPath).doc().id;
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
    final docRef = FirebaseFirestore.instance.collection(collectionPath).doc(id);
    final snap = await docRef.get();
    final existing = snap.data() ?? <String, dynamic>{};
    final merged = {...existing, ...data};
    merged['updatedAt'] = FieldValue.serverTimestamp();
    await _service.setData(
      collectionPath: collectionPath,
      docId: id,
      data: merged,
    );
  }
}

// Provider for StatusRepository to be used with Riverpod.
final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  final service = ref.read(firestoreServiceProvider);
  return StatusRepository(service);
});
