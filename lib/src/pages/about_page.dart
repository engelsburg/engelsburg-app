import 'dart:io' show Platform;

import 'package:engelsburg_app/src/constants/app_constants.dart';
import 'package:engelsburg_app/src/constants/asset_path_constants.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'about_school_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.about)),
      body: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final packageInfo = snapshot.data;
            return ListView(
              children: <Widget>[
                ListTile(
                  leading: Image.asset(AssetPaths.appLogo),
                  title: Text(
                    packageInfo?.appName ?? AppConstants.loadingAppName,
                  ),
                  subtitle: Text(
                    packageInfo?.version ?? AppConstants.loadingAppVersion,
                  ),
                ),
                const ListTile(
                  title: Text(AppConstants.appDescription),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.star_half),
                  title: const Text(AppConstants.rateApp),
                  onTap: () => url_launcher.launch(Platform.isIOS
                      ? AppConstants.appStoreUrl
                      : AppConstants.playStoreUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text(AppConstants.sourceCodeOnGitHub),
                  onTap: () => url_launcher.launch(AppConstants.githubUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.mail),
                  title: const Text(AppConstants.sendDarioAnEmail),
                  onTap: () =>
                      url_launcher.launch('mailto:' + AppConstants.darioEmail),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text(AppConstants.openSourceLicenses),
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
                  title: const Text(AppConstants.aboutTheSchool),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutSchoolPage())),
                ),
              ],
            );
          }),
    );
  }
}
