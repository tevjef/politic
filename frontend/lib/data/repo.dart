import 'client.dart';
import 'models/states_response.dart';

class Repo {
  final ApiClient apiClient;

  Repo(this.apiClient) {

  }

  Future<List<State>> getData() {
    return apiClient.getStates();
  }
}