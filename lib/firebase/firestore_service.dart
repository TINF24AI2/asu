import 'package:cloud_firestore/cloud_firestore.dart';

//IMPORTANT: reading/ writing from the DB is not possible without being authenticated because of Firestore rules


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

//Stream (live changes)
Stream<List<Map<String, dynamic>>>
collectionStream({
  required String collectionPath,
}) {
  return _db.collection(collectionPath).snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),);
}
}