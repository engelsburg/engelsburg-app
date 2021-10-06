import 'package:engelsburg_app/src/provider/substitute.dart';
import 'package:engelsburg_app/src/provider/theme.dart';
import 'package:engelsburg_app/src/widgets/color_grid.dart';
import 'package:engelsburg_app/src/widgets/switch_expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
            leading: Icon(Icons.brush_outlined),
            title: Text(AppLocalizations.of(context)!.themeSettings),
            onTap: () => Navigator.pushNamed(context, "/settings/theme"),
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text(AppLocalizations.of(context)!.substitutes),
            onTap: () => Navigator.pushNamed(context, "/settings/substitutes"),
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text(AppLocalizations.of(context)!.notificationSettings),
            onTap: () =>
                Navigator.pushNamed(context, "/settings/notifications"),
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}

class SubstitutesSettingsPage extends StatefulWidget {
  const SubstitutesSettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubstitutesSettingsPageState();
}

class _SubstitutesSettingsPageState extends State<SubstitutesSettingsPage>
    with TickerProviderStateMixin {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SubstituteSettings>(context);
    enabled = settings.isByTeacher;
    var height = !enabled ? 0.0 : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.substitutes),
      ),
      body: ListView(
        children: [
          SwitchListExpandable(
            switchListTile: SwitchListTile(
              value: enabled,
              onChanged: (value) {
                enabled = value;
                settings.setByTeacher(value);
              },
              title: Text("Teacher"), //TODO: Replace
            ),
            vsync: this,
            curve: Curves.decelerate,
            child: Column(
              children: [
                ListTile(
                  title: Text("sujgahaujigb"),
                ),
                ListTile(
                  title: Text("sujgahaujigb"),
                ),
                ListTile(
                  title: Text("sujgahaujigb"),
                ),
                ListTile(
                  title: Text("sujgahaujigb"),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          ListTile(
            title: Text("sagaga"),
          )
        ],
      ),
    );
  }
}

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notificationSettings),
      ),
    );
  }
}

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({Key? key}) : super(key: key);

  @override
  _ThemeSettingsPageState createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.themeSettings),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text(AppLocalizations.of(context)!.colorScheme),
            children: [
              RadioListTile<ThemeMode>(
                title: Text(AppLocalizations.of(context)!.systemSetting),
                value: ThemeMode.system,
                groupValue: themeChanger.themeMode,
                onChanged: (themeMode) => themeChanger.clearDarkModeSetting(),
              ),
              RadioListTile<ThemeMode>(
                title: Text(AppLocalizations.of(context)!.dark),
                value: ThemeMode.dark,
                groupValue: themeChanger.themeMode,
                onChanged: (themeMode) => themeChanger.enableDarkMode(),
              ),
              RadioListTile<ThemeMode>(
                title: Text(AppLocalizations.of(context)!.light),
                value: ThemeMode.light,
                groupValue: themeChanger.themeMode,
                onChanged: (themeMode) => themeChanger.disableDarkMode(),
              ),
            ],
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: themeChanger.primaryColor, maxRadius: 16.0),
            title: Text(AppLocalizations.of(context)!.primaryColor),
            subtitle:
                Text(AppLocalizations.of(context)!.tapHereToChangePrimaryColor),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.selectPrimaryColor),
                  content: SizedBox(
                    width: 300,
                    child: ColorGrid(
                      currentColor: themeChanger.primaryColor,
                      onColorSelected: (color) {
                        themeChanger.setPrimaryColor(color);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        themeChanger.clearPrimaryColor();
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.reset),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: themeChanger.secondaryColor, maxRadius: 16.0),
            title: Text(AppLocalizations.of(context)!.secondaryColor),
            subtitle: Text(
                AppLocalizations.of(context)!.tapHereToChangeSecondaryColor),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title:
                      Text(AppLocalizations.of(context)!.selectSecondaryColor),
                  content: SizedBox(
                    width: 300,
                    child: ColorGrid(
                      currentColor: themeChanger.secondaryColor,
                      onColorSelected: (color) {
                        themeChanger.setSecondaryColor(color);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        themeChanger.clearSecondaryColor();
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.reset),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
