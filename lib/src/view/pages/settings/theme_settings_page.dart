import 'package:engelsburg_app/src/models/provider/theme.dart';
import 'package:engelsburg_app/src/view/widgets/color_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
