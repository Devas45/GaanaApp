import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repo.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepo authLocalRepo(AuthLocalRepoRef ref) {
  return AuthLocalRepo();
}

class AuthLocalRepo {
  late SharedPreferences _sharedPrefernces;
  Future<void> init() async {
    _sharedPrefernces = await SharedPreferences.getInstance();
  }

  void setToken(String? token) {
    if (token != null) {
      _sharedPrefernces.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    return _sharedPrefernces.getString('x-auth-token');
  }
}
