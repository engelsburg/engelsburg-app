import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.brush_outlined),
            title: Text(AppLocalizations.of(context)!.themeSettings),
            onTap: () => Navigator.pushNamed(context, "/settings/theme"),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(AppLocalizations.of(context)!.substitutes),
            onTap: () => Navigator.pushNamed(context, "/settings/substitutes"),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(AppLocalizations.of(context)!.notificationSettings),
            onTap: () =>
                Navigator.pushNamed(context, "/settings/notifications"),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
