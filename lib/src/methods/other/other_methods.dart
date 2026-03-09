// other_methods.dart
import 'package:iris_api/iris_api.dart';

class OtherMethods {
  final IrisApiBase api;

  OtherMethods(this.api);

  Future<List<int>> getIrisAgents() async {
    final response = await api.getRequest('iris_agents');
    final result = response is Map<String, dynamic>
        ? (response['result'] as List<dynamic>? ?? <dynamic>[])
        : <dynamic>[];
    return result.whereType<int>().toList();
  }

  Future<String> getLastVersion() async {
    try {
      final response = await api.publicRequest('${api.baseUrl}/last_version');
      return response['result'] ?? '0.3';
    } catch (e) {
      return '0.3';
    }
  }
}
