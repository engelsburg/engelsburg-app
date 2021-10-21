import 'package:engelsburg_app/src/services/shared_prefs.dart';
import 'package:flutter/foundation.dart';

class AuthModel extends ChangeNotifier {
  final _prefs = SharedPrefs.instance!;

  bool get isLoggedIn =>
      _prefs.getString('access_token') != null &&
      _prefs.getString('refresh_token') != null;
  bool get isVerified => _prefs.getBool('verified') ?? false;
  set verified(bool verified) => _prefs.setBool('verified', verified);

  String? get accessToken => _prefs.getString('access_token');
  String? get refreshToken => _prefs.getString('refresh_token');

  void setTokenPair({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString('access_token', accessToken);
    await _prefs.setString('refresh_token', refreshToken);
    notifyListeners();
  }

  void clearTokenPair() async {
    await _prefs.remove('access_token');
    await _prefs.remove('refresh_token');
    notifyListeners();
  }
}
