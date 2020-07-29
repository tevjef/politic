import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:politic/data/auth.dart';
import 'package:politic/data/models/user.dart';
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

  Future<FirebaseUser> signIn() async {
    return auth.getUserOrSigninAnonymously();
  }

  Future<bool> isSignedIn() async {
    return (await auth.getCurrentUser()) != null;
  }

  Future<String> userEmail() async {
    return (await auth.getCurrentUser()).email;
  }

  Future<bool> isAnonymous() async {
    return auth.getCurrentUser().then((value) => value.isAnonymous);
  }

  Future<Null>signinWithGoogle() async {
    return auth.signInWithGoogle().then((value) => null);
  }

  Future<void> logout() async {
    return auth.logout();
  }

  Future<List<USState>> getData() {
    return apiClient.getStates();
  }

  Future<StateFeedResponse> getStatesFeed(String state) {
    return apiClient.getStatesFeed(state);
  }

  Future<VoterStatus> checkRegistration(CheckRegistrationRequest request) {
    return apiClient.checkRegistration(request);
  }

  Future<void> manualRegistration() async {
    var notificationToken = await notificationRepo.getToken();
    return apiClient
        .manualEnrollment(ManualEnrollmentRequest(enrollment: ManualEnrollment(notificationToken: notificationToken)));
  }

  Future<Null> saveVoterInformation(VoterInformation voterInformation) async {
    var notificationToken = await notificationRepo.getToken();
    return apiClient.saveVoterEnrollment(EnrollmentRequest(
        enrollment: Enrollment(voterInformation: voterInformation, notificationToken: notificationToken)));
  }

  Future<Null> saveLocation(LocationLatLng locationLatLng) async {
    return apiClient.saveLocation(LocationUpdateRequest(locationUpdate: locationLatLng)).then((value) => null);
  }

  Future<DistrictLocation> getLocation() async {
    return apiClient.getLocation();
  }

  Future<RepresentativesResponse> getRepresentatives() async {
    return apiClient.getRepresentatives();
  }

  Future<ElectionResponse> getUserElection() async {
    return apiClient.getUserElection();
  }

  Future<ElectionResponse> getElection(int electionsId) async {
    return apiClient.getElection(electionsId);
  }

  Future<ElectionsResponse> getElections() async {
    return apiClient.getElections();
  }
}
