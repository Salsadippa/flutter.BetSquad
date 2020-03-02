import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {

  final _auth = FirebaseAuth.instance;

  signIn(String email, String password) async {
      return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

}