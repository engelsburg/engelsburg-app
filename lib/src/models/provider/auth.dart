import 'package:engelsburg_app/src/models/api/dto/auth_info_dto.dart';
import 'package:engelsburg_app/src/services/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AuthModel extends ChangeNotifier {
  final _prefs = SharedPrefs.instance!;

  bool get isLoggedIn =>
      _prefs.getString('access_token') != null &&
      _prefs.getString('refresh_token') != null;

  String? get accessToken => _prefs.getString('access_token');
  String? get refreshToken => _prefs.getString('refresh_token');
  bool get isVerified => _prefs.getBool('verified') ?? false;
  String? get email => _prefs.getString("email");

  void set(AuthInfoDTO dto) async {
    await _prefs.setString('access_token', dto.token!);
    await _prefs.setString('refresh_token', dto.refreshToken!);
    await _prefs.setBool("verified", dto.verified!);
    await _prefs.setString("email", dto.email!);
    notifyListeners();
  }

  void clear() async {
    await _prefs.remove('access_token');
    await _prefs.remove('refresh_token');
    await _prefs.remove('verified');
    await _prefs.remove('email');
    notifyListeners();
  }
}
