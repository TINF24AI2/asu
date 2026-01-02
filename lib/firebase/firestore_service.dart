import 'package:cloud_firestore/cloud_firestore.dart';

//IMPORTANT: reading/ writing from the DB is not possible without being authenticated because of Firestore rules


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

//generate ID
String generateId() {
  return _db.collection('temp').doc().id;
}

//write
Future<void> setData({
  required String collectionPath,
  required String docId,
  required Map<String, dynamic> data,
}) async {
  await _db.collection(collectionPath).doc(docId).set(data);
}

//read
Future <Map<String, dynamic>?> getData({
  required String collectionPath,
  required String docId,
}) async {
  final doc = await _db.collection(collectionPath).doc(docId).get();
  return doc.data();
}

//delete
Future<void> deleteData({
  required String collectionPath,
  required String docId,
}) async {
  await _db.collection(collectionPath).doc(docId).delete();
} 

//Stream (live changes)
Stream<List<Map<String, dynamic>>>
collectionStream({
  required String collectionPath,
}) {
  return _db.collection(collectionPath).snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),);
}

//Stream with type conversion
Stream<List<T>> collectionStreamTyped<T>({
  required String collectionPath,
  required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
  required Map<String, dynamic> Function(T, SetOptions?) toFirestore,
  String? orderBy,
}) {
  final col = _db.collection(collectionPath).withConverter(fromFirestore: fromFirestore, toFirestore: toFirestore);
  final Query<T> query = orderBy != null ? col.orderBy(orderBy) : col;
  return query.snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList(growable: false));
}
}