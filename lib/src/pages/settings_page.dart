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

class _SubstitutesSettingsPageState extends State<SubstitutesSettingsPage> {
  TextEditingController classController = TextEditingController(),
      teacherController = TextEditingController();
  bool class_ = false, teacher = false, timetable = false;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SubstituteSettings>(context);
    class_ = settings.isByClass;
    teacher = settings.isByTeacher;
    timetable = settings.isByTimetable;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.substitutes),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.filterBy + ":",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.2,
            ),
          ),
          SwitchListTileExpandable(
            switchListTile: SwitchListTile(
              value: class_,
              onChanged: (bool value) {
                class_ = value;
                settings.setByClass(value);
              },
              title: Text(AppLocalizations.of(context)!.class_),
            ),
            curve: Curves.decelerate,
            child: Column(
              children: [
                if (settings.classes != null && settings.classes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        runAlignment: WrapAlignment.start,
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: settings.classes!.map((e) {
                          Color color = Theme.of(context).colorScheme.secondary;
                          return Chip(
                            label: Text(e.toUpperCase(),
                                style: TextStyle(color: color)),
                            deleteIconColor: color,
                            shape:
                                StadiumBorder(side: BorderSide(color: color)),
                            onDeleted: () {
                              final classes = settings.classes;
                              if (classes != null) {
                                classes.remove(e);
                                settings.setClasses(classes);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: classController,
                    onFieldSubmitted: (text) {
                      final classes = settings.classes ?? [];
                      if (!classes.contains(text)) classes.add(text);
                      settings.setClasses(classes);
                      classController.clear();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!.add),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: () {
                            classController.clear();
                          },
                          child: const Icon(Icons.clear_outlined, size: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          SwitchListTileExpandable(
            switchListTile: SwitchListTile(
              value: teacher,
              onChanged: (value) {
                teacher = value;
                settings.setByTeacher(value);
              },
              title: Text(AppLocalizations.of(context)!.teacher),
            ),
            curve: Curves.decelerate,
            child: Column(
              children: [
                if (settings.teacher != null && settings.teacher!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        runAlignment: WrapAlignment.start,
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: settings.teacher!.map((e) {
                          Color color = Theme.of(context).colorScheme.secondary;
                          return Chip(
                            label: Text(e.toUpperCase(),
                                style: TextStyle(color: color)),
                            deleteIconColor: color,
                            shape:
                                StadiumBorder(side: BorderSide(color: color)),
                            onDeleted: () {
                              final teacher = settings.teacher;
                              if (teacher != null) {
                                teacher.remove(e);
                                settings.setTeacher(teacher);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: teacherController,
                    onFieldSubmitted: (text) {
                      final teacher = settings.teacher ?? [];
                      if (!teacher.contains(text)) teacher.add(text);
                      settings.setTeacher(teacher);
                      teacherController.clear();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!.add),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: () {
                            teacherController.clear();
                          },
                          child: const Icon(Icons.clear_outlined, size: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          SwitchListTile(
            value: timetable,
            onChanged: (value) {
              timetable = value;
              settings.setByTimetable(value);
            },
            title: Text(AppLocalizations.of(context)!.timetable),
          ),
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
