import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Registration
  Future<UserCredential>
  signUpWithEmailAndPassword(
    String email, String password) async {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    }
  

  //Login
  Future<UserCredential>
  signInWithEmailAndPassword(
    String email, String password) async {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    }
  

  //Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //current User
  User? get currentUser => _auth.currentUser;

  //Auth Stream
  //checks current Auth Status
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}