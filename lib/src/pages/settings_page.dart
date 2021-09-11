import 'package:engelsburg_app/src/constants/app_constants.dart';
import 'package:engelsburg_app/src/provider/theme.dart';
import 'package:engelsburg_app/src/widgets/color_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.settings)),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text(AppConstants.colorScheme),
            children: [
              RadioListTile<ThemeMode>(
                title: const Text(AppConstants.systemSetting),
                value: ThemeMode.system,
                groupValue: themeChanger.themeMode,
                onChanged: (themeMode) => themeChanger.clearDarkModeSetting(),
              ),
              RadioListTile<ThemeMode>(
                title: const Text(AppConstants.dark),
                value: ThemeMode.dark,
                groupValue: themeChanger.themeMode,
                onChanged: (themeMode) => themeChanger.enableDarkMode(),
              ),
              RadioListTile<ThemeMode>(
                title: const Text(AppConstants.light),
                value: ThemeMode.light,
                groupValue: themeChanger.themeMode,
                onChanged: (themeMode) => themeChanger.disableDarkMode(),
              ),
            ],
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: themeChanger.primaryColor, maxRadius: 16.0),
            title: const Text(AppConstants.primaryColor),
            subtitle: const Text(AppConstants.tapHereToChangePrimaryColor),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(AppConstants.selectPrimaryColor),
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
                      child: const Text(AppConstants.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        themeChanger.clearPrimaryColor();
                        Navigator.of(context).pop();
                      },
                      child: const Text(AppConstants.reset),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: themeChanger.secondaryColor, maxRadius: 16.0),
            title: const Text(AppConstants.secondaryColor),
            subtitle: const Text(AppConstants.tapHereToChangeSecondaryColor),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(AppConstants.selectSecondaryColor),
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
                      child: const Text(AppConstants.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        themeChanger.clearSecondaryColor();
                        Navigator.of(context).pop();
                      },
                      child: const Text(AppConstants.reset),
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
