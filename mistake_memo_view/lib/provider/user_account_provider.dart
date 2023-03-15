import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserAccountGlobalState {
  final String authToken;
  final String userId;
  final String userName;
  final String? iconImageUrl;

  UserAccountGlobalState(
      {required this.authToken,
      required this.userId,
      required this.userName,
      this.iconImageUrl});
}

final userAccountProvider =
    StateProvider<UserAccountGlobalState?>((ref) => null);
