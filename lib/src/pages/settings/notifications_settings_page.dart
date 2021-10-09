import 'package:engelsburg_app/src/provider/notification.dart';
import 'package:engelsburg_app/src/widgets/switch_expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  TextEditingController classController = TextEditingController(),
      teacherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NotificationSettings settings = Provider.of<NotificationSettings>(context);

    Column switches = Column(
      children: [
        const Divider(height: 20),
        SwitchListTile(
          value: settings.articles,
          title: Text(AppLocalizations.of(context)!.articles),
          onChanged: (value) => settings.setArticles(value),
        ),
        SwitchExpandable(
          switchListTile: SwitchListTile(
            value: settings.substitutes.enabled,
            title: Text(AppLocalizations.of(context)!.substitutes),
            onChanged: (value) => settings.substitutes.setEnabled(value),
          ),
          child: Column(
            children: [
              const Divider(height: 20),
              SwitchExpandable(
                invert: true,
                switchListTile: SwitchListTile(
                  value: settings.substitutes.asSubstituteSettings,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: Icon(Icons.sync_outlined),
                        ),
                        Text(AppLocalizations.of(context)!.syncWithFilter),
                      ],
                    ),
                  ),
                  onChanged: (value) =>
                      settings.substitutes.setAsSubstituteSettings(value),
                ),
                child: Column(
                  children: [
                    SwitchExpandable(
                      switchListTile: SwitchListTile(
                        value: settings.substitutes.isByClass,
                        onChanged: (bool value) {
                          settings.substitutes.setByClass(value);
                        },
                        title: Text(AppLocalizations.of(context)!.class_),
                      ),
                      curve: Curves.decelerate,
                      child: Column(
                        children: [
                          if (settings.substitutes.classes != null &&
                              settings.substitutes.classes!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Wrap(
                                  runAlignment: WrapAlignment.start,
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children:
                                      settings.substitutes.classes!.map((e) {
                                    Color color =
                                        Theme.of(context).colorScheme.secondary;
                                    return Chip(
                                      label: Text(e.toUpperCase(),
                                          style: TextStyle(color: color)),
                                      deleteIconColor: color,
                                      shape: StadiumBorder(
                                          side: BorderSide(color: color)),
                                      onDeleted: () {
                                        final classes =
                                            settings.substitutes.classes;
                                        if (classes != null) {
                                          classes.remove(e);
                                          settings.substitutes
                                              .setClasses(classes);
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
                                final classes =
                                    settings.substitutes.classes ?? [];
                                if (!classes.contains(text)) classes.add(text);
                                settings.substitutes.setClasses(classes);
                                classController.clear();
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: Text(AppLocalizations.of(context)!.add),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      classController.clear();
                                    },
                                    child: const Icon(Icons.clear_outlined,
                                        size: 24),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SwitchExpandable(
                      switchListTile: SwitchListTile(
                        value: settings.substitutes.isByTeacher,
                        onChanged: (value) {
                          settings.substitutes.setByTeacher(value);
                        },
                        title: Text(AppLocalizations.of(context)!.teacher),
                      ),
                      curve: Curves.decelerate,
                      child: Column(
                        children: [
                          if (settings.substitutes.teacher != null &&
                              settings.substitutes.teacher!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Wrap(
                                  runAlignment: WrapAlignment.start,
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children:
                                      settings.substitutes.teacher!.map((e) {
                                    Color color =
                                        Theme.of(context).colorScheme.secondary;
                                    return Chip(
                                      label: Text(e.toUpperCase(),
                                          style: TextStyle(color: color)),
                                      deleteIconColor: color,
                                      shape: StadiumBorder(
                                          side: BorderSide(color: color)),
                                      onDeleted: () {
                                        final teacher =
                                            settings.substitutes.teacher;
                                        if (teacher != null) {
                                          teacher.remove(e);
                                          settings.substitutes
                                              .setTeacher(teacher);
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
                                final teacher =
                                    settings.substitutes.teacher ?? [];
                                if (!teacher.contains(text)) teacher.add(text);
                                settings.substitutes.setTeacher(teacher);
                                teacherController.clear();
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: Text(AppLocalizations.of(context)!.add),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      teacherController.clear();
                                    },
                                    child: const Icon(Icons.clear_outlined,
                                        size: 24),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SwitchListTile(
                      value: settings.substitutes.isByTimetable,
                      onChanged: (value) {
                        settings.substitutes.setByTimetable(value);
                      },
                      title: Text(AppLocalizations.of(context)!.timetable),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notificationSettings),
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: settings.enabled,
            title: Text(AppLocalizations.of(context)!.allowNotifications),
            onChanged: (value) => settings.setEnabled(value),
          ),
          settings.enabled
              ? switches
              : AbsorbPointer(
                  absorbing: true,
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.grey[600]!, BlendMode.srcATop),
                    child: switches,
                  ),
                ),
        ],
      ),
    );
  }
}
