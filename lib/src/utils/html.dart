import 'package:html_unescape/html_unescape.dart';

class HtmlUtil {
  static String unescape(text) => HtmlUnescape()
      .convert(text)
      // remove all newlines
      .replaceAll(RegExp(r'[\n]+'), ' ')
      // remove all html tags
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .trim();
}
