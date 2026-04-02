import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  Future<void> saveRemeberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remeberMe', value);
  }

  Future<void> removeRemeberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remeberMe');
  }

  Future<bool> getRemeberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remeberMe') ?? false;
  }
}
