import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asu/firebase/firebase_auth_service.dart';


//Provider for Auth Service
//use with 'ref.read' or 'ref.watch'
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref){
  return FirebaseAuthService();
});

//Provider for Auth Stream
final authStateChangesProvider = StreamProvider((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  return authService.authStateChanges;
});