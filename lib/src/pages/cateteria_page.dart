import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/widgets/error_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            return snapshot.data!.build<String>(
              context,
              parse: (json) => json['content'],
              onSuccess: (content) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: HtmlWidget(content),
                  ),
                );
              },
              onError: (error) {
                if (error.isNotFound) {
                  return ErrorBox(
                      text: AppLocalizations.of(context)!
                          .cafeteriaPageNotFoundError);
                }
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
