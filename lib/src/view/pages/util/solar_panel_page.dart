import 'package:engelsburg_app/src/models/api/solar_panel.dart';
import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/view/widgets/error_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class SolarPanelPage extends StatefulWidget {
  const SolarPanelPage({Key? key}) : super(key: key);

  @override
  _SolarPanelPageState createState() => _SolarPanelPageState();
}

class _SolarPanelPageState extends State<SolarPanelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.solarPanelData),
      ),
      body: FutureBuilder<Result>(
        future: ApiService.getSolarSystemData(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.build<SolarPanel>(
              context,
              parse: (json) => SolarPanel.fromJson(json),
              onSuccess: (solarPanelData) {
                final _iconBoxes = [
                  _iconBox(
                      const Icon(Icons.calendar_today, size: 56),
                      AppLocalizations.of(context)!.date,
                      (solarPanelData.date).toString()),
                  _iconBox(
                      const Icon(Icons.lightbulb_outline, size: 56),
                      AppLocalizations.of(context)!.energy,
                      (solarPanelData.energy).toString()),
                  _iconBox(
                      const Icon(Icons.landscape, size: 56),
                      AppLocalizations.of(context)!.avoidedCO2,
                      (solarPanelData.co2Avoidance).toString()),
                  _iconBox(
                      const Icon(Icons.monetization_on, size: 56),
                      AppLocalizations.of(context)!.renumeration,
                      (solarPanelData.payment).toString() + '€'),
                ];

                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.zero,
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (constraints.maxWidth > 400) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _iconBoxes,
                            ),
                          );
                        }
                        return GridView.count(
                          padding: const EdgeInsets.all(16.0),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                          children: _iconBoxes,
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: HtmlWidget(
                        (solarPanelData.text).toString(),
                        textStyle: const TextStyle(height: 1.5, fontSize: 18.0),
                      ),
                    )
                  ],
                );
              },
              onError: (error) {
                if (error.isNotFound) {
                  return ErrorBox(
                      text: AppLocalizations.of(context)!
                          .solarPanelPageNotFoundError);
                }
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _iconBox(Icon icon, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        Text(title),
        const Padding(padding: EdgeInsets.only(top: 8.0)),
        Text(description)
      ],
    );
  }
}
