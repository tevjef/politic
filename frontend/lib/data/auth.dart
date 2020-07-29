import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';

import 'client.dart';
import 'models/feed.dart';
import 'models/voter_roll.dart';

class Auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Auth();

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Future<void> logout() async {
    return (await _auth.currentUser()).delete();
  }

  Future<FirebaseUser> getUserOrSigninAnonymously() async {
    var currentUser = await _auth.currentUser();
    if (currentUser == null) {
      return _auth.signInAnonymously().then((value) => value?.user);
    }

    return currentUser;
  }

  Future<String> getAuthToken() async {
    var currentUser = await _auth.currentUser();
    var token = (await currentUser?.getIdToken())?.token;
    Logger.root.fine("TOKEN: " + token);
    return token;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await (await _auth.currentUser()).linkWithCredential(credential)).user;
    return user;
  }
}
