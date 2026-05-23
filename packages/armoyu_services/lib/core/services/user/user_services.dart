part of 'package:armoyu_services/armoyu_services.dart';

class UserServices {
  final String? Function() getToken;
  final void Function(String? token) setToken;

  final String apiKey;
  final bool usePreviousAPI;

  late final ApiHelpers _apiHelpers;

  UserServices(
      {required this.getToken,
      required this.setToken,
      required this.apiKey,
      required this.usePreviousAPI}) {
    _apiHelpers = ApiHelpers(apiKey: apiKey, usePreviousAPI: usePreviousAPI);
  }

  Future<Map<String, dynamic>> getUsers() async {
    return await _apiHelpers.get(
      endpoint: _EndpointConstants.users,
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
  }

  Future<Map<String, dynamic>> deleteUser({required int userId}) async {
    return await _apiHelpers.delete(
      endpoint: '${_EndpointConstants.users}/$userId',
      headers: _apiHelpers.getRequestHeader(token: getToken()),
    );
  }

  Future<Map<String, dynamic>> addFriend({
    required AddFriendRequestModel addFriendRequestModel,
  }) async {
    return await _apiHelpers.post(
      endpoint: '${_EndpointConstants.users}/friends',
      headers: _apiHelpers.getRequestHeader(token: getToken()),
      body: addFriendRequestModel.toMap(),
    );
  }
}
