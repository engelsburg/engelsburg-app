import 'dart:convert';

import 'package:engelsburg_app/src/models/engelsburg_api/dto/auth_info_dto.dart';
import 'package:engelsburg_app/src/utils/html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OauthLoginPage extends StatelessWidget {
  const OauthLoginPage({Key? key, required this.url, this.schoolToken})
      : super(key: key);

  static const userAgent =
      "Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36";
  final String url;
  final String? schoolToken;

  @override
  Widget build(BuildContext context) {
    String parsedSchoolToken;
    if (schoolToken == null || schoolToken!.isEmpty) {
      parsedSchoolToken = "";
    } else {
      parsedSchoolToken = "?schoolToken=" + schoolToken!;
    }

    WebViewController? webController;

    var webView = WebView(
      initialUrl: url + parsedSchoolToken,
      javascriptMode: JavascriptMode.unrestricted,
      userAgent: userAgent,
      onWebViewCreated: (controller) => webController = controller,
      gestureNavigationEnabled: true,
      onPageFinished: (url) async {
        if (url.startsWith("https://engelsburg-api.de")) {
          String? html = await webController?.evaluateJavascript(
              "window.document.getElementsByTagName('body')[0].innerHTML;");
          if (html != null) {
            html = HtmlUtil.unescape(html)
                .replaceAll("\\", "")
                .substring(html.indexOf("{"), html.lastIndexOf("}") + 1);
            Navigator.pop(context, AuthInfoDTO.fromJson(jsonDecode(html)));
          }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signIn),
      ),
      body: webView,
    );
  }
}
