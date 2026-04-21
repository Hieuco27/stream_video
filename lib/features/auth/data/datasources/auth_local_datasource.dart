import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  Future<void> saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
  }

  Future<void> removeRemeberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('rememberMe');
  }

  Future<bool> getRemeberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberMe') ?? false;
  }
}
