import '../../data/client.dart';

class Repo {
  final ApiClient apiClient;

  Repo(this.apiClient) {

  }

  Future<String> getData() {
    return apiClient.getData();
  }
}