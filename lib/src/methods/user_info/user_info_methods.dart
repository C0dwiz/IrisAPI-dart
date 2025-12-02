// user_info_methods.dart
import 'package:iris_api/iris_api.dart';

class UserInfoMethods {
  final IrisApiBase api;

  UserInfoMethods(this.api);

  Future<SpamResult> checkUserSpam(int userId) async {
    try {
      final response = await api.getRequest('user_info/spam', parameters: {
        'user_id': userId.toString(),
      });

      if (response is Map<String, dynamic>) {
        final result = response['result'] ?? {};
        return SpamResult(
          spam: result['is_spam'] ?? false,
          ignore: result['is_ignore'] ?? false,
          scam: result['is_scam'] ?? false,
        );
      }

      return SpamResult(spam: false, ignore: false, scam: false);
    } catch (e) {
      print('Error in checkUserSpam: $e');
      return SpamResult(spam: false, ignore: false, scam: false);
    }
  }

  Future<int> getRegistrationDate(int userId) async {
    try {
      final response = await api.getRequest('user_info/reg', parameters: {
        'user_id': userId.toString(),
      });
      return response?['result'] ?? 0;
    } catch (e) {
      print('Error in getRegistrationDate: $e');
      return 0;
    }
  }

  Future<ActivityResult> getUserActivity(int userId) async {
    try {
      final response = await api.getRequest('user_info/activity', parameters: {
        'user_id': userId.toString(),
      });
      return ActivityResult.fromJson(response?['result'] ?? {});
    } catch (e) {
      print('Error in getUserActivity: $e');
      return ActivityResult.fromJson({});
    }
  }

  Future<int> getUserStars(int userId) async {
    try {
      final response = await api.getRequest('user_info/stars', parameters: {
        'user_id': userId.toString(),
      });
      return response?['result'] ?? 0;
    } catch (e) {
      print('Error in getUserStars: $e');
      return 0;
    }
  }

  Future<UserPocketResult> getUserPocket(int userId) async {
    try {
      final response = await api.getRequest('user_info/pocket', parameters: {
        'user_id': userId.toString(),
      });
      return UserPocketResult.fromJson(response?['result'] ?? {});
    } catch (e) {
      print('Error in getUserPocket: $e');
      return UserPocketResult.fromJson({});
    }
  }
}
