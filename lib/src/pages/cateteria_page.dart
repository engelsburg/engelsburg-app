import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CafeteriaPage extends StatefulWidget {
  const CafeteriaPage({Key? key}) : super(key: key);

  @override
  _CafeteriaPageState createState() => _CafeteriaPageState();
}

class _CafeteriaPageState extends State<CafeteriaPage>
    with AutomaticKeepAliveClientMixin<CafeteriaPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder<Result>(
        future: ApiService.getCafeteria(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.handle<String>((json) => json['content'],
                (error) {
              if (error.isNotFound()) {
                return ApiError.errorBox('Cafeteria page not found!');
              }
            }, (content) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(content),
                ),
              );
            });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
