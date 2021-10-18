import 'dart:math';

const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class StringUtils {
  static String random(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }

    return double.tryParse(s) != null;
  }
}
