import 'package:engelsburg_app/src/models/engelsburg_api/dto/substitute_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/substitutes.dart';
import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:engelsburg_app/src/provider/substitute.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/utils/globals.dart' as globals;
import 'package:engelsburg_app/src/widgets/locked_screen.dart';
import 'package:engelsburg_app/src/widgets/substitute_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SubstitutesPage extends StatefulWidget {
  const SubstitutesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubstitutesPageState();
}

class _SubstitutesPageState extends State<SubstitutesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  late final PageController _pageController;
  bool overScrollLeft = false;
  DragStartDetails? dragStartDetails;
  Drag? drag;

  List<SubstituteDTO> substitutes = [];
  List<SubstituteMessage> substituteMessages = [];

  bool _onNotification(Notification notification) {
    if (notification is ScrollStartNotification) {
      dragStartDetails = notification.dragDetails;
    }
    if (notification is ScrollEndNotification) {
      drag?.cancel();
      overScrollLeft = false;
    }
    if (notification is OverscrollNotification &&
        notification.dragDetails != null &&
        notification.dragDetails!.delta.dx.abs() >
            notification.dragDetails!.delta.dy.abs()) {
      _updateDrag(notification.dragDetails!);
      overScrollLeft = true;
    }
    if (notification is ScrollUpdateNotification) {
      if (!overScrollLeft && !_controller.indexIsChanging) {
        _controller.offset = _pageController.page ?? _controller.offset;
      } else if (notification.dragDetails != null) {
        _pageController.jumpTo(0);
        _updateDrag(notification.dragDetails!);
      }
    }

    return true;
  }

  void _updateDrag(DragUpdateDetails details) {
    if (dragStartDetails != null) {
      drag = globals.pageController?.position.drag(dragStartDetails!, () {});
      drag?.update(details);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _updateSubstituteMessages();
    _updateSubstitutes();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _pageController.dispose();
  }

  Future<void> _updateSubstitutes() async {
    substitutes.clear();
    List<Substitute> fetchedSubstitutes = <Substitute>[];
    SubstituteSettings settings =
        Provider.of<SubstituteSettings>(context, listen: false);

    if (settings.isByClass || settings.isByTeacher || settings.isByTimetable) {
      Set<Substitute> substitutes = {};

      if (settings.isByClass && settings.classes.isNotEmpty) {
        for (var value in settings.classes) {
          (await ApiService.substitutesByClass(context, className: value))
              .handle<Substitutes>(
            context,
            parse: (json) => Substitutes.fromJson(json),
            onSuccess: (fetchedSubstitutes) {
              if (fetchedSubstitutes != null) {
                substitutes.addAll(fetchedSubstitutes.substitutes);
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
                substitutes.addAll(fetchedSubstitutes.substitutes);
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
                substitutes.addAll(fetchedSubstitutes.substitutes);
              }
            },
          );
        }
      }

      if (settings.isByTimetable) {
        //TODO access database, parse timetable to dto, send request
      }

      fetchedSubstitutes.addAll(substitutes.toList());
    } else {
      (await ApiService.substitutes(context)).handle<Substitutes>(
        context,
        parse: (json) => Substitutes.fromJson(json),
        onSuccess: (substitutes) {
          if (substitutes != null) {
            fetchedSubstitutes.addAll(substitutes.substitutes);
          }
        },
      );
    }

    for (var i = 0; i < fetchedSubstitutes.length; i++) {
      List<int> same = [];
      int low = 0, high = 0;
      var sub = fetchedSubstitutes[i];
      for (var ii = 0; ii < fetchedSubstitutes.length; ii++) {
        if (ii != i) {
          var compare = fetchedSubstitutes[ii];
          if (sub.date == compare.date &&
              sub.className == compare.className &&
              sub.teacher == compare.teacher &&
              sub.substituteTeacher == compare.substituteTeacher &&
              sub.room == compare.room &&
              sub.subject == compare.subject &&
              sub.type == compare.type &&
              sub.substituteOf == compare.substituteOf) {
            same.add(ii);
            if (low == 0 && high == 0) {
              if (sub.lesson! > compare.lesson!) {
                high = sub.lesson!;
              } else {
                low = compare.lesson!;
              }
            }

            if (sub.lesson! > compare.lesson!) {
              if (sub.lesson! > high) high = sub.lesson!;
              if (compare.lesson! < low) low = compare.lesson!;
            } else if (sub.lesson! < compare.lesson!) {
              if (compare.lesson! > high) high = compare.lesson!;
              if (sub.lesson! < low) low = sub.lesson!;
            }
          }
        }
      }
      if (same.isNotEmpty) {
        substitutes.add(SubstituteDTO.fromSubstitute(
          fetchedSubstitutes[same.last],
          lesson: "$low - $high",
        ));
        for (var element in same) {
          fetchedSubstitutes.removeAt(element);
        }
      } else {
        substitutes.add(SubstituteDTO.fromSubstitute(sub));
      }
    }

    substitutes.sort(SubstituteDTO.compare);
    setState(() {});
  }

  Future<void> _updateSubstituteMessages() async {
    substituteMessages.clear();
    (await ApiService.substituteMessages(context)).handle<SubstituteMessages>(
      context,
      parse: (json) => SubstituteMessages.fromJson(json),
      onSuccess: (msg) {
        if (msg != null) {
          substituteMessages = msg.substituteMessages;
        }
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AuthModel auth = Provider.of<AuthModel>(context);
    if (!auth.isLoggedIn) return const LockedScreen();
    DateFormat formatter = DateFormat('dd.MM.');

    int addedSubstituteDates = 0;

    return Scaffold(
      appBar: TabBar(
        indicatorColor: Theme.of(context).textTheme.bodyText1!.color,
        labelColor: Theme.of(context).textTheme.bodyText1!.color,
        onTap: (index) => _pageController.animateToPage(index,
            duration: kTabScrollDuration, curve: Curves.ease),
        controller: _controller,
        tabs: [
          Tab(text: AppLocalizations.of(context)!.substitutes),
          Tab(text: AppLocalizations.of(context)!.substituteMessages),
        ],
      ),
      body: NotificationListener(
        onNotification: _onNotification,
        child: PageView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            RefreshIndicator(
              child: substitutes.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (context, index) {
                        bool addText = index != 0 &&
                            substitutes[index - 1].date ==
                                substitutes[index].date;
                        if (addText) addedSubstituteDates++;

                        return Container(
                          child: addText
                              ? SubstituteCard(substitute: substitutes[index])
                              : Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            formatter.format(
                                                substitutes[index].date!),
                                            textScaleFactor: 2,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    SubstituteCard(
                                        substitute: substitutes[index])
                                  ],
                                ),
                        );
                      },
                      itemCount: substitutes.length + addedSubstituteDates,
                      padding: const EdgeInsets.all(10),
                      separatorBuilder: (_, __) => Container(height: 10),
                    )
                  : ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(50),
                            child: Text(
                                AppLocalizations.of(context)!.noSubstitutes),
                          ),
                        ),
                      ],
                    ),
              onRefresh: _updateSubstitutes,
            ),
            RefreshIndicator(
              child: substituteMessages.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (context, index) => SubstituteMessageCard(
                        substituteMessage: substituteMessages[index],
                        formatter: formatter,
                      ),
                      padding: const EdgeInsets.all(10),
                      separatorBuilder: (context, index) =>
                          Container(height: 10),
                      itemCount: substituteMessages.length,
                    )
                  : ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(50),
                            child: Text(AppLocalizations.of(context)!
                                .noSubstituteMessages),
                          ),
                        ),
                      ],
                    ),
              onRefresh: _updateSubstituteMessages,
            ),
          ],
        ),
      ),
    );
  }
}
