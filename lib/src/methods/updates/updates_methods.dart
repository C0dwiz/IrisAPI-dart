import 'package:iris_api/iris_api.dart';

class UpdatesMethods {
  final IrisApiBase api;

  UpdatesMethods(this.api);

  Future<List<UpdateEvent>> getUpdates(GetUpdatesRequest request) async {
    final response = await api.postRequest('getUpdates', parameters: {
      'offset': request.offset.toString(),
      'limit': request.limit.toString(),
    });
    return (response as List).map((e) => UpdateEvent.fromJson(e)).toList();
  }

  Stream<UpdateEvent> get updateStream async* {
    int lastOffset = 0;

    while (true) {
      try {
        final updates = await getUpdates(GetUpdatesRequest(
          offset: lastOffset,
          limit: 100,
        ));

        if (updates.isNotEmpty) {
          lastOffset = updates.last.id + 1;
        }

        for (final update in updates) {
          yield update;
        }

        await Future.delayed(Duration(seconds: 1));
      } catch (e) {
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }
}
