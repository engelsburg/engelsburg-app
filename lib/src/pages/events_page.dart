import 'package:engelsburg_app/src/constants/app_constants.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/events.dart';
import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatelessWidget {
  EventsPage({Key? key}) : super(key: key);

  final _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.events)),
      body: FutureBuilder<Result>(
        future: ApiService.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!
                .handle<Events>((json) => Events.fromJson(json), (error) {
              if (error.isNotFound()) {
                return ApiError.errorBox('Events not found!');
              }
            }, (events) {
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
            });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
