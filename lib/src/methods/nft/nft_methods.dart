import 'package:iris_api/iris_api.dart';

class NftMethods {
  final IrisApiBase api;

  NftMethods(this.api);

  List<dynamic> _extractResultList(dynamic response) {
    if (response is Map<String, dynamic> && response['result'] is List) {
      return response['result'] as List<dynamic>;
    }
    if (response is List) {
      return response;
    }
    return <dynamic>[];
  }

  Future<int> give(NftGiveRequest request) async {
    final response = await api.postRequest('nft/give', parameters: request.toParams());
    return response['result'] is int ? response['result'] as int : 0;
  }

  Future<NftItem> info(NftQuery request) async {
    final response = await api.getRequest('nft/info', parameters: request.toParams());
    final result = response is Map<String, dynamic>
        ? (response['result'] as Map<String, dynamic>? ?? <String, dynamic>{})
        : <String, dynamic>{};
    return NftItem.fromJson(result);
  }

  Future<List<NftItem>> list(NftListRequest request) async {
    final response = await api.getRequest('nft/list', parameters: request.toParams());
    return _extractResultList(response)
        .whereType<Map<String, dynamic>>()
        .map(NftItem.fromJson)
        .toList();
  }

  Future<List<NftHistoryEntry>> history(NftListRequest request) async {
    final response = await api.getRequest('nft/history', parameters: request.toParams());
    return _extractResultList(response)
        .whereType<Map<String, dynamic>>()
        .map(NftHistoryEntry.fromJson)
        .toList();
  }
}
