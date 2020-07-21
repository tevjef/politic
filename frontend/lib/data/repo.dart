import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:politic/data/auth.dart';
import 'package:politic/data/notifications.dart';
import 'package:politic/ui/util/lib.dart';

import 'client.dart';
import 'models/feed.dart';
import 'models/voter_roll.dart';

class Repo {
  final ApiClient apiClient;
  final NotificationRepo notificationRepo;
  final Auth auth;

  Repo(this.apiClient, this.auth, this.notificationRepo);

  Future<List<USState>> getData() {
    return apiClient.getStates();
  }

  Future<StateFeedResponse> getStatesFeed(String state) {
    return apiClient.getStatesFeed(state);
  }

  Future<VoterStatus> checkRegistration(CheckRegistrationRequest request) {
    return apiClient.checkRegistration(request);
  }

  Future<FirebaseUser> signIn() async {
    return auth.getUserOrSigninAnonymously();
  }

  Future<Null> saveVoterInformation(VoterInformation voterInformation) async {
    var notificationToken = await notificationRepo.getToken();
    return apiClient.saveVoterEnrollment(EnrollmentRequest(
        enrollment: Enrollment(voterInformation: voterInformation, notificationToken: notificationToken)));
  }
}
