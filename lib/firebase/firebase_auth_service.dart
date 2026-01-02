import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static String errorMessageFromException(
    FirebaseAuthException e,
    bool isLogin, {
    bool? withDetails,
  }) {
    withDetails ??= !isLogin;
    final generalMessage = isLogin
        ? 'Ungültige Anmeldeinformationen. Bitte überprüfen Sie Ihre Eingaben und versuchen Sie es erneut.'
        : 'Ein Fehler ist aufgetreten. Bitte versuchen Sie es später erneut.';
    switch (e.code) {
      case 'network-request-failed':
        return 'Keine Internetverbindung. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';
      case 'too-many-requests':
        return 'Zu viele Anmeldeversuche. Bitte versuchen Sie es später erneut.';
      case 'operation-not-allowed':
        throw StateError('Email/Password Sign-In ist nicht aktiviert.');
      case 'email-already-in-use':
        if (withDetails) {
          return 'Konnte kein Konto erstellen, bitte verwenden Sie eine andere Email-Adresse.';
        } else {
          return generalMessage;
        }
      case 'invalid-email':
        if (withDetails) {
          return 'Die eingegebene Email ist ungültig.';
        } else {
          return generalMessage;
        }
      case 'weak-password':
        if (withDetails) {
          return 'Das eingegebene Passwort ist zu schwach. Bitte wählen Sie ein stärkeres Passwort.';
        } else {
          return generalMessage;
        }
      // intentional catch-all for multiple error codes as to not give too much information
      default:
        return generalMessage;
    }
  }

  //Registration
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Login
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
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
