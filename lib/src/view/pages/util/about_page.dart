import 'dart:io' show Platform;

import 'package:engelsburg_app/src/utils/constants/app_constants.dart';
import 'package:engelsburg_app/src/utils/constants/asset_path_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.about)),
      body: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final packageInfo = snapshot.data;
            return ListView(
              children: <Widget>[
                ListTile(
                  leading: Image.asset(AssetPaths.appLogo),
                  title: Text(
                    packageInfo?.appName ??
                        AppLocalizations.of(context)!.loadingAppName,
                  ),
                  subtitle: Text(
                    packageInfo?.version ??
                        AppLocalizations.of(context)!.loadingAppVersion,
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.appDescription),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.star_half),
                  title: Text(AppLocalizations.of(context)!.rateApp),
                  onTap: () => url_launcher.launch(Platform.isIOS
                      ? AppConstants.appStoreUrl
                      : AppConstants.playStoreUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(AppLocalizations.of(context)!.sourceCodeOnGitHub),
                  onTap: () => url_launcher.launch(AppConstants.githubUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.mail),
                  title: Text(AppLocalizations.of(context)!.sendDarioAnEmail),
                  onTap: () =>
                      url_launcher.launch('mailto:' + AppConstants.darioEmail),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(AppLocalizations.of(context)!.openSourceLicenses),
                  onTap: () => showLicensePage(
                    applicationIcon: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        AssetPaths.appLogo,
                        height: 64.0,
                      ),
                    ),
                    applicationName: packageInfo?.appName,
                    applicationVersion: packageInfo?.version,
                    context: context,
                  ),
                ),
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.school),
                    title: Text(AppLocalizations.of(context)!.aboutTheSchool),
                    onTap: () => Navigator.pushNamed(context, "/aboutSchool")),
              ],
            );
          }),
    );
  }
}
