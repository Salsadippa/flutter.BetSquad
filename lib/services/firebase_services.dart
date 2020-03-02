import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;

  signIn(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  forgotPassword(email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
