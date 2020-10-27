import 'package:betsquad/services/networking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
    NetworkHelper appEngineNetworkHelper = NetworkHelper(BASE_URL.GOOGLE_APP_ENGINE);

    try {
      await _auth.createUserWithEmailAndPassword(
          email: userDetails["email"], password: userDetails["password"]);
    } catch (e) {
      onError(e);
    }

    final User user = _auth.currentUser;
    final uid = user.uid;

    userDetails['balance'] = 0.0;
    userDetails['uid'] = uid;
    userDetails.remove('password');

    if (userDetails['image'] != null && userDetails['image'] != '') {
      userDetails['image'] =
      await uploadProfilePhotoForNewUser(userDetails['image'], uid);
    } else {
      userDetails['image'] = '';
    }

    var parameters = userDetails.map((k, v) => MapEntry(k, v.toString()));
    print(parameters);
    await cloudFunctionsNetworkHelper.getJSON(
        'writeNewUserToDatabase', parameters);

    Map<String, String> p = {'userEmail': userDetails['email']};
    Map<String, Object> bannedInfo = await cloudFunctionsNetworkHelper.getJSON(
        'checkIfUserIsBanned', p);

    var token = await user.getIdToken();
    var params = {'userID': uid, 'auth': token};
    print(params);
    var res = await appEngineNetworkHelper.getJSON('amlCheck', params);
    print(res);
    onSuccess();
  }

  Future<String> uploadProfilePhotoForNewUser(var image, var uid) async {
    if (image == null) {return null;}
    StorageReference firebaseStorageReference =
        FirebaseStorage.instance.ref().child('profilePicture/$uid/image');
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(image);
    var download = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = download.toString();
    return url;
  }

  Future<void> uploadProfilePhotoForExistingUser(var image) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    StorageReference firebaseStorageReference =
    FirebaseStorage.instance.ref().child('profilePicture/$uid/image');
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(image);
    var download = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = download.toString();
    return await FirebaseDatabase.instance.reference().child('users').child(uid).child('image').set(url);
  }

  Future<bool> loggedInUser() async {
    var user =  _auth.currentUser;
    return user != null;
  }

  Future<User> currentUser() async {
    var user = _auth.currentUser;
    return user;
  }

  Future<bool> deleteUser(String email, String password) async {
    try {
      User user = _auth.currentUser;
      AuthCredential credentials =
      EmailAuthProvider.getCredential(email: email, password: password);
      print(user);
      var result = await user.reauthenticateWithCredential(credentials);
      //delete user from database
      await result.user.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

}
