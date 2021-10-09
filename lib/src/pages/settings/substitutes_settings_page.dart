import 'package:engelsburg_app/src/provider/substitute.dart';
import 'package:engelsburg_app/src/widgets/switch_expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SubstitutesSettingsPage extends StatefulWidget {
  const SubstitutesSettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubstitutesSettingsPageState();
}

class _SubstitutesSettingsPageState extends State<SubstitutesSettingsPage> {
  TextEditingController classController = TextEditingController(),
      teacherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SubstituteSettings>(context);

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
          SwitchExpandable(
            switchListTile: SwitchListTile(
              value: settings.isByClass,
              onChanged: (bool value) {
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
          SwitchExpandable(
            switchListTile: SwitchListTile(
              value: settings.isByTeacher,
              onChanged: (value) {
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
            value: settings.isByTimetable,
            onChanged: (value) {
              settings.setByTimetable(value);
            },
            title: Text(AppLocalizations.of(context)!.timetable),
          ),
        ],
      ),
    );
  }
}
