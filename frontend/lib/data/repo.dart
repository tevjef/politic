import 'client.dart';
import 'models/feed.dart';
import 'models/voter_roll.dart';

class Repo {
  final ApiClient apiClient;

  Repo(this.apiClient) {

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
}