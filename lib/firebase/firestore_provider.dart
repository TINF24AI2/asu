import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firestore_service.dart';

final FirestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});