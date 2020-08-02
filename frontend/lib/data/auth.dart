import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class Auth {
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
}
