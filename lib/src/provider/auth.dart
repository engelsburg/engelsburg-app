import 'package:engelsburg_app/src/services/shared_prefs.dart';
import 'package:flutter/foundation.dart';

class AuthModel extends ChangeNotifier {
  bool isLoggedIn = SharedPrefs.instance!.getString('access_token') != null &&
      SharedPrefs.instance!.getString('refresh_token') != null;

  void setTokenPair({
    required String accessToken,
    required String refreshToken,
  }) async {
    await SharedPrefs.instance!.setString('access_token', accessToken);
    await SharedPrefs.instance!.setString('refresh_token', refreshToken);
    notifyListeners();
  }

  void clearTokenPair() async {
    await SharedPrefs.instance!.remove('access_token');
    await SharedPrefs.instance!.remove('refresh_token');
    notifyListeners();
  }
}
