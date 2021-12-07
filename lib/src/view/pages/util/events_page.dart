import 'package:engelsburg_app/src/models/api/events.dart';
import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/view/widgets/error_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatelessWidget {
  EventsPage({Key? key}) : super(key: key);

  final _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.events)),
      body: FutureBuilder<Result>(
        future: ApiService.getEvents(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.build<Events>(
              context,
              parse: (json) => Events.fromJson(json),
              onSuccess: (events) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final event = events.events[index];
                    return ListTile(
                      title: Text(event.title.toString()),
                      subtitle: event.date == null
                          ? null
                          : Text(_dateFormat.format(event.date as DateTime)),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 0);
                  },
                  itemCount: events.events.length,
                );
              },
              onError: (error) {
                if (error.isNotFound) {
                  return ErrorBox(
                      text: AppLocalizations.of(context)!.eventsNotFoundError);
                }
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
