import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asu/firebase/firestore_service.dart';
import 'package:asu/firebase/firestore_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asu/ui/model/settings/radio_call.dart';

// Repository class for managing Radio Call data in Firestore.
class RadioCallRepository {
  final FirestoreService _service;
  final String collectionPath = 'radio_calls';

  // Optional ID generator can be injected for tests to avoid accessing
  // FirebaseFirestore.instance during id creation.
  final String Function()? _idGenerator;

  RadioCallRepository(this._service, {String Function()? idGenerator})
    : _idGenerator = idGenerator;

  // Stream all Radio Call documents as a list of RadioCall models.
  Stream<List<RadioCallModel>> streamAll() {
    final col = FirebaseFirestore.instance
        .collection(collectionPath)
        .orderBy('name')
        .withConverter<RadioCallModel>(
          fromFirestore: (snap, _) => RadioCallModel.fromFirestoreDoc(snap),
          toFirestore: (model, _) => model.toFirestore(),
        );
    return col.snapshots().map(
      (snap) => snap.docs.map((d) => d.data()).toList(growable: false),
    );
  }

  // Add a new Radio Call document with the given name.
  Future<void> add(String name) async {
    final cleaned = name.trim();
    final id =
        _idGenerator?.call() ??
        FirebaseFirestore.instance.collection(collectionPath).doc().id;
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

// Provider for RadioCallRepository to be used with Riverpod.
final radioCallRepositoryProvider = Provider<RadioCallRepository>((ref) {
  final service = ref.read(firestoreServiceProvider);
  return RadioCallRepository(service);
});
