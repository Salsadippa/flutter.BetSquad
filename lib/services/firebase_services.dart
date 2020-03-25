import 'package:betsquad/services/networking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  NetworkHelper cloudFunctionsNetworkHelper =
      NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);

  signIn(String email, String password,
      {@required Function onSuccess,
      @required Function bannedCallback,
      @required Function onError}) async {

    Map<String, String> parameters = {'userEmail': email};
    Map<String, Object> bannedInfo = await cloudFunctionsNetworkHelper.getJSON(
        'checkIfUserIsBanned', parameters);
    if (bannedInfo != null) {
      bool bannedUntil = bannedInfo["banned"];
      if (bannedUntil) {
        bannedCallback(bannedInfo["until"]);
      }
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  signOut(){
    _auth.signOut();
  }

  forgotPassword(email,
      {@required Function onSuccess,
      @required Function onError}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  signUp(Map<String, Object> userDetails, {@required Function onSuccess, @required Function onError}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: userDetails["email"], password: userDetails["password"]);
    } catch (e) {
      onError(e);
    }

    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    userDetails['userID'] = uid;
    userDetails.remove('password');

    if (userDetails['image'] != null)
      userDetails['image'] =
          await uploadProfilePhoto(userDetails['image'], uid);

    var parameters = userDetails.map((k, v) => MapEntry(k, v.toString()));
    print(parameters);
    await cloudFunctionsNetworkHelper.getJSON(
        'writeNewUserToDatabase', parameters);
    onSuccess();
  }

  Future<String> uploadProfilePhoto(var image, var uid) async {
    StorageReference firebaseStorageReference =
        FirebaseStorage.instance.ref().child('profilePicture/$uid/image');
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(image);
    var download = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = download.toString();
    return url;
  }

  Future<bool> loggedInUser() async {
    var user = await _auth.currentUser();
    return user != null;
  }

}
