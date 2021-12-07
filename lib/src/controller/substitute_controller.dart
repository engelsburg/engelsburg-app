import 'package:engelsburg_app/src/models/api/dto/substitute_dto.dart';
import 'package:engelsburg_app/src/models/api/substitutes.dart';
import 'package:engelsburg_app/src/models/provider/substitute.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class SubstituteController {
  final List<SubstituteDTO> _substitutes = [];
  final List<SubstituteMessage> _substituteMessages = [];
  final void Function(VoidCallback callback) setStateCallback;

  SubstituteController({required this.setStateCallback});

  List<SubstituteDTO> get substitutes => _substitutes;
  List<SubstituteMessage> get substituteMessages => _substituteMessages;

  Future<void> updateSubstitutes(
      BuildContext context, SubstituteSettings settings) async {
    _substitutes.clear();
    List<Substitute> substitutes = <Substitute>[];

    if (settings.isByClass || settings.isByTeacher || settings.isByTimetable) {
      Set<Substitute> substituteSet = {};

      if (settings.isByClass && settings.classes.isNotEmpty) {
        for (var value in settings.classes) {
          (await ApiService.substitutesByClass(context, className: value))
              .handle<Substitutes>(
            context,
            parse: (json) => Substitutes.fromJson(json),
            onSuccess: (fetchedSubstitutes) {
              if (fetchedSubstitutes != null) {
                substituteSet.addAll(fetchedSubstitutes.substitutes);
              }
            },
          );
        }
      }

      if (settings.isByTeacher && settings.teacher.isNotEmpty) {
        for (var value in settings.teacher) {
          (await ApiService.substitutesByTeacher(context, teacher: value))
              .handle<Substitutes>(
            context,
            parse: (json) => Substitutes.fromJson(json),
            onSuccess: (fetchedSubstitutes) {
              if (fetchedSubstitutes != null) {
                substituteSet.addAll(fetchedSubstitutes.substitutes);
              }
            },
          );

          (await ApiService.substitutesBySubstituteTeacher(context,
                  substituteTeacher: value))
              .handle<Substitutes>(
            context,
            parse: (json) => Substitutes.fromJson(json),
            onSuccess: (fetchedSubstitutes) {
              if (fetchedSubstitutes != null) {
                substituteSet.addAll(fetchedSubstitutes.substitutes);
              }
            },
          );
        }
      }

      if (settings.isByTimetable) {
        //TODO access database, parse timetable to dto, send request
      }

      substitutes.addAll(substituteSet.toList());
    } else {
      (await ApiService.substitutes(context)).handle<Substitutes>(
        context,
        parse: (json) => Substitutes.fromJson(json),
        onSuccess: (fetchedSubstitutes) {
          if (fetchedSubstitutes != null) {
            substitutes.addAll(fetchedSubstitutes.substitutes);
          }
        },
      );
    }

    for (var i = 0; i < substitutes.length; i++) {
      List<int> same = [];
      int low = 0, high = 0;
      var sub = substitutes[i];
      for (var ii = 0; ii < substitutes.length; ii++) {
        if (ii != i) {
          var compare = substitutes[ii];
          if (sub.date == compare.date &&
              sub.className == compare.className &&
              sub.teacher == compare.teacher &&
              sub.substituteTeacher == compare.substituteTeacher &&
              sub.room == compare.room &&
              sub.subject == compare.subject &&
              sub.type == compare.type &&
              sub.substituteOf == compare.substituteOf) {
            same.add(ii);

            if (sub.lesson! > compare.lesson!) {
              high = sub.lesson!;
              low = compare.lesson!;
            } else if (sub.lesson! < compare.lesson!) {
              high = compare.lesson!;
              low = sub.lesson!;
            }
          }
        }
      }
      if (same.isNotEmpty) {
        _substitutes.add(SubstituteDTO.fromSubstitute(
          substitutes[same.last],
          lesson: "$low - $high",
        ));
        for (var element in same) {
          substitutes.removeAt(element);
        }
      } else {
        _substitutes.add(SubstituteDTO.fromSubstitute(sub));
      }
    }

    _substitutes.sort(SubstituteDTO.compare);
    setStateCallback(() {});
  }

  Future<void> updateSubstituteMessages(BuildContext context) async {
    _substituteMessages.clear();
    (await ApiService.substituteMessages(context)).handle<SubstituteMessages>(
      context,
      parse: (json) => SubstituteMessages.fromJson(json),
      onSuccess: (msg) {
        if (msg != null) {
          _substituteMessages.addAll(msg.substituteMessages);
        }
      },
    );
    setStateCallback(() {});
  }
}
